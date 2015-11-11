//
//  UnsignedIntegerExtendType.swift
//  Earley
//
//  Created by Andrew Bennett on 31/10/2015.
//  Copyright © 2015 TeamBnut. All rights reserved.
//

public protocol UnsignedIntegerExtendType: UnsignedIntegerType {
    @warn_unused_result
    func <<(lhs: Self, rhs: Self) -> Self

    @warn_unused_result
    func >>(lhs: Self, rhs: Self) -> Self

    static var bitCount: UIntMax { get }
}

public protocol IntegerExtendType: SignedIntegerType {
    @warn_unused_result
    func <<(lhs: Self, rhs: Self) -> Self

    @warn_unused_result
    func >>(lhs: Self, rhs: Self) -> Self

    static var bitCount: UIntMax { get }
}
