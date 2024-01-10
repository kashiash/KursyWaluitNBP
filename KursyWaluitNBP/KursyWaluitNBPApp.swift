//
//  KursyWaluitNBPApp.swift
//  KursyWaluitNBP
//
//  Created by Jacek Kosinski U on 10/01/2024.
//

import SwiftUI
import SwiftData

@main
struct KursyWaluitNBPApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
