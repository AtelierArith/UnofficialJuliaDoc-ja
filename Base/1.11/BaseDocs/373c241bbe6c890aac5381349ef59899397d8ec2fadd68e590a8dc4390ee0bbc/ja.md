```
Matrix{T}(nothing, m, n)
```

サイズ `m`×`n` の [`Matrix{T}`](@ref) を、[`nothing`](@ref) エントリで初期化して構築します。要素型 `T` はこれらの値を保持できる必要があります。すなわち、`Nothing <: T` です。

# 例

```jldoctest
julia> Matrix{Union{Nothing, String}}(nothing, 2, 3)
2×3 Matrix{Union{Nothing, String}}:
 nothing  nothing  nothing
 nothing  nothing  nothing
```
