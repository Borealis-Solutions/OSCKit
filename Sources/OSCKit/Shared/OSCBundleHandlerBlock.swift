//
//  OSCBundleHandlerBlock.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2025 Daniel Murfin • Licensed under MIT License
//

import Foundation
import OSCKitCore

/// Received-bundle handler closure used by OSCKit socket classes.
public typealias OSCBundleHandlerBlock = @Sendable (
    _ message: OSCBundle,
    _ host: String,
    _ port: UInt16
) -> Void
