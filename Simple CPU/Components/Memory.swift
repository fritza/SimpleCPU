//
//  Memory.swift
//  Simple CPU
//
//  Created by Fritz Anderson on 2/17/19.
//  Copyright © 2019 Fritz Anderson. All rights reserved.
//

import Foundation

// Should be big-endian.
// * It matches the printed representation of registers
// * It's less vulnerable to the bug of casting wide types into narrow by fetching only the first byte.

@dynamicCallable
class Memory {
    enum Errors: Error {
        case alignment(UInt32)
        case access(UInt32)
    }

    let size: RegisterValue
    var data: Data

    // MARK: - fetch/store byte
    func byte(at address: RegisterValue) throws -> RegisterValue {
        guard address < size else { throw Errors.access(address) }
        return RegisterValue(data[Int(address)])
    }

    func dynamicallyCall(
        withKeywordArguments args: KeyValuePairs<String, RegisterValue>)
        throws -> RegisterValue
    {
        var base, index, offset: RegisterValue
        (base, index, offset) = (.zero, .zero, .zero)
        for arg in args {
            switch arg.key {
            case "base":    base = arg.value
            case "index":   index = arg.value
            case "offset":  offset = arg.value
            default: break
            }
        }
        return try byte(at: base + index + offset)
    }

    func store(byte: RegisterValue, at address: RegisterValue) throws {
        guard address < size else { throw Errors.access(address) }
        data[Int(address)] = UInt8(byte)
    }

    // MARK: - fetch/store half-word
    func short(at address: RegisterValue) throws -> RegisterValue {
        guard address < size else { throw Errors.access(address) }
        let answer = try (0...1)
            .reversed()
            .map { try byte(at: address + $0) }
            .reduce(0) {
                ($0 << 8) | $1
        }
        return answer
    }

    func store(short: RegisterValue, at address: RegisterValue) throws {
        let shortBytes = Array(short.bytes[2...3])
        for (n, b) in shortBytes.enumerated() {
            try store(byte: RegisterValue(b), at: address + UInt32(n))
        }
    }

    // MARK: - fetch/store word (RegisterValue)
    func word(at address: RegisterValue) throws -> RegisterValue {
        let answer = try (0...3)
            .reversed()
            .map { try byte(at: address + $0) }
            .reduce(0) {
                ($0 << 8) | $1
        }
        return answer
    }

    func store(word: RegisterValue, at address: RegisterValue) throws {
        for (n, b) in word.bytes.enumerated() {
            try store(byte: RegisterValue(b), at: address + UInt32(n))
        }
    }

    init(size: RegisterValue) {
        self.size = size
        data = Data(repeating: 0, count: Int(size))
    }
}
