//
//  UIntExtendComparable.swift
//  Earley
//
//  Created by Andrew Bennett on 1/11/2015.
//  Copyright © 2015 TeamBnut. All rights reserved.
//

// Comparable

@warn_unused_result
public func < <T:UIntExtendType where T.HalfType: Comparable>(lhs: T, rhs: T) -> Bool {
    return (lhs.hi < rhs.hi) || (lhs.hi == rhs.hi && lhs.lo < rhs.lo)
}

@warn_unused_result
public func <= <T:UIntExtendType where T.HalfType: Comparable>(lhs: T, rhs: T) -> Bool {
    return (lhs.hi <= rhs.hi) || (lhs.hi == rhs.hi && lhs.lo <= rhs.lo)
}

@warn_unused_result
public func > <T:UIntExtendType where T.HalfType: Comparable>(lhs: T, rhs: T) -> Bool {
    return (lhs.hi > rhs.hi) || (lhs.hi == rhs.hi && lhs.lo > rhs.lo)
}

@warn_unused_result
public func >= <T:UIntExtendType where T.HalfType: Comparable>(lhs: T, rhs: T) -> Bool {
    return (lhs.hi >= rhs.hi) || (lhs.hi == rhs.hi && lhs.lo >= rhs.lo)
}
