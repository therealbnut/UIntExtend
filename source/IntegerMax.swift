//
//  IntegerMax.swift
//  UnsignedIntegerExtendType
//
//  Created by Andrew Bennett on 10/11/2015.
//  Copyright © 2015 TeamBnut. All rights reserved.
//

extension UIntMax: UnsignedIntegerExtendType {
    public static let bitCount = UIntMax(sizeof(UIntMax)) << 3
}

typealias UInt128 = UnsignedIntegerExtend<UInt64>

extension IntMax: IntegerExtendType {
    public static let bitCount = UIntMax(sizeof(IntMax)) << 3
}

typealias Int128 = UnsignedIntegerExtend<UInt64>
