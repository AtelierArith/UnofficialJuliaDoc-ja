```julia
randcycle([rng=default_rng(),] n::Integer)
```

長さ `n` のランダムな循環置換を構築します。オプションの `rng` 引数は乱数生成器を指定します。結果の要素型は `n` の型と同じです。

ここで「循環置換」とは、すべての要素が単一のサイクル内にあることを意味します。 `n > 0` の場合、可能な循環置換は $(n-1)!$ 個あり、均等にサンプリングされます。 `n == 0` の場合、`randcycle` は空のベクターを返します。

[`randcycle!`](@ref) はこの関数のインプレースバリアントです。

!!! compat "Julia 1.1"
    Julia 1.1 以降では、`randcycle` は `eltype(v) == typeof(n)` のベクター `v` を返しますが、Julia 1.0 では `eltype(v) == Int` です。


# 例

```jldoctest
julia> randcycle(Xoshiro(123), 6)
6-element Vector{Int64}:
 5
 4
 2
 6
 3
 1
```
