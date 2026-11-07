```julia
Bidiagonal(dv::V, ev::V, uplo::Symbol) where V <: AbstractVector
```

指定された対角ベクトル（`dv`）と非対角ベクトル（`ev`）を使って、上（`uplo=:U`）または下（`uplo=:L`）二重対角行列を構築します。結果は`Bidiagonal`型で、専用の効率的な線形ソルバーを利用できます。また、[`convert(Array, _)`](@ref)（または簡潔な`Array(_)`）を使って通常の行列に変換することもできます。`ev`の長さは、`dv`の長さより1短くなければなりません。

# Examples

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

julia> Bu = Bidiagonal(dv, ev, :U) # ev is on the first superdiagonal
4×4 Bidiagonal{Int64, Vector{Int64}}:
 1  7  ⋅  ⋅
 ⋅  2  8  ⋅
 ⋅  ⋅  3  9
 ⋅  ⋅  ⋅  4

julia> Bl = Bidiagonal(dv, ev, :L) # ev is on the first subdiagonal
4×4 Bidiagonal{Int64, Vector{Int64}}:
 1  ⋅  ⋅  ⋅
 7  2  ⋅  ⋅
 ⋅  8  3  ⋅
 ⋅  ⋅  9  4
```
