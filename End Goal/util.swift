//
//  util.swift
//  End Goal
//
//  Created by Paul Sons on 6/2/23.
//

import Foundation
import CryptoKit

/**
 Source: https://stackoverflow.com/questions/32163848
 */
func MD5(string: String) -> String {
    let digest = Insecure.MD5.hash(data: Data(string.utf8))

    return digest.map {
        String(format: "%02hhx", $0)
    }.joined()
}

func currentTimeStamp() -> String {
    let date = Date()
    return date.formatted()
}

/*
 MongoDB like object ID per:
 https://www.mongodb.com/docs/manual/reference/bson-types/#std-label-objectid
 - which says it can be almost any type.
 https://stackoverflow.com/questions/36508470/
 To use: ObjectId.shared.generate()
 */
class MongoObjectId {
    private init() {}
    static let shared = MongoObjectId()

    private var counter = Int.random(in: 0...0xffffff)

    private func incrementCounter() {
        if (counter >= 0xffffff) {
            counter = 0
        } else {
            counter += 1
        }
    }

    /**
     Generate a Mongo DB Object ID,
     https://stackoverflow.com/questions/36508470/
     */
    func generate() -> String {
        let time = ~(~Int(NSDate().timeIntervalSince1970))
        let random = Int.random(in: 0...0xffffffffff)
        let i = counter
        incrementCounter()

        var byteArray = Array<UInt8>.init(repeating: 0, count: 12)

        byteArray[0] = UInt8((time >> 24) & 0xff)
        byteArray[1] = UInt8((time >> 16) & 0xff)
        byteArray[2] = UInt8((time >> 8) & 0xff)
        byteArray[3] = UInt8(time & 0xff)
        byteArray[4] = UInt8((random >> 32) & 0xff)
        byteArray[5] = UInt8((random >> 24) & 0xff)
        byteArray[6] = UInt8((random >> 16) & 0xff)
        byteArray[7] = UInt8((random >> 8) & 0xff)
        byteArray[8] = UInt8(random & 0xff)
        byteArray[9] = UInt8((i >> 16) & 0xff)
        byteArray[10] = UInt8((i >> 8) & 0xff)
        byteArray[11] = UInt8(i & 0xff)

        let id = byteArray
                     .map({ String($0, radix: 16, uppercase: false)
                     .padding(toLength: 2, withPad: "0", startingAt: 0) })
                     .joined()

        return id
    }
}


