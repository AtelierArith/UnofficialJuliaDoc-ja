```julia
foldr(op, itr; [init])
```

[`reduce`](@ref)と同様ですが、右結合性が保証されています。指定した場合、キーワード引数`init`は1回だけ使用されます。一般に、空のコレクションで動作させるには`init`を指定する必要があります。

# Examples

```jldoctest
julia> foldr(=>, 1:4)
1 => (2 => (3 => 4))

julia> foldr(=>, 1:4; init=0)
1 => (2 => (3 => (4 => 0)))
```
