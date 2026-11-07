```julia
Ryu.writeexp(x, precision, plus=false, space=false, hash=false, expchar=UInt8('e'), decchar=UInt8('.'), trimtrailingzeros=false)
Ryu.writeexp(buf::AbstractVector{UInt8}, pos::Int, x, args...)
```

Convert a float value `x` into a scientific notation decimal string. This function allows achieving the `%e` printf format. Note the 2nd method allows passing in a byte buffer and position directly; callers must ensure the buffer has sufficient room to hold the entire decimal string.

Various options for the output format include:

  * `plus`: for positive `x`, prefix decimal string with a `'+'` character
  * `space`: for positive `x`, prefix decimal string with a `' '` character; overridden if `plus=true`
  * `hash`: whether the decimal point should be written, even if no additional digits are needed for precision
  * `precision`: minimum number of significant digits to be included in the decimal string; extra `'0'` characters will be added for padding if necessary
  * `expchar`: character to use exponent component in scientific notation
  * `decchar`: decimal point character to be used
  * `trimtrailingzeros`: whether trailing zeros should be removed
