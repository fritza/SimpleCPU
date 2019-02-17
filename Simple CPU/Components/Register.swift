//
//  Register.swift
//  Simple CPU
//
//  Created by Fritz Anderson on 2/17/19.
//  Copyright © 2019 Fritz Anderson. All rights reserved.
//

import Foundation


typealias RegisterValue = UInt32
enum HexFlag: String, CaseIterable {
    case none = ""
    case hash = "#"
    case radix = "0x"
    case dollar = "$"

    static let stringSet: CharacterSet = {
        let setString = "#$"
        return CharacterSet(charactersIn: setString)
    }()

    static let hexSet: CharacterSet = {
        return CharacterSet(charactersIn: "_0123456789ABCDEF")
    }()

    // TODO: Should throw
    static func parse(_ string: String) -> RegisterValue? {
        let scanner = Scanner(string: string)
        // Scan past any hex-flag prefix
        // "0x" is a special case. The others can be scanned.
        _ = scanner.scanString(HexFlag.radix.rawValue, into: nil)
            || scanner.scanCharacters(from: stringSet,
                                      into: nil)

        // Now scan a hexidecimal string
        var sourceString: NSString?
        scanner.scanCharacters(from: hexSet,
                               into: &sourceString)
        if let hexString = sourceString {
            let noUnderscores = hexString.replacingOccurrences(of: "_", with: "")
            return RegisterValue(noUnderscores, radix: 16)
        }
        return nil
    }
}

extension RegisterValue {
    func hexString(flagged: HexFlag = .none) -> String {
        let width = MemoryLayout<RegisterValue>.size * 2
        let intermediate = String(self, radix: 16, uppercase: false)
        return
            flagged.rawValue
                + String(repeating: "0", count: width - intermediate.count)
                + intermediate
    }
}

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

    func valueString() -> String {
        return value.hexString(flagged: .hash)
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


