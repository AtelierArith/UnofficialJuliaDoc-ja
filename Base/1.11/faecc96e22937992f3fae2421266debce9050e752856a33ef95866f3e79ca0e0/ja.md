```
resize!(a::Vector, n::Integer) -> Vector
```

`a`を`n`要素を含むようにサイズ変更します。`n`が現在のコレクションの長さより小さい場合、最初の`n`要素が保持されます。`n`が大きい場合、新しい要素が初期化されることは保証されません。

# 例

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
