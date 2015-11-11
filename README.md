# UnsignedIntegerExtendType
Given a UInt64 create a new UInt128 type, given UInt128 create UInt256, etc.

Example usage:

    typealias UInt128 = UnsignedIntegerExtendType<UInt64>
    typealias UInt256 = UnsignedIntegerExtendType<UInt128>
    ...

# Known Issues
There are some compiler errors currently. I think the compiler gets stuck in an infinite loop resolving the types.
I'll revisit this later.
