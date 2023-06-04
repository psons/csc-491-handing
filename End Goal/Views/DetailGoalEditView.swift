//
//  DetailGoalEditView.swift
//  End Goal
//
//  Created by Paul Sons on 5/30/23.
//

import SwiftUI

struct DetailGoalEditView: View {
    @ObservedObject var goal: Goal
    @State private var maxObjectiveStepVal = 3
    var body: some View {
        Form {
            Section(header: Text("New Goal Information")) {
                VStack {
                    TextField("Title", text: $goal.name)
                    Stepper(value: $goal.maxObjectives, in: 1...20 ) {
//                    Stepper(value: $maxObjectiveStepVal, in: 1...20 ) {
                        Text("Max Objectives: \(self.goal.maxObjectives)")
//                        Text("Max Objectives: \(maxObjectiveStepVal)")
                    }
                }
            }
        }
    }
}

struct DetailGoalEditView_Previews: PreviewProvider {
    static var previews: some View {
        DetailGoalEditView(goal: testEffortDomain.goals[0])
    }
}
