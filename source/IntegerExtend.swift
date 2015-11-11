//
//  IntegerExtend.swift
//  Earley
//
//  Created by Andrew Bennett on 4/11/2015.
//  Copyright © 2015 TeamBnut. All rights reserved.
//

public struct IntegerExtend<HalfType: UnsignedIntegerExtendType> {
    private let unsignedValue: UnsignedIntegerExtend<HalfType>

    private var lo: HalfType { return unsignedValue.lo }
    private var hi: HalfType { return unsignedValue.hi }

    public init(truncatingBitPattern value: UnsignedIntegerExtend<HalfType>) {
        unsignedValue = value
    }
    public init(lo: HalfType, hi: HalfType) {
        unsignedValue = UnsignedIntegerExtend(lo: lo, hi: hi)
    }

    public static var bitCount: UIntMax { return HalfType.bitCount << 1 }

    private var isPositive: Bool {
        return !((unsignedValue.hi & ~(HalfType.allZeros >> 1)) == HalfType.allZeros)
    }
    private var abs: IntegerExtend {
        return IntegerExtend(lo: unsignedValue.lo, hi: unsignedValue.hi & (HalfType.allZeros >> 1))
    }
}

extension UnsignedIntegerExtend {
    init(truncatingBitPattern value: IntegerExtend<HalfType>) {
        self = value.unsignedValue
    }
}

extension IntegerExtend: IntegerLiteralConvertible {
    public typealias IntegerLiteralType = IntMax
    public init(integerLiteral value: IntMax) {
        unsignedValue = UnsignedIntegerExtend(lo: HalfType(UIntMax(value)), hi: HalfType.allZeros)
    }
    public init(_builtinIntegerLiteral value: _MaxBuiltinIntegerType) {
        value
    }
}

extension IntegerExtend: SignedIntegerType {
    public init(_ value: IntMax) {
        unsignedValue = UnsignedIntegerExtend(lo: HalfType(UIntMax(value)), hi: HalfType.allZeros)
    }
}

extension IntegerExtend: CustomStringConvertible {
    public var description: String {
        return self.isPositive ? self.abs.description : "-\(self.abs.description)"
    }
}

extension IntegerExtend: Hashable {
    public var hashValue: Int {
        return unsignedValue.hashValue
    }
}

extension IntegerExtend: IntegerArithmeticType {
    public func toIntMax() -> IntMax {
        return lo.toIntMax()
    }

    public static func addWithOverflow(lhs: IntegerExtend, _ rhs: IntegerExtend)
        -> (IntegerExtend, overflow: Bool)
    {
        let value = UnsignedIntegerExtend.addWithOverflow(lhs.unsignedValue, rhs.unsignedValue)
        return (IntegerExtend(truncatingBitPattern: value.0), value.overflow)
    }

    public static func subtractWithOverflow(lhs: IntegerExtend, _ rhs: IntegerExtend)
        -> (IntegerExtend, overflow: Bool)
    {
        let value = UnsignedIntegerExtend.subtractWithOverflow(lhs.unsignedValue, rhs.unsignedValue)
        return (IntegerExtend(truncatingBitPattern: value.0), value.overflow)
    }

    public static func multiplyWithOverflow(lhs: IntegerExtend, _ rhs: IntegerExtend)
        -> (IntegerExtend, overflow: Bool)
    {
        let value = UnsignedIntegerExtend.multiplyWithOverflow(lhs.unsignedValue, rhs.unsignedValue)
        return (IntegerExtend(truncatingBitPattern: value.0), value.overflow)
    }

    public static func divideWithOverflow(lhs: IntegerExtend, _ rhs: IntegerExtend)
        -> (IntegerExtend, overflow: Bool)
    {
        let value = UnsignedIntegerExtend.divideWithOverflow(lhs.unsignedValue, rhs.unsignedValue)
        return (IntegerExtend(truncatingBitPattern: value.0), value.overflow)
    }

    public static func remainderWithOverflow(lhs: IntegerExtend, _ rhs: IntegerExtend)
        -> (IntegerExtend, overflow: Bool)
    {
        let value = UnsignedIntegerExtend.remainderWithOverflow(lhs.unsignedValue, rhs.unsignedValue)
        return (IntegerExtend(truncatingBitPattern: value.0), value.overflow)
    }
}

extension IntegerExtend: BitwiseOperationsType {
    public init(_ halfType: HalfType) {
        self.init(lo: halfType, hi: HalfType.allZeros)
    }
    public static var allZeros: IntegerExtend {
        return IntegerExtend(lo: HalfType.allZeros, hi: HalfType.allZeros)
    }
}

extension IntegerExtend: BidirectionalIndexType {
    public func predecessor() -> IntegerExtend {
        let value = IntegerExtend<HalfType>.subtractWithOverflow(self, IntegerExtend(1))
        assert(!value.overflow, "Cannot find predecessor of \(self)")
        return value.0
    }
    public func successor() -> IntegerExtend {
        let value = IntegerExtend<HalfType>.addWithOverflow(self, IntegerExtend(1))
        assert(!value.overflow, "Cannot find successor of \(self)")
        return value.0
    }
}

extension IntegerExtend: ForwardIndexType {
    public typealias Distance = IntegerExtend

    @warn_unused_result
    public func advancedBy(n: Distance) -> IntegerExtend {
        let value = IntegerExtend<HalfType>.addWithOverflow(self, n)
        assert(!value.overflow, "Overflow in advancedBy \(self)")
        return value.0
    }

    @warn_unused_result
    public func advancedBy(n: Distance, limit: IntegerExtend) -> IntegerExtend {
        let value = IntegerExtend<HalfType>.addWithOverflow(self, n)
        if value.overflow || value.0 > limit {
            return limit
        }
        return value.0
    }

    @warn_unused_result
    public func distanceTo(end: IntegerExtend) -> Distance {
        let value = IntegerExtend<HalfType>.subtractWithOverflow(end, self)
        assert(!value.overflow, "Cannot find distanceTo \(self)")
        return value.0
    }
}

//extension IntegerExtend: RandomAccessIndexType {
//}
//
//extension IntegerExtend: Strideable {
//}

@warn_unused_result
public func == <T: Equatable>(lhs: IntegerExtend<T>, rhs: IntegerExtend<T>) -> Bool {
    return lhs.unsignedValue == rhs.unsignedValue
}

@warn_unused_result
public func < <T: Comparable>(lhs: IntegerExtend<T>, rhs: IntegerExtend<T>) -> Bool {
    return lhs.unsignedValue < rhs.unsignedValue
}

@warn_unused_result
public func <= <T: Comparable>(lhs: IntegerExtend<T>, rhs: IntegerExtend<T>) -> Bool {
    return lhs.unsignedValue <= rhs.unsignedValue
}

@warn_unused_result
public func > <T: Comparable>(lhs: IntegerExtend<T>, rhs: IntegerExtend<T>) -> Bool {
    return lhs.unsignedValue > rhs.unsignedValue
}

@warn_unused_result
public func >= <T: Comparable>(lhs: IntegerExtend<T>, rhs: IntegerExtend<T>) -> Bool {
    return lhs.unsignedValue >= rhs.unsignedValue
}

@warn_unused_result
public func & <T: BitwiseOperationsType>(lhs: IntegerExtend<T>, rhs: IntegerExtend<T>) -> IntegerExtend<T> {
    return IntegerExtend(truncatingBitPattern: lhs.unsignedValue & rhs.unsignedValue)
}
@warn_unused_result
public func | <T: BitwiseOperationsType>(lhs: IntegerExtend<T>, rhs: IntegerExtend<T>) -> IntegerExtend<T> {
    return IntegerExtend(truncatingBitPattern: lhs.unsignedValue | rhs.unsignedValue)
}
@warn_unused_result
public func ^ <T: BitwiseOperationsType>(lhs: IntegerExtend<T>, rhs: IntegerExtend<T>) -> IntegerExtend<T> {
    return IntegerExtend(truncatingBitPattern: lhs.unsignedValue ^ rhs.unsignedValue)
}

@warn_unused_result
public prefix func ~ <T: BitwiseOperationsType>(that: IntegerExtend<T>) -> IntegerExtend<T> {
    return IntegerExtend(truncatingBitPattern: ~that.unsignedValue)
}

@warn_unused_result
public func << <T: BitwiseOperationsType where T: IntegerType, T: IntegerExtendType>
    (lhs: IntegerExtend<T>, rhs: IntegerExtend<T>) -> IntegerExtend<T>
{
    return IntegerExtend(truncatingBitPattern: lhs.unsignedValue << rhs.unsignedValue)
}

@warn_unused_result
public func >> <T: BitwiseOperationsType where T: IntegerType, T: IntegerExtendType>
    (lhs: IntegerExtend<T>, rhs: IntegerExtend<T>) -> IntegerExtend<T>
{
    return IntegerExtend(truncatingBitPattern: lhs.unsignedValue >> rhs.unsignedValue)
}
