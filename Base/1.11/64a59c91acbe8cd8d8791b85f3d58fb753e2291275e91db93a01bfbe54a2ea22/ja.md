```
foldl(op, itr; [init])
```

[`reduce`](@ref)と同様ですが、左結合性が保証されています。提供された場合、キーワード引数`init`は正確に1回使用されます。一般的に、空のコレクションで作業するには`init`を提供する必要があります。

他に[`mapfoldl`](@ref)、[`foldr`](@ref)、[`accumulate`](@ref)も参照してください。

# 例

```jldoctest
julia> foldl(=>, 1:4)
((1 => 2) => 3) => 4

julia> foldl(=>, 1:4; init=0)
(((0 => 1) => 2) => 3) => 4

julia> accumulate(=>, (1,2,3,4))
(1, 1 => 2, (1 => 2) => 3, ((1 => 2) => 3) => 4)
```
