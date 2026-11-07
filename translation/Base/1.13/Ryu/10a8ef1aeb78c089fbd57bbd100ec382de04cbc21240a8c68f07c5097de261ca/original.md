```julia
Ryu.writefixed(x, precision, plus=false, space=false, hash=false, decchar=UInt8('.'), trimtrailingzeros=false)
Ryu.writefixed(buf::AbstractVector{UInt8}, pos::Int, x, args...)
```

Convert a float value `x` into a "fixed" size decimal string of the provided precision. This function allows achieving the `%f` printf format. Note the 2nd method allows passing in a byte buffer and position directly; callers must ensure the buffer has sufficient room to hold the entire decimal string.

Various options for the output format include:

  * `plus`: for positive `x`, prefix decimal string with a `'+'` character
  * `space`: for positive `x`, prefix decimal string with a `' '` character; overridden if `plus=true`
  * `hash`: whether the decimal point should be written, even if no additional digits are needed for precision
  * `precision`: minimum number of significant digits to be included in the decimal string; extra `'0'` characters will be added for padding if necessary
  * `decchar`: decimal point character to be used
  * `trimtrailingzeros`: whether trailing zeros of fractional part should be removed
