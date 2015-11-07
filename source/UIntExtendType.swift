//
//  UIntExtend.swift
//  Earley
//
//  Created by Andrew Bennett on 31/10/2015.
//  Copyright © 2015 TeamBnut. All rights reserved.
//

public protocol _UIntExtendType: UnsignedIntegerType {
    init(_ value: UIntMax)

    @warn_unused_result
    func <<(lhs: Self, rhs: Self) -> Self

    @warn_unused_result
    func >>(lhs: Self, rhs: Self) -> Self

    static var bitCount: UIntMax { get }
}

public protocol UIntExtendType: _UIntExtendType {
    typealias HalfType: _UIntExtendType

    var lo: HalfType { get }
    var hi: HalfType { get }

    init(lo: HalfType, hi: HalfType)
}

public extension UIntExtendType where HalfType: BitwiseOperationsType {
    init(fromHalf half: HalfType) {
        self.init(lo: half, hi: HalfType.allZeros)
    }
}
