```julia
rand!([rng=default_rng()], A, [S=eltype(A)])
```

配列 `A` にランダムな値を設定します。`S` が指定されている場合（`S` には型またはコレクションを指定できます。詳細は [`rand`](@ref) を参照）、値は `S` からランダムに選ばれます。これは、新しい配列を割り当てずに `copyto!(A, rand(rng, S, size(A)))` を実行するのと同等です。

# Examples

```jldoctest
julia> rand!(Xoshiro(123), zeros(5))
5-element Vector{Float64}:
 0.521213795535383
 0.5868067574533484
 0.8908786980927811
 0.19090669902576285
 0.5256623915420473
```
