//
//  NewGoalSheet.swift
//  End Goal
//
//  Created by Paul Sons on 5/30/23.
//

import SwiftUI

struct NewGoalSheet: View {
    @State private var newGoal = Goal(name: "")
    @ObservedObject var domain: EffortDomain
    @Binding var isPresentingNewGoalView: Bool
    var saveAction: ()->Void
    
    
    var body: some View {
        NavigationStack {
            DetailGoalEditView(goal: newGoal)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Dismiss") {
                            isPresentingNewGoalView = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            print("newGoal: \(newGoal)")
                            _ = domain.addGoal(goal: newGoal)
                            isPresentingNewGoalView = false
                            saveAction() // calling the closure passed all the way from App Level
                        }
                    }
                }
//                .onChange(of: goal.maxObjectives) {
//                    print("self.goal.maxObjectives: \(self.goal.maxObjectives)")
//                }

        }
    }
}

//struct NewGoalSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        NewGoalSheet()
//    }
//}
