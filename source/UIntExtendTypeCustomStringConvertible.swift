//
//  UIntExtendCustomStringConvertible.swift
//  Earley
//
//  Created by Andrew Bennett on 4/11/2015.
//  Copyright © 2015 TeamBnut. All rights reserved.
//

// CustomStringConvertible

extension UIntExtendType where Self: BitwiseOperationsType, Self: IntegerArithmeticType {
    public var description: String {
        if self == Self.allZeros {
            return "0"
        }
        let base = Self(10)
        var value = self, string = ""
        while value != Self.allZeros {
            let digit = UnicodeScalar(48 + Int((value % base).toIntMax()))
            string.append(digit)
            value /= base
        }
        return string
    }
}
