//
//  Register.swift
//  Simple CPU
//
//  Created by Fritz Anderson on 2/17/19.
//  Copyright © 2019 Fritz Anderson. All rights reserved.
//

import Foundation


class Register {
    static let hexFormatter: NumberFormatter = {
        let retval = NumberFormatter()
        retval.formatWidth = 8

        return retval
    }()

    class var namePrefix: String {return "⚠️"}

    var value: RegisterValue
    let index: Int

    // TODO: Should throw
    func setValueFrom(string: String) {
        value = HexFlag.parse(string) ?? 0
    }

    var nameString: String {
        return "\(type(of: self).namePrefix)\(index)"
    }

    var valueString: String {
        return value.hexString(flagged: .hash)
    }

    var displayString: String {
        return "\(nameString): \(valueString)"
    }

    init(index: Int) {
        self.index = index
        value = 0
    }
}

class DataRegister: Register {
    override class var namePrefix: String {return "D"}
}

class AddressRegister: Register {
    override class var namePrefix: String {return "A"}
}


