//
//  NetworkMonitor.swift
//  Doc
//
//  Created by Seja Muchhal on 22/04/25.
//


import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    public private(set) var isConnected: Bool = false

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            if self?.isConnected == true {
                let documentUpdate = DocumentUpdate()
                documentUpdate.updatePendingData()
            }
        }
        monitor.start(queue: DispatchQueue.main)
    }

    deinit {
        monitor.cancel()
    }
}
