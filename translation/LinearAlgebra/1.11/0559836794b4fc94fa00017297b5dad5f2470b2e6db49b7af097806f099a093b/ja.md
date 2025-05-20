```
Bidiagonal(dv::V, ev::V, uplo::Symbol) where V <: AbstractVector
```

与えられた対角ベクトル（`dv`）とオフ対角ベクトル（`ev`）を使用して、上三角（`uplo=:U`）または下三角（`uplo=:L`）のバイダイアゴナル行列を構築します。結果は `Bidiagonal` 型であり、効率的な特化型線形ソルバーを提供しますが、[`convert(Array, _)`](@ref)（または短縮形の `Array(_)`）を使用して通常の行列に変換することができます。`ev` の長さは `dv` の長さよりも1少なくなければなりません。

# 例

```jldoctest
julia> dv = [1, 2, 3, 4]
4-element Vector{Int64}:
 1
 2
 3
 4

julia> ev = [7, 8, 9]
3-element Vector{Int64}:
 7
 8
 9

julia> Bu = Bidiagonal(dv, ev, :U) # ev は最初のスーパー対角にあります
4×4 Bidiagonal{Int64, Vector{Int64}}:
 1  7  ⋅  ⋅
 ⋅  2  8  ⋅
 ⋅  ⋅  3  9
 ⋅  ⋅  ⋅  4

julia> Bl = Bidiagonal(dv, ev, :L) # ev は最初のサブ対角にあります
4×4 Bidiagonal{Int64, Vector{Int64}}:
 1  ⋅  ⋅  ⋅
 7  2  ⋅  ⋅
 ⋅  8  3  ⋅
 ⋅  ⋅  9  4
```
