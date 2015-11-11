//
//  UnsignedIntegerExtend.swift
//  Earley
//
//  Created by Andrew Bennett on 4/11/2015.
//  Copyright © 2015 TeamBnut. All rights reserved.
//

public struct UnsignedIntegerExtend<HalfType: UnsignedIntegerExtendType> {
    public let lo: HalfType
    public let hi: HalfType

    public init(lo: HalfType, hi: HalfType) {
        self.lo = lo
        self.hi = hi
    }

    public static var bitCount: UIntMax { return HalfType.bitCount << 1 }
}

extension UnsignedIntegerExtend: IntegerLiteralConvertible {
    public typealias IntegerLiteralType = UIntMax
    public init(integerLiteral value: UIntMax) {
        lo = HalfType(value)
        hi = HalfType.allZeros
    }
    public init(_builtinIntegerLiteral value: _MaxBuiltinIntegerType) {
        value
    }
}

extension UnsignedIntegerExtend: UnsignedIntegerType {
    public init(_ value: UIntMax) {
        lo = HalfType(value)
        hi = HalfType.allZeros
    }
}

extension UnsignedIntegerExtend: CustomStringConvertible {
    public var description: String {
        if self == UnsignedIntegerExtend.allZeros {
            return "0"
        }
        let base = UnsignedIntegerExtend(10)
        var value = self, string = ""
        while !(value == UnsignedIntegerExtend.allZeros) {
            let digit = UnsignedIntegerExtend.remainderWithOverflow(value, base).0
            let digitChar = UnicodeScalar(48 + Int(digit.toIntMax()))
            string.append(digitChar)
            value = UnsignedIntegerExtend.divideWithOverflow(value, base).0
        }
        return string
    }
}

extension UnsignedIntegerExtend: Hashable {
    public var hashValue: Int {
        return Int(truncatingBitPattern: UIntMax(0x784dd2271e0f0f17)) &* lo.hashValue &+ hi.hashValue
    }
}

extension UnsignedIntegerExtend: IntegerArithmeticType {
    public func toIntMax() -> IntMax {
        return lo.toIntMax()
    }

    public func toUIntMax() -> UIntMax {
        return lo.toUIntMax()
    }

    public static func addWithOverflow(lhs: UnsignedIntegerExtend, _ rhs: UnsignedIntegerExtend)
        -> (UnsignedIntegerExtend, overflow: Bool)
    {
        let lo = lhs.lo &+ rhs.lo
        var hi = lhs.hi &+ rhs.hi
        if (lo < lhs.lo) {
            hi = hi &+ 1
        }
        return (UnsignedIntegerExtend(lo: lo, hi: hi), hi < lhs.hi)
    }

    public static func subtractWithOverflow(lhs: UnsignedIntegerExtend, _ rhs: UnsignedIntegerExtend)
        -> (UnsignedIntegerExtend, overflow: Bool)
    {
        let v = UnsignedIntegerExtend.addWithOverflow(lhs, UnsignedIntegerExtend.addWithOverflow(~rhs, UnsignedIntegerExtend(1)).0).0
        return (v, lhs < rhs)
    }

    public static func multiplyWithOverflow(lhs: UnsignedIntegerExtend, _ rhs: UnsignedIntegerExtend)
        -> (UnsignedIntegerExtend, overflow: Bool)
    {
        let zero = UnsignedIntegerExtend.allZeros, one = UnsignedIntegerExtend(1)
        if lhs == zero || rhs == zero {
            return (zero, false)
        }
        if rhs == one {
            return (lhs, false)
        }
        if lhs == one {
            return (rhs, false)
        }
        var a = lhs, t = rhs, out: UnsignedIntegerExtend = zero, anyOverflow = false
        for i in 0 ..< UnsignedIntegerExtend.bitCount {
            if !((t & one) == zero) {
                let overflow: Bool
                (out, overflow) = UnsignedIntegerExtend.addWithOverflow(out, (a << UnsignedIntegerExtend(i)))
                anyOverflow = anyOverflow || overflow
            }
            t = t >> one
        }
        return (out, anyOverflow)
    }

    public static func divideWithOverflow(lhs: UnsignedIntegerExtend, _ rhs: UnsignedIntegerExtend)
        -> (UnsignedIntegerExtend, overflow: Bool)
    {
        if rhs == UnsignedIntegerExtend.allZeros {
            return (UnsignedIntegerExtend.allZeros, true)
        }
        let v = UnsignedIntegerExtend.divide(lhs, rhs)
        return (v.quotient, false)
    }

    public static func remainderWithOverflow(lhs: UnsignedIntegerExtend, _ rhs: UnsignedIntegerExtend)
        -> (UnsignedIntegerExtend, overflow: Bool)
    {
        if rhs == UnsignedIntegerExtend.allZeros {
            return (UnsignedIntegerExtend.allZeros, true)
        }
        let v = UnsignedIntegerExtend.divide(lhs, rhs)
        return (v.remainder, false)
    }

    private static func divide(lhs: UnsignedIntegerExtend, _ rhs: UnsignedIntegerExtend)
        -> (quotient: UnsignedIntegerExtend, remainder: UnsignedIntegerExtend)
    {
        let zero = UnsignedIntegerExtend(0), one = UnsignedIntegerExtend(1)
        assert(!(rhs == zero), "divide by zero: \(lhs) / \(rhs)")

        var n = lhs, d = rhs
        var x: UnsignedIntegerExtend = one, answer: UnsignedIntegerExtend = zero
        let mask: UnsignedIntegerExtend = one << UnsignedIntegerExtend(UnsignedIntegerExtend.bitCount - 1)

        while n >= d && (d & mask) == zero {
            x = x << one
            d = d << one
        }

        while !(x == zero) {
            if(n >= d) {
                n = UnsignedIntegerExtend.subtractWithOverflow(n, d).0
                answer = answer | x
            }
            x = x >> one
            d = d >> one
        }
        
        return (answer, n)
    }
}

extension UnsignedIntegerExtend: BitwiseOperationsType {
    public init(_ halfType: HalfType) {
        self.init(lo: halfType, hi: HalfType.allZeros)
    }
    public static var allZeros: UnsignedIntegerExtend {
        return UnsignedIntegerExtend(lo: HalfType.allZeros, hi: HalfType.allZeros)
    }
}

extension UnsignedIntegerExtend: BidirectionalIndexType {
    public func predecessor() -> UnsignedIntegerExtend {
        let value = UnsignedIntegerExtend<HalfType>.subtractWithOverflow(self, UnsignedIntegerExtend(1))
        assert(!value.overflow, "Cannot find predecessor of \(self)")
        return value.0
    }
    public func successor() -> UnsignedIntegerExtend {
        let value = UnsignedIntegerExtend<HalfType>.addWithOverflow(self, UnsignedIntegerExtend(1))
        assert(!value.overflow, "Cannot find successor of \(self)")
        return value.0
    }
}

extension UnsignedIntegerExtend: ForwardIndexType {
    public typealias Distance = IntegerExtend<HalfType>

    @warn_unused_result
    public func advancedBy(n: Distance) -> UnsignedIntegerExtend {
        let value = UnsignedIntegerExtend.addWithOverflow(self, UnsignedIntegerExtend(truncatingBitPattern: n))
        assert(!value.overflow, "Overflow in advancedBy \(self)")
        return value.0
    }

    @warn_unused_result
    public func advancedBy(n: Distance, limit: UnsignedIntegerExtend) -> UnsignedIntegerExtend {
        let value = UnsignedIntegerExtend.addWithOverflow(self, UnsignedIntegerExtend(truncatingBitPattern: n))
        if value.overflow || value.0 > limit {
            return limit
        }
        return value.0
    }

    @warn_unused_result
    public func distanceTo(end: UnsignedIntegerExtend) -> Distance {
        let value = UnsignedIntegerExtend<HalfType>.subtractWithOverflow(end, self)
        assert(!value.overflow, "Cannot find distanceTo \(self)")
        return Distance(truncatingBitPattern: value.0)
    }
}

//extension UnsignedIntegerExtend: RandomAccessIndexType {
//}
//extension UnsignedIntegerExtend: Strideable {
//}

@warn_unused_result
public func == <T: Equatable>(lhs: UnsignedIntegerExtend<T>, rhs: UnsignedIntegerExtend<T>) -> Bool {
    return lhs.lo == rhs.lo && lhs.hi == rhs.hi
}

@warn_unused_result
public func < <T: Comparable>(lhs: UnsignedIntegerExtend<T>, rhs: UnsignedIntegerExtend<T>) -> Bool {
    return (lhs.hi < rhs.hi) || (lhs.hi == rhs.hi && lhs.lo < rhs.lo)
}

@warn_unused_result
public func <= <T: Comparable>(lhs: UnsignedIntegerExtend<T>, rhs: UnsignedIntegerExtend<T>) -> Bool {
    return (lhs.hi <= rhs.hi) || (lhs.hi == rhs.hi && lhs.lo <= rhs.lo)
}

@warn_unused_result
public func > <T: Comparable>(lhs: UnsignedIntegerExtend<T>, rhs: UnsignedIntegerExtend<T>) -> Bool {
    return (lhs.hi > rhs.hi) || (lhs.hi == rhs.hi && lhs.lo > rhs.lo)
}

@warn_unused_result
public func >= <T: Comparable>(lhs: UnsignedIntegerExtend<T>, rhs: UnsignedIntegerExtend<T>) -> Bool {
    return (lhs.hi >= rhs.hi) || (lhs.hi == rhs.hi && lhs.lo >= rhs.lo)
}

@warn_unused_result
public func & <T: BitwiseOperationsType>(lhs: UnsignedIntegerExtend<T>, rhs: UnsignedIntegerExtend<T>) -> UnsignedIntegerExtend<T> {
    return UnsignedIntegerExtend<T>(lo: lhs.lo & rhs.lo, hi: lhs.hi & rhs.hi)
}
@warn_unused_result
public func | <T: BitwiseOperationsType>(lhs: UnsignedIntegerExtend<T>, rhs: UnsignedIntegerExtend<T>) -> UnsignedIntegerExtend<T> {
    return UnsignedIntegerExtend(lo: lhs.lo | rhs.lo, hi: lhs.hi | rhs.hi)
}
@warn_unused_result
public func ^ <T: BitwiseOperationsType>(lhs: UnsignedIntegerExtend<T>, rhs: UnsignedIntegerExtend<T>) -> UnsignedIntegerExtend<T> {
    return UnsignedIntegerExtend(lo: lhs.lo ^ rhs.lo, hi: lhs.hi ^ rhs.hi)
}

@warn_unused_result
public prefix func ~ <T: BitwiseOperationsType>(that: UnsignedIntegerExtend<T>) -> UnsignedIntegerExtend<T> {
    return UnsignedIntegerExtend(lo: ~that.lo, hi: ~that.hi)
}

@warn_unused_result
public func << <T: BitwiseOperationsType where T: UnsignedIntegerType, T: UnsignedIntegerExtendType>
    (lhs: UnsignedIntegerExtend<T>, rhs: UnsignedIntegerExtend<T>) -> UnsignedIntegerExtend<T>
{
    let halfSize = T(T.bitCount)
    if rhs.hi >= halfSize {
        return UnsignedIntegerExtend.allZeros
    }

    var n = rhs.lo
    var lo = lhs.lo, hi = lhs.hi
    if n >= halfSize {
        n -= halfSize
        hi = lo
        lo = T.allZeros
    }

    if n != T.allZeros {
        let mask = ~((~T.allZeros) >> n)
        hi = (hi << n) | ((lo & mask) >> (halfSize - n))
        lo = lo << n
    }

    return UnsignedIntegerExtend(lo: lo, hi: hi)
}

@warn_unused_result
public func >> <T: BitwiseOperationsType where T: UnsignedIntegerType, T: UnsignedIntegerExtendType>
    (lhs: UnsignedIntegerExtend<T>, rhs: UnsignedIntegerExtend<T>) -> UnsignedIntegerExtend<T>
{
    let halfSize = T(T.bitCount)
    if rhs.hi >= halfSize {
        return UnsignedIntegerExtend.allZeros
    }

    var n = rhs.lo
    var lo = lhs.lo, hi = lhs.hi
    if n >= halfSize {
        n -= halfSize
        lo = hi
        hi = T.allZeros
    }

    if n != T.allZeros {
        let mask = ~((~T.allZeros) << n)
        lo = (lo >> n) | ((hi & mask) >> (halfSize - n))
        hi = hi >> n
    }

    return UnsignedIntegerExtend(lo: lo, hi: hi)
}
