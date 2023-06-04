//
//  GoalDetail.swift
//  End Goal
//
//  Created by Paul Sons on 5/28/23.
//

import SwiftUI

struct GoalDetail: View {
    var goal: Goal
    var body: some View {

        VStack{
            Grid(alignment: .leading) {
                GridRow {
                    Text("Planning for:")
                    Text(goal.name)
                }
                GridRow {
                    Text("Objective Contribution size:")
                    Text("\(String(goal.maxObjectives))")
                }
            }
            Spacer()
            NavigationStack { // Show nav
                List(goal.objectives) { objective in
                    NavigationLink(destination: ObjectiveDetail(objective: objective)) {
                        ObjectiveRow(objective: objective)
                    }.padding(dataRowInsets).background()
                }.navigationTitle("Objectives...")
            }
        }
    }
}


struct ObjectiveRow: View {
    var objective: Objective
    var body: some View {
        HStack {Image(systemName: "scope")
            Text(objective.name).font(.headline).foregroundColor(itemTitleColor)
            Spacer()
            VStack {
                Text("\(objective.maxTasks) max contribution").font(.subheadline)
                Text("\(objective.tasks.count) tasks").font(.subheadline)
            }
        }
    }
}

struct GoalDetail_Previews: PreviewProvider {
    static var previews: some View {
        GoalDetail(goal: Goal(name: "Preview Goal", maxObjectives: defaultMaxObjectives, createDefaultObjective: true))
    }
}
