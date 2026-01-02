//
//  OSCHandlerProtocol.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OSCKitCore

/// Internal protocol that TCP or UDP based receiver OSC classes adopt in order to handle incoming OSC data.
protocol _OSCHandlerProtocol: AnyObject where Self: Sendable {
    var queue: DispatchQueue { get }
    var _bundleMode: OSCBundleMode { get }
    var receiveHandler: OSCHandlerBlock? { get }
    var receiveBundleHandler: OSCBundleHandlerBlock? { get }
}

// MARK: - Handle and Dispatch

extension _OSCHandlerProtocol {
    /// Handle incoming OSC data recursively.
    func _handle(
        packet: OSCPacket,
        timeTag: OSCTimeTag = .immediate(),
        timeTagMode: OSCTimeTagMode? = nil,
        remoteHost: String,
        remotePort: UInt16
    ) {
        queue.async {
            switch packet {
            case let .bundle(bundle):
                // If present, previously unwrapped bundle
                if let timeTagMode {
                    for element in bundle.elements {
                        self._handle(
                            packet: element,
                            timeTag: bundle.timeTag,
                            timeTagMode: timeTagMode,
                            remoteHost: remoteHost,
                            remotePort: remotePort
                        )
                    }
                } else {
                    switch self._bundleMode {
                    case .forward:
                        self._dispatch(bundle, remoteHost: remoteHost, remotePort: remotePort)
                    case .unwrap(let timeTagMode):
                        for element in bundle.elements {
                            self._handle(
                                packet: element,
                                timeTag: bundle.timeTag,
                                timeTagMode: timeTagMode,
                                remoteHost: remoteHost,
                                remotePort: remotePort
                            )
                        }
                    }
                }
            case let .message(message):
                self._schedule(
                    message,
                    at: timeTag,
                    timeTagMode: timeTagMode ?? .ignore,
                    remoteHost: remoteHost,
                    remotePort: remotePort
                )
            }
        }
    }
    
    private func _schedule(
        _ message: OSCMessage,
        at timeTag: OSCTimeTag = .immediate(),
        timeTagMode: OSCTimeTagMode = .ignore,
        remoteHost: String,
        remotePort: UInt16
    ) {
        switch timeTagMode {
        case .ignore:
            _dispatch(message, timeTag: timeTag, remoteHost: remoteHost, remotePort: remotePort)
            
        case .osc1_0:
            // TimeTag of 1 has special meaning in OSC to dispatch "now".
            if timeTag.isImmediate {
                _dispatch(message, timeTag: timeTag, remoteHost: remoteHost, remotePort: remotePort)
                return
            }
            
            // If Time Tag is <= now, dispatch immediately.
            // Otherwise, schedule message for future dispatch.
            guard timeTag.isFuture else {
                _dispatch(message, timeTag: timeTag, remoteHost: remoteHost, remotePort: remotePort)
                return
            }
            
            let secondsFromNow = timeTag.timeIntervalSinceNow()
            _dispatch(
                message,
                timeTag: timeTag,
                remoteHost: remoteHost,
                remotePort: remotePort,
                at: secondsFromNow
            )
        }
    }
    
    private func _dispatch(
        _ message: OSCMessage,
        timeTag: OSCTimeTag,
        remoteHost: String,
        remotePort: UInt16
    ) {
        queue.async {
            self.receiveHandler?(message, timeTag, remoteHost, remotePort)
        }
    }
    
    private func _dispatch(
        _ bundle: OSCBundle,
        remoteHost: String,
        remotePort: UInt16
    ) {
        queue.async {
            self.receiveBundleHandler?(bundle, remoteHost, remotePort)
        }
    }
    
    private func _dispatch(
        _ message: OSCMessage,
        timeTag: OSCTimeTag,
        remoteHost: String,
        remotePort: UInt16,
        at secondsFromNow: TimeInterval
    ) {
        // clamp lower bound to 0
        guard secondsFromNow > 0 else {
            // don't schedule, just dispatch it immediately
            _dispatch(message, timeTag: timeTag, remoteHost: remoteHost, remotePort: remotePort)
            return
        }
        
        let usec = Int(secondsFromNow * TimeInterval(USEC_PER_SEC))
        queue.asyncAfter(deadline: .now() + .microseconds(usec)) { [weak self] in
            self?.receiveHandler?(message, timeTag, remoteHost, remotePort)
        }
    }
}
