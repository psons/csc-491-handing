//
//  AppIntents.swift
//  End Goal
//
//  Created by Paul Sons on 5/25/23.
//

import Foundation
import AppIntents

struct StartEndGoalIntent: AppIntent {
    static var title: LocalizedStringResource = "Start End Goal"
    static var description = IntentDescription("Launches the End Goal App.")
    static var openAppWhenRun = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        print("StartEndGoalIntent.perform()")
        //        let tbc = getTBRootController()
        //        tbc.selectedIndex = 1
        return .result()  //.finished
    }
}

struct QuickGoalAdd: AppIntent {
    static var title: LocalizedStringResource = "Quick Add Goal"
    static var description = IntentDescription("Adds a Goal by name")
//    static var openAppWhenRun = false  // <---- Won't launch app, or load ViewControllers.
    static var openAppWhenRun = true  // launch app

    @Parameter(title: "Name of the Goal")
    var name: String    // not non-optional will have Siri assure that it is provided.

    // possibly need to be "MainActor" because update publishes and a running UI
    // recieves the notification.
    @MainActor
    static var parameterSummary: some ParameterSummary {
        Summary("Create a goal named \(\.$name) ")
    }
    
    
    func perform() async throws -> some IntentResult {
        print("QuickGoalAdd.perform() Goal.name: \(name)")
        
        try! await SingleDDiskStore.shared.load()  // how bad is it to use try ! here?
        let _goalPosition = await SingleDDiskStore.shared.domain.addGoal(goal: Goal(name: name))
        try await SingleDDiskStore.shared.save(domain: SingleDDiskStore.shared.domain)
        return .result()  //.finished
    }
}



// builds Intents into a shortcuts.
struct TaskBlotterShortcuts: AppShortcutsProvider {
    // phrases .applicationName or Siri roams out to an internet search.
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: StartEndGoalIntent(), phrases: [
                "Start \(.applicationName)",
                "Launch \(.applicationName)",
                "Launch My Goal App \(.applicationName)"])

        AppShortcut(
            intent: QuickGoalAdd(), phrases: [
                "Quick \(.applicationName)",
                "Add Quick Goal in \(.applicationName)",
                "Quickly add a goal in \(.applicationName)",
                "Quickly add a new \(.applicationName)",
                "Quickly add a new goal in \(.applicationName)",
                "Quickly Create an \(.applicationName)",
                "Quickly Create a Goal in \(.applicationName)",
                "Add a Goal in \(.applicationName)",
                "Add a new goal in \(.applicationName)",
            ])
    }
}
