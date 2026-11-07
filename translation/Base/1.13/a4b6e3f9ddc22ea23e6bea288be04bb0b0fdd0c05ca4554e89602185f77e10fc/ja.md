```julia
rem(x, y, r::RoundingMode=RoundToZero)
```

`x` を `y` で整数除算したときの余りを、丸めモード `r` に従って商を丸めて計算します。つまり、次の量です。

```julia
x - y * round(x / y, r)
```

中間丸めは行いません。

  * `r == RoundNearest` の場合、結果は正確で、区間 ``[-|y| / 2, |y| / 2]`` に含まれます。[`RoundNearest`](@ref) も参照してください。
  * `r == RoundToZero`（デフォルト）の場合、結果は正確で、`x` が正なら区間 ``[0, |y|)`` に、そうでなければ区間 ``(-|y|, 0]`` に含まれます。[`RoundToZero`](@ref) も参照してください。
  * `r == RoundDown` の場合、`y` が正なら区間 ``[0, y)`` に、そうでなければ区間 ``(y, 0]`` に含まれます。`x` と `y` の符号が異なり、かつ `abs(x) < abs(y)` の場合、結果は正確でないことがあります。[`RoundDown`](@ref) も参照してください。
  * `r == RoundUp` の場合、`y` が正なら区間 ``(-y, 0]`` に、そうでなければ区間 ``[0, -y)`` に含まれます。`x` と `y` の符号が同じで、かつ `abs(x) < abs(y)` の場合、結果は正確でないことがあります。[`RoundUp`](@ref) も参照してください。
  * `r == RoundFromZero` の場合、`y` が正なら区間 ``(-y, 0]`` に、そうでなければ区間 ``[0, -y)`` に含まれます。`x` と `y` の符号が同じで、かつ `abs(x) < abs(y)` の場合、結果は正確でないことがあります。[`RoundFromZero`](@ref) も参照してください。

!!! compat "Julia 1.9"
    `RoundFromZero` は Julia 1.9 以降が必要です。


# Examples:

```jldoctest
julia> x = 9; y = 4;

julia> x % y  # same as rem(x, y)
1

julia> x ÷ y  # same as div(x, y)
2

julia> x == div(x, y) * y + rem(x, y)
true
```
