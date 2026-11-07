```julia
resize!(a::Vector, n::Integer) -> a
```

`a`のサイズを変更し、`n`個の要素を格納できるようにします。`n`が現在のコレクションの長さより小さい場合、先頭の`n`個の要素が保持されます。`n`が大きい場合、新しい要素が初期化される保証はありません。

# Examples

```jldoctest
julia> resize!([6, 5, 4, 3, 2, 1], 3)
3-element Vector{Int64}:
 6
 5
 4

julia> a = resize!([6, 5, 4, 3, 2, 1], 8);

julia> length(a)
8

julia> a[1:6]
6-element Vector{Int64}:
 6
 5
 4
 3
 2
 1
```
