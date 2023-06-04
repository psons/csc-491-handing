//
//  DomainTab.swift
//  End Goal
//
//  Created by Paul Sons on 5/17/23.
//

import SwiftUI

let itemTitleColor: Color = /*@START_MENU_TOKEN@*/Color(hue: 0.697, saturation: 0.97, brightness: 0.987)/*@END_MENU_TOKEN@*/
let dataRowInsets = EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)

struct DomainTab: View {
    @ObservedObject var domain: EffortDomain
    @State var stepperMax = 6
    @State private var isPresentingNewGoalView = false
    var saveAction: ()->Void
    
    init(domain: EffortDomain, saveAction: @escaping ()->Void) {
        self.domain = domain
        self.saveAction = saveAction
    }
    
    var body: some View {
        VStack {

//            Spacer()
//            NavigationView { // Show nav
//            https://developer.apple.com/documentation/swiftui/migrating-to-new-navigation-types
            NavigationStack { // Show nav
                
                VStack(alignment: .leading) {


                    List(domain.goals) { goal in
                        NavigationLink(destination: GoalDetail(goal: goal)) {
//                            let _ = print("List individual Goal \(domain)")
                            GoalRow(goal: goal)
                        }.padding(dataRowInsets).background()
                    }//.navigationTitle("Goals...")
                }
                .navigationTitle("Goals")
                .toolbar {
                    Button(action: {
                        isPresentingNewGoalView = true
                    }) {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("New Goal")
                }.toolbar(.visible, for: .navigationBar)
            }
            .sheet(isPresented: $isPresentingNewGoalView) {
                NewGoalSheet(domain: domain, isPresentingNewGoalView: $isPresentingNewGoalView, saveAction: saveAction )
            }

            //            .toolbarTitleMenu {
//                Text("This is the toolbar title menu")
//            }
        }
    }
}

struct GoalRow: View {
    var goal: Goal
    var body: some View {
        HStack {Image(systemName: "scope")
            Text(goal.name).font(.headline).foregroundColor(itemTitleColor)
            Spacer()
            VStack {
                Text("\(goal.maxObjectives) max contribution").font(.subheadline)
                Text("\(goal.objectives.count) objectives").font(.subheadline)
                Text("\(goal.getTaskCount()) total tasks").font(.subheadline)
            }
        }
    }
}


let previewEffort: EffortDomain = EffortDomain(name: "Work Time Domain")

struct DomainTab_Previews: PreviewProvider {
    static var previews: some View {
        DomainTab(domain: previewEffort, saveAction: {})
    }
}
