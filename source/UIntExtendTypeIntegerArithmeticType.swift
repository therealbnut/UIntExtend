//
//  SelfBinaryOps.swift
//  Earley
//
//  Created by Andrew Bennett on 1/11/2015.
//  Copyright © 2015 TeamBnut. All rights reserved.
//

// IntegerArithmeticType

extension UIntExtendType where HalfType: UnsignedIntegerType {
    public func toIntMax() -> IntMax {
        return lo.toIntMax()
    }

    public func toUIntMax() -> UIntMax {
        return lo.toUIntMax()
    }
}

extension UIntExtendType where HalfType: UnsignedIntegerType {
    public static func addWithOverflow(lhs: Self, _ rhs: Self)
        -> (Self, overflow: Bool)
    {
        let lo = lhs.lo &+ rhs.lo
        var hi = lhs.hi &+ rhs.hi
        if (lo < lhs.lo) {
            hi = hi &+ 1
        }
        return (Self(lo: lo, hi: hi), hi < lhs.hi)
    }
}

extension UIntExtendType where Self: UnsignedIntegerType {
    public static func subtractWithOverflow(lhs: Self, _ rhs: Self)
        -> (Self, overflow: Bool)
    {
        let v = lhs &+ (~rhs &+ Self(1))
        return (v, lhs < rhs)
    }
}

extension UIntExtendType where Self: UnsignedIntegerType {
    public static func multiplyWithOverflow(lhs: Self, _ rhs: Self)
        -> (Self, overflow: Bool)
    {
        let zero = Self(0), one = Self(1)
        if lhs == zero || rhs == zero {
            return (zero, false)
        }
        if rhs == one {
            return (lhs, false)
        }
        if lhs == one {
            return (rhs, false)
        }
        var a = lhs, t = rhs, out: Self = zero, anyOverflow = false
        for i in 0 ..< Self.bitCount {
            if (t & one) != zero {
                let overflow: Bool
                (out, overflow) = Self.addWithOverflow(out, (a << Self(i)))
                anyOverflow = anyOverflow || overflow
            }
            t = t >> one
        }
        return (out, anyOverflow)
    }
}

extension UIntExtendType where Self: UnsignedIntegerType {
    public static func divideWithOverflow(lhs: Self, _ rhs: Self)
        -> (Self, overflow: Bool)
    {
        if rhs == Self.allZeros {
            return (Self.allZeros, true)
        }
        let v = Self.divide(lhs, rhs)
        return (v.quotient, false)
    }
}

extension UIntExtendType where Self: UnsignedIntegerType {
    public static func remainderWithOverflow(lhs: Self, _ rhs: Self)
        -> (Self, overflow: Bool)
    {
        if rhs == Self.allZeros {
            return (Self.allZeros, true)
        }
        let v = Self.divide(lhs, rhs)
        return (v.remainder, false)
    }
}

extension UIntExtendType where Self: UnsignedIntegerType {
    private static func divide(lhs: Self, _ rhs: Self)
        -> (quotient: Self, remainder: Self)
    {
        let zero = Self(0), one = Self(1)
        assert(rhs != zero, "divide by zero: \(lhs) / \(rhs)")

        var n = lhs, d = rhs
        var x: Self = one, answer: Self = zero
        let mask: Self = one << Self(Self.bitCount - 1)

        while n >= d && (d & mask) == zero {
            x = x << one
            d = d << one
        }

        while x != zero {
            if(n >= d) {
                n = n &- d
                answer = answer | x
            }
            x = x >> one
            d = d >> one
        }

        return (answer, n)
    }
}