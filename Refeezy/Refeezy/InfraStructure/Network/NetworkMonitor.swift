//
//  NetworkMonitor.swift
//  ElmakGhanem
//
//  Created by Ahmed abuelregal on 02/12/2023.
//

import Foundation
import Network

enum ConnectionType {
    case wifi
    case cellular
    case ethernet
    case unKnown
}

class NetworkMonitor {
    
    static let shared = NetworkMonitor.init()
    private let globalQueue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    public private(set) var isConnected: Bool = false
    public private(set) var connectionType: ConnectionType?
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.start(queue: globalQueue)
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else {return}
            self.isConnected = path.status == .satisfied
            self.getConnectionType(path)
            NotificationCenter.default.post(name: .connectivityStatus, object: nil)
        }
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    
    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
        } else {
            connectionType = .unKnown
        }
    }
}

extension Notification.Name {
    static let connectivityStatus = Notification.Name(rawValue: "connectivityStatusChanged")
}
