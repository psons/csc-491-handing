//
//  TaskDetail.swift
//  End Goal
//
//  Created by Paul Sons on 5/29/23.
//

import SwiftUI

struct TaskDetail: View {
    var task: EGTask
    var body: some View {
        VStack{
            HStack {
                Image(task.status.rawValue).resizable()
                    .frame(width: 50, height: 50)
                Text(task.name).font(.largeTitle).foregroundColor(itemTitleColor)

            }
            Text(task.detail).font(.title2)
            Spacer()

        }

    }
}

struct TaskDetail_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetail(task: EGTask(name: "Preview Task", detail: "Task Detail can be long compared  to just the name of the task."))
    }
}
