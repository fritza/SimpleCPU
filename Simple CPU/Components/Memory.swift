//
//  Memory.swift
//  Simple CPU
//
//  Created by Fritz Anderson on 2/17/19.
//  Copyright © 2019 Fritz Anderson. All rights reserved.
//

import Foundation

class Memory {
    enum Errors: Error {
        case alignment(UInt32)
        case access(UInt32)
    }

    let size: RegisterValue
    var data: Data

    func byte(at address: RegisterValue) throws -> RegisterValue {
        guard address < size else { throw Errors.access(address) }
        return RegisterValue(data[Int(address)])
    }

    func store(byte: RegisterValue, at address: RegisterValue) throws {
        guard address < size else { throw Errors.access(address) }
        data[Int(address)] = UInt8(byte)
    }

    

    init(size: RegisterValue) {
        self.size = size
        data = Data(repeating: 0, count: Int(size))
    }
}
