//
//  UIntExtendBidirectionalIterator.swift
//  Earley
//
//  Created by Andrew Bennett on 4/11/2015.
//  Copyright © 2015 TeamBnut. All rights reserved.
//

// BidirectionalIndexType

extension UIntExtendType where Self: IntegerArithmeticType {
    public func predecessor() -> Self {
        return self - Self(1)
    }
    public func successor() -> Self {
        return self + Self(1)
    }
}
