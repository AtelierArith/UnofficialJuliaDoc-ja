```
isascii(cu::AbstractVector{CU}) where {CU <: Integer} -> Bool
```

Test whether all values in the vector belong to the ASCII character set (0x00 to 0x7f). This function is intended to be used by other string implementations that need a fast ASCII check.
