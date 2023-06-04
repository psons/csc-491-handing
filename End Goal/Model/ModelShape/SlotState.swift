//
//  AppState.swift
//  EffortDomain
//
//  Created by Paul Sons on 3/11/23.
//

import Foundation
/**
 ## Overview
 A class to report where an Objective or Task has been inserted an EffortDomain.
 Insertions will usually specify a location, but dince the EffortDomain can be mutated outside of the curent app,
 the EffortDomain will adapt on the fly and report where the insert actually happened with an AppState.
 The app can then allow the user to navigate to that location in the user interface.
 (The curent user may be trying to insert tasks into an objective that some other user has deleted.)
 
 See EffortDomain documentation regarding how a place to insert Objectives and Tasks if the intended
 parent objects do not exist.
 */

class SlotState: Codable, CustomStringConvertible {
    var gSlot = EffortDomain.defaultGSlot  /// index of an goal that will be used if none provided when creatig an Objective
    var oSlot = Goal.defaultOslot  /// index of Objective that will be used if none provided when creatig a task.
    //var currentTslot = 0
    var description: String {
        return "SlotState[G,O] [\(gSlot),\(oSlot)]"
    }
    
    // avoding supporting more init constructors, but want a 2 Int way to init
    static func factory(_ gs: Int, _ os: Int) -> SlotState {
        let newSlotState = SlotState()
        newSlotState.gSlot = gs
        newSlotState.oSlot = os
        return newSlotState
    }
    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.gSlot = try container.decode(Int.self, forKey: .gSlot)
//        self.oSlot = try container.decode(Int.self, forKey: .oSlot)
//    }
    
//    init(gSlot: Int, oSlot: Int) {
//        self.gSlot = gSlot
//        self.oSlot = oSlot
//    }
    
}
