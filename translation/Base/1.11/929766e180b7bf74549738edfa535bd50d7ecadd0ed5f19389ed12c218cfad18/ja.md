```
copyto!(dest::AbstractArray, src) -> dest
```

コレクション `src` から配列 `dest` にすべての要素をコピーします。`dest` の長さは `src` の長さ `n` 以上でなければなりません。`dest` の最初の `n` 要素は上書きされ、他の要素はそのまま残ります。

関連情報としては [`copy!`](@ref Base.copy!)、[`copy`](@ref) があります。

!!! warning
    変更された引数が他の引数とメモリを共有している場合、動作が予期しないものになることがあります。


# 例

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
