//
//  UIntExtend.swift
//  Earley
//
//  Created by Andrew Bennett on 4/11/2015.
//  Copyright © 2015 TeamBnut. All rights reserved.
//

public struct UIntExtend<HalfType: UIntExtendType>: UIntExtendType {
    public let lo: HalfType
    public let hi: HalfType

    public init(_ value: UIntMax) {
        lo = HalfType(value)
        hi = HalfType(0)
    }

    public init(lo: HalfType, hi: HalfType) {
        self.lo = lo
        self.hi = hi
    }

    public static var bitCount: UIntMax { return HalfType.bitCount + HalfType.bitCount }
}

private extension UIntMax: UIntExtendType {
    public typealias HalfType = UIntMax

    public init(lo: HalfType, hi: HalfType) {
        self = UIntMax(lo) + (UIntMax(hi) << UIntMax.halfBitCount)
    }

    public var lo: HalfType {
        return HalfType(self & UIntMax.halfBitMask)
    }
    public var hi: HalfType {
        return HalfType(self >> UIntMax.halfBitCount)
    }

    public static let bitCount = UIntMax(sizeof(UIntMax)) << 3
    private static let halfBitCount = UIntMax.bitCount >> 1
    private static let halfBitMask = (1 << halfBitCount) - 1
}


typealias UInt128 = UIntExtend<UInt64>
