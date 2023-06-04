//
//  Goal.swift
//  EffortDomain
//
//  Created by Paul Sons on 3/11/23.
//

import Foundation

let defaultMaxObjectives = 3

/**
 The Goal class represents the top of the plannig hierarchy.  See Objective, (possible for future Subobjective) and Task,
 This class has 3 different ID fields and hopefully can be simplified at some point.
 */
class Goal: Codable, CustomStringConvertible, Identifiable, ObservableObject {
    static let defaultOslot = 0
    static let invalidOslot = -1
    let id = UUID()     // this ID is only used locally in the Swift UI
    var _id: String     // I think this ID will help with back end store and across clients.
    var name = ""
    @Published var maxObjectives: Int = 3
    var gid: String     // this ID will be used in a command line interface
    var objectives: [Objective] = []
    var description: String {
        let heading = "{Goal} |_id: \(_id)|name: \(name)|maxObjectives: \(maxObjectives)|gid: \(gid)|\n"
        var objectivesAsStr = ""
        for objective in objectives {
            objectivesAsStr += "\t\(objective)\n"
        }
        return heading + objectivesAsStr
    }

    private enum CodingKeys: String, CodingKey {
        case _id, name, maxObjectives, gid, objectives
    }

    // needed for encocable now that I Published an attribute
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decode(String.self, forKey: ._id)
        name = try values.decode(String.self, forKey: .name)
        maxObjectives = try values.decode(Int.self, forKey: .maxObjectives)
        gid = try values.decode(String.self, forKey: .gid )
        objectives = try values.decode([Objective].self, forKey: .objectives )
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_id, forKey: ._id)
        try container.encode(name, forKey: .name)
        try container.encode(maxObjectives, forKey: .maxObjectives)
        try container.encode(gid, forKey: .gid)
        try container.encode(objectives, forKey: .objectives)
      }
    

    
    /**
     Initializer for newly entered data or bare initialization.
        decoder doesn't use this.
     */
    init(name: String, maxObjectives: Int = defaultMaxObjectives, createDefaultObjective: Bool = false) {
        self.maxObjectives = maxObjectives
        self.name = name
        self._id = MongoObjectId.shared.generate()
        self.gid = self._id
        if createDefaultObjective {
            self.objectives.append(Objective(name: "default objective"))
        }
    }
    
    /**
     Note on Rust  eng CLI integration an Python tlog integration.
        - Standardize on the id creation as mongo IDs
        - when humans search by ID pattern match on a few characters, and handle thet possability of multiple matches
     */
//    func reGenerateIDs() {
//        self._id = MongoObjectId.shared.generate()
//        self.gid = MD5(string: self.name)
//    }
    
    func addObjective(objective: Objective) {
        self.objectives.append(objective)
    }

    /**
     Retuns the objective being removed, if the oSlot Index is valid in the objectives list.  ( Maybe the caller will undo, or put it in a different slot, or just tell the user.)
     Returns nil if the oSlot is out of range in the objectives list/
     todo: add some precaution agains index out of range.
     */
    func removeObjective(oSlot: Int) -> Objective? {
        if self.objectives.indices.contains(oSlot) {
            let objectiveAtOSlot = self.objectives[oSlot]
            self.objectives.remove(at: oSlot)
            return objectiveAtOSlot
        }
        return nil
    }
    
    func objectiveStrings() -> String {
        var sList = ""
        for objective in self.objectives {
            sList += "\t\t\(objective)\n"
        }
        return sList
    }
    
}

extension Goal {
    func getTaskCount() -> Int {
        var taskCount: Int = 0
        for objective in objectives {
            taskCount += objective.tasks.count
        }
        return taskCount
    }
}
