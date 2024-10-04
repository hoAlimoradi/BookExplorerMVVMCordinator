//
//  NetworkMonitor.swift
 
import Foundation
import Network

/// A singleton class for monitoring network connectivity.
///
/// `NetworkMonitor` uses `NWPathMonitor` to track network status and provides information about the current network state.
/// It logs the network status and whether the connection is over a cellular network.
internal final class NetworkMonitor: NetworkMonitorProtocol {
    
    private enum Constants {
        static var networkMonitorQueue = DispatchQueue(label: "NetworkMonitor")
    }
    /// The shared instance of the `NetworkMonitor` class.
    static let shared = NetworkMonitor()

    /// The `NWPathMonitor` instance used to monitor network changes.
    let monitor = NWPathMonitor()
    
    /// The current network status.
    private var status: NWPath.Status = .requiresConnection
    
    /// A Boolean value indicating whether the network is reachable.
    var isReachable: Bool { status == .satisfied }
    
    /// A Boolean value indicating whether the network connection is via cellular.
    var isReachableOnCellular: Bool = true

    /// Starts monitoring the network status.
    ///
    /// This method sets up a handler to monitor network changes and logs the network status.
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive
            
            if path.status == .satisfied {
                LoggingAPI.shared.log(" 💻 We're connected ", level: .info)
            } else {
                LoggingAPI.shared.log(" 🚧 No connection", level: .warning)
            }
            LoggingAPI.shared.log(" 📣 path.isExpensive \(path.isExpensive) ", level: .info)
        }
        monitor.start(queue: Constants.networkMonitorQueue)
    }

    /// Stops monitoring the network status.
    ///
    /// This method cancels the monitoring of network status changes.
    func stopMonitoring() {
        monitor.cancel()
    }
}
