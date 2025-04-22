//
//  DocApp.swift
//  Doc
//
//  Created by Seja Muchhal on 21/04/25.
//

import SwiftUI

@main
struct DocApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
