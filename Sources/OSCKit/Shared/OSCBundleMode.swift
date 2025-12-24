//
//  OSCBundleMode.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2025 Daniel Murfin • Licensed under MIT License
//

import Foundation

/// Specifies an OSC server's bundle handling behavior.
///
/// This dictates whether received OSC bundles are forwarded to the handler as-is, or unwrapped
/// and their contained messages dispatched individually.
///
/// See ``OSCBundle`` for details on bundle contents.
public enum OSCBundleMode {
    /// Forward received OSC bundles to the handler without unwrapping.
    /// The handler will receive the complete bundle structure including time tag and nested bundles.
    /// This mode is useful when bundle processing needs to be handled externally or when preserving
    /// the bundle structure is important.
    ///
    /// When this mode is active, any time tag scheduling behavior is bypassed since bundles are not
    /// being unwrapped internally.
    case forward
    
    /// Unwrap received OSC bundles and dispatch their contained messages individually.
    /// The associated ``OSCTimeTagMode`` value determines whether time tags are honored for
    /// scheduling or ignored.
    ///
    /// See ``OSCTimeTagMode`` for details on time tag handling behavior.
    case unwrap(timeTagMode: OSCTimeTagMode)
}

extension OSCBundleMode: Equatable { }

extension OSCBundleMode: Hashable { }

extension OSCBundleMode: Sendable { }
