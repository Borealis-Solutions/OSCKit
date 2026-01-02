//
//  OSCUDPServer.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

@preconcurrency import CocoaAsyncSocket
import Foundation
import OSCKitCore

/// Receives OSC packets from the network on a specific UDP listen port.
///
/// A single global OSC server instance is often created once at app startup to receive OSC messages
/// on a specific local port. The default OSC port is 8000 but it may be set to any open port if
/// desired.
public final class OSCUDPServer {
    let udpSocket: GCDAsyncUdpSocket
    let udpDelegate = OSCUDPServerDelegate()
    let queue: DispatchQueue
    var receiveHandler: OSCHandlerBlock?
    var receiveBundleHandler: OSCBundleHandlerBlock?
    
    /// Bundle mode. Determines how OSC bundles are handled.
    public var bundleMode: OSCBundleMode {
        get { queue.sync { _bundleMode }}
        set { queue.sync { _bundleMode = newValue }}
    }
    internal var _bundleMode: OSCBundleMode
    
    /// UDP port used by the OSC server to listen for inbound OSC packets.
    /// This may only be set at the time of initialization.
    public var localPort: UInt16 {
        udpSocket.localPort()
    }
    private var _localPort: UInt16?
    
    /// Network interface to restrict connections to.
    public private(set) var interface: String?
    
    /// Enable local UDP port reuse by other processes.
    /// This property must be set prior to calling ``start()`` in order to take effect.
    ///
    /// By default, only one socket can be bound to a given IP address & port combination at a time. To enable
    /// multiple processes to simultaneously bind to the same address & port, you need to enable
    /// this functionality in the socket. All processes that wish to use the address & port
    /// simultaneously must all enable reuse port on the socket bound to that port.
    public var isPortReuseEnabled: Bool = false
    
    /// Returns a boolean indicating whether the OSC server has been started.
    public private(set) var isStarted: Bool = false
    
    /// Initialize an OSC server.
    /// 
    /// The default port for OSC communication is 8000 but may change depending on device/software
    /// manufacturer.
    /// 
    /// > Note:
    /// >
    /// > Ensure ``start()`` is called once after initialization in order to begin receiving messages.
    ///
    /// - Parameters:
    ///   - port: Local port to listen on for inbound OSC packets.
    ///     If `nil` or `0`, a random available port in the system will be chosen.
    ///   - interface: Optionally specify a network interface for which to constrain communication.
    ///   - isPortReuseEnabled: Enable local UDP port reuse by other processes.
    ///   - bundleMode: OSC Bundle mode. (Default is recommended.)
    ///   - queue: Optionally supply a custom dispatch queue for receiving OSC packets and dispatching the
    ///     handler callback closure. If `nil`, a dedicated internal background queue will be used.
    ///   - receiveHandler: Handler to call when OSC messages are received, or OSC bundles and
    ///     ``OSCBundleMode`` is set to `.unwrap`.
    ///   - receiveBundleHandler: Handler to call when OSC bundles are received and ``OSCBundleMode``
    ///     is set to `.forward`.
    public init(
        port: UInt16? = 8000,
        interface: String? = nil,
        isPortReuseEnabled: Bool = false,
        bundleMode: OSCBundleMode = .unwrap(timeTagMode: .ignore),
        queue: DispatchQueue? = nil,
        receiveHandler: OSCHandlerBlock? = nil,
        receiveBundleHandler: OSCBundleHandlerBlock? = nil
    ) {
        _localPort = (port == nil || port == 0) ? nil : port
        self.interface = interface
        self.isPortReuseEnabled = isPortReuseEnabled
        self._bundleMode = bundleMode
        let queue = queue ?? DispatchQueue(label: "com.orchetect.OSCKit.OSCUDPServer.queue")
        self.queue = queue
        self.receiveHandler = receiveHandler
        self.receiveBundleHandler = receiveBundleHandler
        
        udpSocket = GCDAsyncUdpSocket(delegate: udpDelegate, delegateQueue: queue, socketQueue: nil)
        udpDelegate.oscServer = self
    }
}

extension OSCUDPServer: @unchecked Sendable { }

// MARK: - Lifecycle

extension OSCUDPServer {
    /// Bind the local UDP port and begin listening for OSC packets.
    public func start() throws {
        guard !isStarted else { return }
        
        stop()
        
        try udpSocket.enableReusePort(isPortReuseEnabled)
        try udpSocket.bind(
            toPort: _localPort ?? 0, // 0 causes system to assign random open port
            interface: interface
        )
        try udpSocket.beginReceiving()
        
        isStarted = true
    }
    
    /// Stops listening for data and closes the OSC server port.
    public func stop() {
        udpSocket.close()
        
        isStarted = false
    }
}

// MARK: - Communication

extension OSCUDPServer: _OSCHandlerProtocol {
    // provides implementation for dispatching incoming OSC data
}

// MARK: - Properties

extension OSCUDPServer {
    /// Set the receive handler closure.
    /// This closure will be called when OSC messages are received, or when
    /// OSC bundles are received if ``OSCBundleMode`` is set to `.unwrap`.
    public func setReceiveHandler(
        _ handler: OSCHandlerBlock?
    ) {
        queue.async {
            self.receiveHandler = handler
        }
    }
    
    /// Set the receive handler closure.
    /// This closure will be called when OSC bundles are received if
    /// ``OSCBundleMode`` is to set `.forward`.
    public func setReceiveBundleHandler(
        _ handler: OSCBundleHandlerBlock?
    ) {
        queue.async {
            self.receiveBundleHandler = handler
        }
    }
}

#endif
