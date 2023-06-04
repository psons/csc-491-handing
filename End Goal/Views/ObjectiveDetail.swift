//
//  ObjectiveDetail.swift
//  End Goal
//
//  Created by Paul Sons on 5/29/23.
//

import SwiftUI

struct ObjectiveDetail: View {
    var objective: Objective
    var body: some View {
        VStack{
            Grid(alignment: .leading) {
                GridRow {
                    Text("Planning for:")
                    Text(objective.name)
                }
                GridRow {
                    Text("Task Contribution size:")
                    Text("\(String(objective.maxTasks))")
                }
            }
            Spacer()
            NavigationStack { // Show nav
                List(objective.tasks) { task in
                    NavigationLink(destination: TaskDetail(task: task)) {
                        TaskRow(task: task)
                    }.padding(dataRowInsets).background()
                }.navigationTitle("Tasks...")
            }
            

        }
    }
}

struct TaskRow: View {
    var task: EGTask
    var body: some View {
        VStack {
            HStack {
                Image(task.status.rawValue).resizable()
                    .frame(width: 25, height: 25)
                Text(task.name).font(.headline).foregroundColor(itemTitleColor)
            }
            Text("\(task.detail)").font(.subheadline)
        }
    }
}



struct ObjectiveDetail_Previews: PreviewProvider {
    static var previews: some View {
        ObjectiveDetail(objective: Objective(name: "Preview Objective", maxTasks: 3))
    }
}
