//
//  LocalData.swift
//  End Goal
//
//  Created by Paul Sons on 6/3/23.
//

import Foundation

/**
 LocalData is settings stored beyween runs locally on the phone.
 Inlcuses infor about what data was on screen, and user preferences.
 Some of thios may need to move to a settings stores at some point.
 */

class LocalData: Codable, CustomStringConvertible, ObservableObject {
    @Published var useCloud = false
    var slotState = SlotState()
    
    private enum CodingKeys: String, CodingKey {
        case useCloud, slotState
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        useCloud = try values.decode(Bool.self, forKey: .useCloud)
        slotState = try values.decode(SlotState.self, forKey: .slotState )
        }

    init() {}
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(useCloud, forKey: .useCloud)
        try container.encode(slotState, forKey: .slotState)
      }

    var description: String {
        let heading = "{LocalData} |useCloud:\(useCloud)|slotState: \(slotState)\n"
        return heading
    }
}
