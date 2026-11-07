```julia
foldl(op, itr; [init])
```

[`reduce`](@ref)と同様ですが、左結合性が保証されています。指定した場合、キーワード引数`init`は1回だけ使用されます。一般に、空のコレクションで動作させるには`init`を指定する必要があります。

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
