```julia
foldl(op, itr; [init])
```

[`reduce`](@ref)と同様ですが、左結合性が保証されています。キーワード引数`init`を指定した場合、これはちょうど1回使用されます。一般に、空のコレクションを扱うには`init`を指定する必要があります。

関連項目：[`mapfoldl`](@ref)、[`foldr`](@ref)、[`accumulate`](@ref)。

# Examples

```jldoctest
julia> foldl(=>, 1:4)
((1 => 2) => 3) => 4

julia> foldl(=>, 1:4; init=0)
(((0 => 1) => 2) => 3) => 4

julia> accumulate(=>, (1,2,3,4))
(1, 1 => 2, (1 => 2) => 3, ((1 => 2) => 3) => 4)
```
