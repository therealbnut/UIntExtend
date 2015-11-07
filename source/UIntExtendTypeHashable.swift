//
//  UIntExtendHashable.swift
//  Earley
//
//  Created by Andrew Bennett on 4/11/2015.
//  Copyright © 2015 TeamBnut. All rights reserved.
//

// Hashable

extension UIntExtendType where HalfType: Hashable {
    public var hashValue: Int {
        return Int(truncatingBitPattern: UIntMax(0x784dd2271e0f0f17)) &* lo.hashValue &+ hi.hashValue
    }
}

@warn_unused_result
public func == <T:UIntExtendType where T.HalfType: Equatable>(lhs: T, rhs: T) -> Bool {
    return lhs.lo == rhs.lo && lhs.hi == rhs.hi
}
