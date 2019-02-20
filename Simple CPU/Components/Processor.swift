//
//  Processor.swift
//  Simple CPU
//
//  Created by Fritz Anderson on 2/19/19.
//  Copyright © 2019 Fritz Anderson. All rights reserved.
//

import Foundation

struct StatusFlags: OptionSet {
    let rawValue: Int
    init(rawValue: Int) { self.rawValue = rawValue }
    static let clear = StatusFlags(rawValue: 0)
    static let zero = StatusFlags(rawValue: 1)
    static let carry = StatusFlags(rawValue: 2)
    static let overflow = StatusFlags(rawValue: 4)

}

// TODO: What's the best way to address, read, and set registers?
enum RegisterNames {
    case d0, d1, d2, d3, d4, d5, d6, d7
    case a0, a1, a2, a3, a4, a5, a6, a7
    case pc
}

class Processor {
    let memory: Memory
    let memoryCapacity: RegisterValue
    let dataRegisters: [DataRegister]
    let addressRegisters: [AddressRegister]
    var flags = StatusFlags.clear

    init(memory size: RegisterValue) {
        memoryCapacity = size
        memory = Memory(size: size)

        var addrs = [AddressRegister]()
        var datas = [DataRegister]()
        for n in 0...7 {
            addrs.append(AddressRegister(index: n))
            datas.append(DataRegister(index: n))
        }
        addressRegisters = addrs
        dataRegisters = datas
    }

    var d0: RegisterValue { return dataRegisters[0].value }
    var d1: RegisterValue { return dataRegisters[1].value }
    var d2: RegisterValue { return dataRegisters[2].value }
    var d3: RegisterValue { return dataRegisters[3].value }
    var d4: RegisterValue { return dataRegisters[4].value }
    var d5: RegisterValue { return dataRegisters[5].value }
    var d6: RegisterValue { return dataRegisters[6].value }
    var d7: RegisterValue { return dataRegisters[7].value }
}


