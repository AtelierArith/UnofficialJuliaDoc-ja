# Mathematics

## [Mathematical Operators](@id math-ops)

```@docs
Base.:-(::Any)
Base.:(+)
Base.:-(::Any, ::Any)
Base.:*(::Any, ::Any...)
Base.:(/)
Base.:\(::Any, ::Any)
Base.:^(::Number, ::Number)
Base.fma
Base.muladd
Base.inv(::Number)
Base.div
Base.div(::Any, ::Any, ::RoundingMode)
Base.fld
Base.cld
Base.mod
Base.rem
Base.rem(::Any, ::Any, ::RoundingMode)
Base.rem2pi
Base.Math.mod2pi
Base.divrem
Base.fldmod
Base.fld1
Base.mod1
Base.fldmod1
Base.:(//)
Base.rationalize
Base.numerator
Base.denominator
Base.:(<<)
Base.:(>>)
Base.:(>>>)
Base.bitrotate
Base.:(:)(::Any, ::Any, ::Any)
Base.:(:)(::CartesianIndex, ::CartesianIndex, ::CartesianIndex)
Base.range
Base.OneTo
Base.StepRangeLen
Base.logrange
Base.LogRange
Base.:(==)
Base.:(!=)
Base.:(!==)
Base.:(<)
Base.:(<=)
Base.:(>)
Base.:(>=)
Base.cmp
Base.:(~)
Base.:(&)
Base.:(|)
Base.xor
Base.nand
Base.nor
Base.:(!)
&&
||
```

## Mathematical Functions

```@docs
Base.isapprox
Base.sin(::Number)
Base.cos(::Number)
Base.sincos(::Float64)
Base.tan(::Number)
Base.Math.sind
Base.Math.cosd
Base.Math.tand
Base.Math.sincosd
Base.Math.sinpi
Base.Math.cospi
Base.Math.tanpi
Base.Math.sincospi
Base.sinh(::Number)
Base.cosh(::Number)
Base.tanh(::Number)
Base.asin(::Number)
Base.acos(::Number)
Base.atan(::Number)
Base.Math.asind
Base.Math.acosd
Base.Math.atand
Base.Math.sec(::Number)
Base.Math.csc(::Number)
Base.Math.cot(::Number)
Base.Math.secd
Base.Math.cscd
Base.Math.cotd
Base.Math.asec(::Number)
Base.Math.acsc(::Number)
Base.Math.acot(::Number)
Base.Math.asecd
Base.Math.acscd
Base.Math.acotd
Base.Math.sech(::Number)
Base.Math.csch(::Number)
Base.Math.coth(::Number)
Base.asinh(::Number)
Base.acosh(::Number)
Base.atanh(::Number)
Base.Math.asech(::Number)
Base.Math.acsch(::Number)
Base.Math.acoth(::Number)
Base.Math.sinc
Base.Math.cosc
Base.Math.deg2rad
Base.Math.rad2deg
Base.Math.hypot
Base.log(::Number)
Base.log(::Number, ::Number)
Base.log2
Base.log10
Base.log1p
Base.Math.frexp
Base.exp(::Float64)
Base.exp2
Base.exp10
Base.Math.ldexp
Base.Math.modf
Base.expm1
Base.round
Base.Rounding.RoundingMode
Base.Rounding.RoundNearest
Base.Rounding.RoundNearestTiesAway
Base.Rounding.RoundNearestTiesUp
Base.Rounding.RoundToZero
Base.Rounding.RoundFromZero
Base.Rounding.RoundUp
Base.Rounding.RoundDown
Base.round(::Complex{<: AbstractFloat}, ::RoundingMode, ::RoundingMode)
Base.ceil
Base.floor
Base.trunc
Base.unsafe_trunc
Base.min
Base.max
Base.minmax
Base.Math.clamp
Base.Math.clamp!
Base.abs
Base.Checked
Base.Checked.checked_abs
Base.Checked.checked_neg
Base.Checked.checked_add
Base.Checked.checked_sub
Base.Checked.checked_mul
Base.Checked.checked_div
Base.Checked.checked_rem
Base.Checked.checked_fld
Base.Checked.checked_mod
Base.Checked.checked_cld
Base.Checked.checked_pow
Base.Checked.add_with_overflow
Base.Checked.sub_with_overflow
Base.Checked.mul_with_overflow
Base.abs2
Base.copysign
Base.sign
Base.signbit
Base.flipsign
Base.sqrt(::Number)
Base.isqrt
Base.Math.cbrt(::AbstractFloat)
Base.fourthroot(::Number)
Base.real
Base.imag
Base.reim
Base.conj
Base.angle
Base.cis
Base.cispi
Base.binomial
Base.factorial
Base.gcd
Base.lcm
Base.gcdx
Base.ispow2
Base.nextpow
Base.prevpow
Base.nextprod
Base.invmod
Base.powermod
Base.ndigits
Base.add_sum
Base.uabs
Base.widemul
Base.Math.evalpoly
Base.Math.@evalpoly
Base.FastMath.@fastmath
```

## Customizable binary operators

Some unicode characters can be used to define new binary operators that support infix notation. For example `⊗(x,y) = kron(x,y)` defines the `⊗` (otimes) function to be the Kronecker product, and one can call it as binary operator using infix syntax: `C = A ⊗ B` as well as with the usual prefix syntax `C = ⊗(A,B)`.

Other characters that support such extensions include \odot `⊙` and \oplus `⊕`

The complete list is in the parser code: ['h': ASCII/Unicode U+0068 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'p': ASCII/Unicode U+0070 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)':': ASCII/Unicode U+003A (category Po: Punctuation, other)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'g': ASCII/Unicode U+0067 (category Ll: Letter, lowercase)'i': ASCII/Unicode U+0069 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'h': ASCII/Unicode U+0068 (category Ll: Letter, lowercase)'u': ASCII/Unicode U+0075 (category Ll: Letter, lowercase)'b': ASCII/Unicode U+0062 (category Ll: Letter, lowercase)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'m': ASCII/Unicode U+006D (category Ll: Letter, lowercase)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'J': ASCII/Unicode U+004A (category Lu: Letter, uppercase)'u': ASCII/Unicode U+0075 (category Ll: Letter, lowercase)'l': ASCII/Unicode U+006C (category Ll: Letter, lowercase)'i': ASCII/Unicode U+0069 (category Ll: Letter, lowercase)'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)'L': ASCII/Unicode U+004C (category Lu: Letter, uppercase)'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)'n': ASCII/Unicode U+006E (category Ll: Letter, lowercase)'g': ASCII/Unicode U+0067 (category Ll: Letter, lowercase)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'j': ASCII/Unicode U+006A (category Ll: Letter, lowercase)'u': ASCII/Unicode U+0075 (category Ll: Letter, lowercase)'l': ASCII/Unicode U+006C (category Ll: Letter, lowercase)'i': ASCII/Unicode U+0069 (category Ll: Letter, lowercase)'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'b': ASCII/Unicode U+0062 (category Ll: Letter, lowercase)'l': ASCII/Unicode U+006C (category Ll: Letter, lowercase)'o': ASCII/Unicode U+006F (category Ll: Letter, lowercase)'b': ASCII/Unicode U+0062 (category Ll: Letter, lowercase)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'m': ASCII/Unicode U+006D (category Ll: Letter, lowercase)'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)'t': ASCII/Unicode U+0074 (category Ll: Letter, lowercase)'e': ASCII/Unicode U+0065 (category Ll: Letter, lowercase)'r': ASCII/Unicode U+0072 (category Ll: Letter, lowercase)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)'r': ASCII/Unicode U+0072 (category Ll: Letter, lowercase)'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)'/': ASCII/Unicode U+002F (category Po: Punctuation, other)'j': ASCII/Unicode U+006A (category Ll: Letter, lowercase)'u': ASCII/Unicode U+0075 (category Ll: Letter, lowercase)'l': ASCII/Unicode U+006C (category Ll: Letter, lowercase)'i': ASCII/Unicode U+0069 (category Ll: Letter, lowercase)'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)'-': ASCII/Unicode U+002D (category Pd: Punctuation, dash)'p': ASCII/Unicode U+0070 (category Ll: Letter, lowercase)'a': ASCII/Unicode U+0061 (category Ll: Letter, lowercase)'r': ASCII/Unicode U+0072 (category Ll: Letter, lowercase)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)'e': ASCII/Unicode U+0065 (category Ll: Letter, lowercase)'r': ASCII/Unicode U+0072 (category Ll: Letter, lowercase)'.': ASCII/Unicode U+002E (category Po: Punctuation, other)'s': ASCII/Unicode U+0073 (category Ll: Letter, lowercase)'c': ASCII/Unicode U+0063 (category Ll: Letter, lowercase)'m': ASCII/Unicode U+006D (category Ll: Letter, lowercase)](https://github.com/JuliaLang/julia/blob/master/src/julia-parser.scm)

Those that are parsed like `*` (in terms of precedence) include `* / ÷ % & ⋅ ∘ × |\\| ∩ ∧ ⊗ ⊘ ⊙ ⊚ ⊛ ⊠ ⊡ ⊓ ∗ ∙ ∤ ⅋ ≀ ⊼ ⋄ ⋆ ⋇ ⋉ ⋊ ⋋ ⋌ ⋏ ⋒ ⟑ ⦸ ⦼ ⦾ ⦿ ⧶ ⧷ ⨇ ⨰ ⨱ ⨲ ⨳ ⨴ ⨵ ⨶ ⨷ ⨸ ⨻ ⨼ ⨽ ⩀ ⩃ ⩄ ⩋ ⩍ ⩎ ⩑ ⩓ ⩕ ⩘ ⩚ ⩜ ⩞ ⩟ ⩠ ⫛ ⊍ ▷ ⨝ ⟕ ⟖ ⟗` and those that are parsed like `+` include `+ - |\|| ⊕ ⊖ ⊞ ⊟ |++| ∪ ∨ ⊔ ± ∓ ∔ ∸ ≏ ⊎ ⊻ ⊽ ⋎ ⋓ ⟇ ⧺ ⧻ ⨈ ⨢ ⨣ ⨤ ⨥ ⨦ ⨧ ⨨ ⨩ ⨪ ⨫ ⨬ ⨭ ⨮ ⨹ ⨺ ⩁ ⩂ ⩅ ⩊ ⩌ ⩏ ⩐ ⩒ ⩔ ⩖ ⩗ ⩛ ⩝ ⩡ ⩢ ⩣` There are many others that are related to arrows, comparisons, and powers.
