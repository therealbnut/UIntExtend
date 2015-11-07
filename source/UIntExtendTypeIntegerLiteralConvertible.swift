//
//  UIntExtendIntegerLiteralConvertible.swift
//  Earley
//
//  Created by Andrew Bennett on 4/11/2015.
//  Copyright © 2015 TeamBnut. All rights reserved.
//

// IntegerLiteralConvertible

extension UIntExtendType where HalfType: BitwiseOperationsType {
    public typealias IntegerLiteralType = UIntMax
    public init(integerLiteral value: UIntMax) {
        self.init(lo: HalfType(value), hi: HalfType.allZeros)
    }
}
