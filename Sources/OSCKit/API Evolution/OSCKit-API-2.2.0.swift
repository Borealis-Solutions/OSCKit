//
//  OSCKit-API-2.2.0.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2025 Daniel Murfin • Licensed under MIT License
//

#if !os(watchOS)

import Foundation

extension OSCUDPServer {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(port:interface:bundleMode:queue:receiveHandler:)", message: "Use bundleMode parameter instead. Convert .osc1_0 to .unwrap(timeTagMode: .osc1_0) and .ignore to .unwrap(timeTagMode: .ignore)")
    @_disfavoredOverload
    public convenience init(
        port: UInt16? = 8000,
        interface: String? = nil,
        timeTagMode: OSCTimeTagMode = .ignore,
        queue: DispatchQueue? = nil,
        receiveHandler: OSCHandlerBlock? = nil
    ) {
        let bundleMode: OSCBundleMode = .unwrap(timeTagMode: timeTagMode)
        self.init(
            port: port,
            interface: interface,
            bundleMode: bundleMode,
            queue: queue,
            receiveHandler: receiveHandler
        )
    }
    
    @_documentation(visibility: internal)
    @available(*, deprecated, message: "Use bundleMode parameter instead which supports forwarding or unwrapping of OSCBundles. For previous behavior, convert .osc1_0 to .unwrap(timeTagMode: .osc1_0) and .ignore to .unwrap(timeTagMode: .ignore)")
    public var timeTagMode: OSCTimeTagMode {
        get {
            switch bundleMode {
            case .forward: .ignore
            case .unwrap(let timeTagMode): timeTagMode
            }
        }
        set {
            bundleMode = .unwrap(timeTagMode: newValue)
        }
    }
}

extension OSCUDPSocket {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(localPort:remoteHost:remotePort:interface:bundleMode:isIPv4BroadcastEnabled:queue:receiveHandler:)", message: "Use bundleMode parameter instead. Convert .osc1_0 to .unwrap(timeTagMode: .osc1_0) and .ignore to .unwrap(timeTagMode: .ignore)")
    @_disfavoredOverload
    public convenience init(
        localPort: UInt16? = nil,
        remoteHost: String? = nil,
        remotePort: UInt16? = nil,
        interface: String? = nil,
        timeTagMode: OSCTimeTagMode = .ignore,
        isIPv4BroadcastEnabled: Bool = false,
        queue: DispatchQueue? = nil,
        receiveHandler: OSCHandlerBlock? = nil
    ) {
        let bundleMode: OSCBundleMode = .unwrap(timeTagMode: timeTagMode)
        self.init(
            localPort: localPort,
            remoteHost: remoteHost,
            remotePort: remotePort,
            interface: interface,
            bundleMode: bundleMode,
            isIPv4BroadcastEnabled: isIPv4BroadcastEnabled,
            queue: queue,
            receiveHandler: receiveHandler
        )
    }
    
    @_documentation(visibility: internal)
    @available(*, deprecated, message: "Use bundleMode parameter instead which supports forwarding or unwrapping of OSCBundles. For previous behavior, convert .osc1_0 to .unwrap(timeTagMode: .osc1_0) and .ignore to .unwrap(timeTagMode: .ignore)")
    public var timeTagMode: OSCTimeTagMode {
        get {
            switch bundleMode {
            case .forward: .ignore
            case .unwrap(let timeTagMode): timeTagMode
            }
        }
        set {
            bundleMode = .unwrap(timeTagMode: newValue)
        }
    }
}

extension OSCTCPServer {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(port:interface:bundleMode:framingMode:queue:receiveHandler:)", message: "Use bundleMode parameter instead. Convert .osc1_0 to .unwrap(timeTagMode: .osc1_0) and .ignore to .unwrap(timeTagMode: .ignore)")
    @_disfavoredOverload
    public convenience init(
        port: UInt16?,
        interface: String? = nil,
        timeTagMode: OSCTimeTagMode = .ignore,
        framingMode: OSCTCPFramingMode = .osc1_1,
        queue: DispatchQueue? = nil,
        receiveHandler: OSCHandlerBlock? = nil
    ) {
        let bundleMode: OSCBundleMode = .unwrap(timeTagMode: timeTagMode)
        self.init(
            port: port,
            interface: interface,
            bundleMode: bundleMode,
            framingMode: framingMode,
            queue: queue,
            receiveHandler: receiveHandler
        )
    }
    
    @_documentation(visibility: internal)
    @available(*, deprecated, message: "Use bundleMode parameter instead which supports forwarding or unwrapping of OSCBundles. For previous behavior, convert .osc1_0 to .unwrap(timeTagMode: .osc1_0) and .ignore to .unwrap(timeTagMode: .ignore)")
    public var timeTagMode: OSCTimeTagMode {
        get {
            switch bundleMode {
            case .forward: .ignore
            case .unwrap(let timeTagMode): timeTagMode
            }
        }
        set {
            bundleMode = .unwrap(timeTagMode: newValue)
        }
    }
}

extension OSCTCPClient {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(remoteHost:remotePort:interface:bundleMode:framingMode:queue:receiveHandler:)", message: "Use bundleMode parameter instead. Convert .osc1_0 to .unwrap(timeTagMode: .osc1_0) and .ignore to .unwrap(timeTagMode: .ignore)")
    @_disfavoredOverload
    public convenience init(
        remoteHost: String,
        remotePort: UInt16,
        interface: String? = nil,
        timeTagMode: OSCTimeTagMode = .ignore,
        framingMode: OSCTCPFramingMode = .osc1_1,
        queue: DispatchQueue? = nil,
        receiveHandler: OSCHandlerBlock? = nil
    ) {
        let bundleMode: OSCBundleMode = .unwrap(timeTagMode: timeTagMode)
        self.init(
            remoteHost: remoteHost,
            remotePort: remotePort,
            interface: interface,
            bundleMode: bundleMode,
            framingMode: framingMode,
            queue: queue,
            receiveHandler: receiveHandler
        )
    }
    
    @_documentation(visibility: internal)
    @available(*, deprecated, message: "Use bundleMode parameter instead which supports forwarding or unwrapping of OSCBundles. For previous behavior, convert .osc1_0 to .unwrap(timeTagMode: .osc1_0) and .ignore to .unwrap(timeTagMode: .ignore)")
    public var timeTagMode: OSCTimeTagMode {
        get {
            switch bundleMode {
            case .forward: .ignore
            case .unwrap(let timeTagMode): timeTagMode
            }
        }
        set {
            bundleMode = .unwrap(timeTagMode: newValue)
        }
    }
}

#endif
