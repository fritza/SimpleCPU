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
}


