//
//  SindDDiskStore.swift
//  End Goal
//
//  Created by Paul Sons on 6/2/23.
//

import Foundation

/**
 SingleDDiskStore Singleton Domain Disk Store
  - Static Shared instance  re implementation of DomainDiskStore
  - Solves problem where items added by shortcut did not show if the app is already running.
 
*/
@MainActor
class SingleDDiskStore: ObservableObject {
    static let shared = SingleDDiskStore()
    @Published var domain: EffortDomain
    private init(domain: EffortDomain) {
        self.domain = domain
    }
        
    init(name: String = "default") {
        self.domain = EffortDomain(name: name)
    }
    
    /**
     This should only be used for the special case of loading hard coded data to save to disk for testing.
     Otherwise, data should come from load()
     */
    func setDomain(domain: EffortDomain) {
        self.domain = domain
    }
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("domain.json")
    }
    
    func load() async throws {
        let task = Task<EffortDomain, Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return EffortDomain(name: "default")
            }
            let domain = try JSONDecoder().decode(EffortDomain.self, from: data)
            return domain
        }
        let domain = try await task.value
        self.domain = domain
    }
    
    func save(domain: EffortDomain) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(domain)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
}
