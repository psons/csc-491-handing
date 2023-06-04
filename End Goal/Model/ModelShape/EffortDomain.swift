//
//  EffortDomain.swift
//  EffortDomain
//
//  Created by Paul Sons on 3/11/23.
//

import Foundation

/**
 ## Overview
 An effort domain refers to the context that a person will use to prioritize time and efort use,
 plus the goals within that context. A persons goals and priorities, for example are different during work hours than they are outside of work.
 
 Callers will provide an index of a goal in the EffortDomain to insert new objective, but if that index is not valid, the insert will happen
 at a different (default) location.
 
 Likewise, Callers will provide indecies of a Goal and an Objective to add a Task, but if those indecies are not valid,
 the insert will happen at a different (default) location.
 
 */
class EffortDomain: Codable, CustomStringConvertible, ObservableObject {
    // Resource on mixing Codable and ObservableObject:
    //  https://swiftui.diegolavalle.com/posts/codable-observable/
    static let defaultGSlot = 0
    @Published var name: String = ""
    @Published var todoMaxTasks = defaultMaxTasks
    @Published var timeStamp = "UNUNITIALIZED"
    @Published var goals: [Goal] = []
    var description: String {
        let heading = "{EffortDomain} |name:\(name)|todoMaxTasks: \(todoMaxTasks)|goals.count: \(goals.count)\n"
        var goalsAsStr = ""
        for goal in goals {
            goalsAsStr += "\t\(goal)\n"
        }
        return heading + goalsAsStr
    }

    private enum CodingKeys: String, CodingKey {
        case name, todoMaxTasks, goals
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        todoMaxTasks = try values.decode(Int.self, forKey: .todoMaxTasks )
        goals = try values.decode([Goal].self, forKey: .goals )
    }

    init(name: String, todoMaxTasks: Int = defaultMaxTasks) {
        self.goals.append(Goal(name: "default goal", createDefaultObjective: true))
        self.name = name
        self.todoMaxTasks = todoMaxTasks
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(todoMaxTasks, forKey: .todoMaxTasks)
        try container.encode(goals, forKey: .goals)
      }
    
    func addGoal(goal: Goal) -> Int {
        self.goals.append(goal)
        return self.goals.count - 1  // gSlot of the goal we just added
    }
    

    func isValidGslot(gSlot: Int) -> Bool {
        return self.goals.indices.contains(gSlot)
    }
    
    /**
    Returns the user provided goal slot, suitable for adding objectives if it is a valid goal index.
    If it is not a valid goal index, the default goal slot is returned.
     */
    func validGSlot(gSlot: Int) -> Int {
        if isValidGslot(gSlot: gSlot){
            return gSlot
        } else {
            return EffortDomain.defaultGSlot  // was no good.  forced to default
        }
    }

    /**
     Add objective at the specfied Goal Slot or a default
     */
    func addObjective(objective: Objective, gSlot: Int) -> SlotState {
        let gSl = validGSlot(gSlot: gSlot)
        self.goals[gSl].objectives.append(objective)
        let slotState = SlotState.factory(gSl, self.goals[gSl].objectives.count - 1)
        return slotState
    }

    func isValidOslot(givenGslot: Int, oSlot: Int) -> Bool {
        if isValidGslot(gSlot: givenGslot) {
            return self.goals[givenGslot].objectives.indices.contains(oSlot)
        } else {
            return false
        }
    }

    /**
    Returns the user provided go slot, suitable for adding tasks if it is the g ad o indecies are valid.
    If the g an o index is not valid, the default goal slot, objective slot  is returned.
     */
    func validGOSlot(givenGslot: Int, oSlot: Int) -> SlotState {
        let newSlotState = SlotState()
        newSlotState.gSlot = givenGslot
        newSlotState.oSlot = oSlot

        if isValidOslot(givenGslot: givenGslot, oSlot: oSlot){
            return newSlotState
        } else {
            newSlotState.gSlot = EffortDomain.defaultGSlot
            newSlotState.oSlot = Goal.defaultOslot
            return   newSlotState // was no good.  forced to default
        }
        
    }

    
    /** This should be more sophisticated when  the domain store is somthing that can mutate while the user is working with objectives.
     The task could be added in a default place if the objective becomes unavailable*/
    func addTask(task: EGTask, gSlot: Int, oSlot: Int) -> SlotState {
        let slotState = validGOSlot(givenGslot: gSlot, oSlot: oSlot)
        self.goals[slotState.gSlot].objectives[slotState.oSlot].tasks.append(task)
        return slotState
    }
    
    /**
     Retuns the Goal being removed, if the gSlot Index is valid in the goals list.  ( Maybe the caller will undo, or put it in a different slot, or just tell the user.)
     Returns nil if the gSlot is out of range in the goals list.
     */
    func removeGoal(gSlot: Int) -> Goal? {
        if self.goals.indices.contains(gSlot) {
            let goalAtOSlot = self.goals[gSlot]
            self.goals.remove(at: gSlot)
            return goalAtOSlot
        }
        return nil
    }
    
    func requestNewValidGOState(desiredState: SlotState, previousSlotState: SlotState) -> SlotState {
        let resultingSlotState = SlotState()
        if !isValidGslot(gSlot: desiredState.oSlot) {
            /** Requested goal is not valid so return defaults*/
            return resultingSlotState
        } else {
            resultingSlotState.gSlot = desiredState.gSlot
            resultingSlotState.oSlot = requestValidOslot(
                goal: self.goals[resultingSlotState.gSlot],
                desiredOslot: previousSlotState.oSlot)
            return resultingSlotState
        }
    }
    
    /**
     logic requires knowledge of prior slotState and the state of goals in the AppDomain
     Return a SlotState that has a valid goal, as requested if possible, and also if possible  a valid objective
     Try to preserve existing oSlot if goal is not changing.
     */
    func requestNewCurrentGState(desiredGSlot: Int, previousSlotState: SlotState) -> SlotState {
        let resultingSlotState = SlotState()
        if desiredGSlot == previousSlotState.gSlot {
            if isValidGslot(gSlot: desiredGSlot){
                /** Valid gSlot. can try to preserve previous oSlot*/
                resultingSlotState.gSlot = desiredGSlot
                resultingSlotState.oSlot = requestValidOslot(
                    goal: self.goals[resultingSlotState.gSlot],
                    desiredOslot: previousSlotState.oSlot)
                return resultingSlotState
            } else {
                /** Requested goal is not valid so return defaults*/
                return resultingSlotState
            }
        } else {
            if isValidGslot(gSlot: desiredGSlot) {   // would be sightly simpler if this were the outer test
                /** Valid gSlot. No previous*/
                resultingSlotState.gSlot = desiredGSlot
                resultingSlotState.oSlot = requestValidOslot(
                    goal: self.goals[resultingSlotState.gSlot],
                    desiredOslot: Goal.defaultOslot)
                return resultingSlotState
            } else {
                /** Requested goal is not valid so return defaults*/
                return resultingSlotState
            }
        }
    }

    /**
     Returns desiredOslot if it is valid.
     Returns Goal.defaultOslot if that is valid.
     Returns Goal.invalidOslot if there is no valid oSlot in goal.   Caller must create an objective in the Goal
     */
    func requestValidOslot(goal: Goal, desiredOslot: Int) -> Int {
        if goal.objectives.indices.contains(desiredOslot){
            return desiredOslot
        } else {
            if goal.objectives.indices.contains(Goal.defaultOslot) {
                return Goal.defaultOslot
            } else {
                return Goal.invalidOslot
            }
        }
    }
    
}


