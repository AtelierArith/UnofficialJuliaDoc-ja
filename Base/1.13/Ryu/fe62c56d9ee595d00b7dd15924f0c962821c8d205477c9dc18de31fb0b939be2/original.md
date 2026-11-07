```julia
Ryu.writeshortest(x, plus=false, space=false, hash=true, precision=-1, expchar=UInt8('e'), padexp=false, decchar=UInt8('.'), typed=false, compact=false)
Ryu.writeshortest(buf::AbstractVector{UInt8}, pos::Int, x, args...)
```

Convert a float value `x` into its "shortest" decimal string, which can be parsed back to the same value. This function allows achieving the `%g` printf format. Note the 2nd method allows passing in a byte buffer and position directly; callers must ensure the buffer has sufficient room to hold the entire decimal string.

Various options for the output format include:

  * `plus`: for positive `x`, prefix decimal string with a `'+'` character
  * `space`: for positive `x`, prefix decimal string with a `' '` character; overridden if `plus=true`
  * `hash`: whether the decimal point should be written, even if no additional digits are needed for precision
  * `precision`: minimum number of digits to be included in the decimal string; extra `'0'` characters will be added for padding if necessary
  * `expchar`: character to use exponent component in scientific notation
  * `padexp`: whether two digits should always be written, even for single-digit exponents (e.g. `e+1` becomes `e+01`)
  * `decchar`: decimal point character to be used
  * `typed`: whether additional type information should be printed for `Float16` / `Float32`
  * `compact`: output will be limited to 6 significant digits
