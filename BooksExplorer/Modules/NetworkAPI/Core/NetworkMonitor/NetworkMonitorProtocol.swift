//
//  NetworkMonitorProtocol.swift
 

import Foundation 

/// A protocol for monitoring network status.
///
/// `NetworkMonitorProtocol` provides the interface for starting and stopping network monitoring.
/// Conforming types should implement methods to start and stop network status updates.
internal protocol NetworkMonitorProtocol {
    /// Starts monitoring the network status.
    ///
    /// This method begins monitoring the network status and provides updates about connectivity changes.
    mutating func startMonitoring()

    /// Stops monitoring the network status.
    ///
    /// This method stops the network status monitoring and halts further updates.
    mutating func stopMonitoring()
}

