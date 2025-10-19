```julia
Matrix{T}(missing, m, n)
```

サイズ `m`×`n` の [`Matrix{T}`](@ref) を作成し、[`missing`](@ref) エントリで初期化します。要素型 `T` はこれらの値を保持できる必要があります。すなわち、`Missing <: T` です。

# 例

```jldoctest
julia> Matrix{Union{Missing, String}}(missing, 2, 3)
2×3 Matrix{Union{Missing, String}}:
 missing  missing  missing
 missing  missing  missing
```
