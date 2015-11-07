//
//  UIntExtendBitwiseOperationsType.swift
//  Earley
//
//  Created by Andrew Bennett on 1/11/2015.
//  Copyright © 2015 TeamBnut. All rights reserved.
//

// BitwiseOperationsType

extension UIntExtendType where HalfType: BitwiseOperationsType {
    public static var allZeros: Self {
        return Self(lo: HalfType.allZeros, hi: HalfType.allZeros)
    }
}

@warn_unused_result
public func & <T:UIntExtendType where T.HalfType: BitwiseOperationsType>(lhs: T, rhs: T) -> T {
    return T(lo: lhs.lo & rhs.lo, hi: lhs.hi & rhs.hi)
}
@warn_unused_result
public func | <T:UIntExtendType where T.HalfType: BitwiseOperationsType>(lhs: T, rhs: T) -> T {
    return T(lo: lhs.lo | rhs.lo, hi: lhs.hi | rhs.hi)
}
@warn_unused_result
public func ^ <T:UIntExtendType where T.HalfType: BitwiseOperationsType>(lhs: T, rhs: T) -> T {
    return T(lo: lhs.lo ^ rhs.lo, hi: lhs.hi ^ rhs.hi)
}

@warn_unused_result
public prefix func ~ <T:UIntExtendType where T.HalfType: BitwiseOperationsType>(that: T) -> T {
    return T(lo: ~that.lo, hi: ~that.hi)
}

@warn_unused_result
public func << <T:UIntExtendType where T.HalfType: BitwiseOperationsType, T.HalfType: IntegerArithmeticType>
    (lhs: T, rhs: T) -> T
{
    let halfSize = T.HalfType(T.HalfType.bitCount)
    if rhs.hi >= halfSize {
        return T.allZeros
    }

    var n = rhs.lo
    var lo = lhs.lo, hi = lhs.hi
    if n >= halfSize {
        n -= halfSize
        hi = lo
        lo = T.HalfType.allZeros
    }

    if n != T.HalfType.allZeros {
        let mask = ~((~T.HalfType(0)) >> n)
        hi = (hi << n) | ((lo & mask) >> (halfSize - n))
        lo = lo << n
    }

    return T(lo: lo, hi: hi)
}

@warn_unused_result
public func >> <T:UIntExtendType where T.HalfType: BitwiseOperationsType, T.HalfType: IntegerArithmeticType>
    (lhs: T, rhs: T) -> T
{
    let halfSize = T.HalfType(T.HalfType.bitCount)
    if rhs.hi >= halfSize {
        return T.allZeros
    }

    var n = rhs.lo
    var lo = lhs.lo, hi = lhs.hi
    if n >= halfSize {
        n -= halfSize
        lo = hi
        hi = T.HalfType.allZeros
    }

    if n != T.HalfType.allZeros {
        let mask = ~((~T.HalfType(0)) << n)
        lo = (lo >> n) | ((hi & mask) >> (halfSize - n))
        hi = hi >> n
    }

    return T(lo: lo, hi: hi)
}
