```julia
randcycle!([rng=default_rng(),] A::AbstractArray{<:Integer})
```

`A` 内に、長さ `n = length(A)` のランダムな巡回置換を構成します。省略可能な `rng` 引数には乱数生成器を指定します。詳細は [Random Numbers](@ref) を参照してください。

ここで「巡回置換」とは、すべての要素が単一の巡回に含まれる置換を指します。`A` が空でない場合（`n > 0`）、可能な巡回置換は ``(n-1)!`` 通りあり、その中から一様にサンプリングされます。`A` が空の場合、`randcycle!` は変更を加えません。

[`randcycle`](@ref) は、この関数の新しいベクトルを割り当てるバリアントです。

!!! compat "Julia 1.13"
    Julia v1.13 より前は `A isa Array` が必要でした。


# Examples

```jldoctest
julia> randcycle!(Xoshiro(0), Vector{Int}(undef, 6))
6-element Vector{Int64}:
 5
 1
 4
 6
 3
 2
```
