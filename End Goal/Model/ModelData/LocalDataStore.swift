//
//  LocalDataStore.swift
//  End Goal
//
//  Created by Paul Sons on 6/3/23.
//

import Foundation

/**
 LocalDataStore Singleton Store
  - Static Shared instance
  - Solves problem where shortcut changes would not show in already running app.
 
*/
@MainActor
class LocalDataStore: ObservableObject {
    static let shared = LocalDataStore()
    @Published var localData = LocalData()
    
    private init() {}
    
    /**
     This should only be used for the special case of loading hard coded data to save to disk for testing.
     Otherwise, data should come from load()
     */
    func setLocalData(localData: LocalData) {
        self.localData = localData
    }
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("local_data.json")
    }
    
    func load() async throws {
        let task = Task<LocalData, Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return LocalData()
            }
            let localD = try JSONDecoder().decode(LocalData.self, from: data)
            return localD
        }
        let loadedData = try await task.value
        self.localData = loadedData
    }
    
    func save(localData: LocalData) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(localData)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
}
