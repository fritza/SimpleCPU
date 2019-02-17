//
//  RegisterValue.swift
//  Simple CPU
//
//  Created by Fritz Anderson on 2/17/19.
//  Copyright © 2019 Fritz Anderson. All rights reserved.
//

import Foundation

// MARK: - ValueRepresentation
protocol ValueRepresentation {
    var asSigned: SignedRegisterValue { get }
    var asUnsigned: RegisterValue { get }

    func hexString(flagged: HexFlag) -> String
    var shorts: [UInt16] { get }
    var bytes: [UInt8] { get }
}


// MARK: - HexFlag
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

// MARK: - RegisterValue
typealias RegisterValue = UInt32
extension RegisterValue: ValueRepresentation {
    var bytes: [UInt8] {
        var retval: [UInt8] = []
        var cursor = self

        for _ in 1...4 {
            let byte = [UInt8(self & 0x0ff)]
            cursor >>= 8
            retval = byte + retval
        }
        return retval
    }

    var shorts: [UInt16] {
        var retval: [UInt16] = []
        var cursor = self

        for _ in 1...2 {
            let short = [UInt16(self & 0x0ffff)]
            cursor >>= 16
            retval = short + retval
        }
        return retval
    }

    var asSigned: SignedRegisterValue { return SignedRegisterValue(bitPattern: self) }
    var asUnsigned: RegisterValue { return self }

    func hexString(flagged: HexFlag = .none) -> String {
        let width = MemoryLayout<RegisterValue>.size * 2
        let intermediate = String(self, radix: 16, uppercase: false)
        return
            flagged.rawValue
                + String(repeating: "0", count: width - intermediate.count)
                + intermediate
    }
}

// MARK: - SignedRegisterValue
typealias SignedRegisterValue = Int32
extension SignedRegisterValue: ValueRepresentation {
    // MARK: ValueRepresentation
    var asSigned: SignedRegisterValue   { return self }
    var asUnsigned: RegisterValue       { return RegisterValue(bitPattern: self) }
    var bytes: [UInt8]                  { return self.asUnsigned.bytes }
    var shorts: [UInt16]                { return self.asUnsigned.shorts }

    func hexString(flagged: HexFlag = .none) -> String {
        return asUnsigned.hexString(flagged: flagged)
    }
}

