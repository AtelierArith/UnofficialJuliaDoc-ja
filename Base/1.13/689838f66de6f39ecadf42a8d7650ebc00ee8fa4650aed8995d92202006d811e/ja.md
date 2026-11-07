```julia
copyto!(dest::AbstractArray, src) -> dest
```

コレクション `src` のすべての要素を配列 `dest` にコピーします。配列の長さは、`src` の長さ `n` 以上でなければなりません。`dest` の先頭 `n` 個の要素は上書きされ、それ以外の要素は変更されません。

関連項目: [`copy!`](@ref Base.copy!)、[`copy`](@ref)。

!!! warning
    変更される引数がほかの引数とメモリを共有している場合、予期しない動作になることがあります。


# Examples

```jldoctest
julia> x = [1., 0., 3., 0., 5.];

julia> y = zeros(7);

julia> copyto!(y, x);

julia> y
7-element Vector{Float64}:
 1.0
 0.0
 3.0
 0.0
 5.0
 0.0
 0.0
```
