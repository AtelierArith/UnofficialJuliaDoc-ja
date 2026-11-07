```julia
delete(a::NamedTuple, field::Symbol)
```

名前付きフィールドを削除して、`a`から新しい名前付きタプルを作成します。

```jldoctest
julia> Base.delete((a=1, b=2, c=3), :a)
(b = 2, c = 3)

julia> Base.delete((a=1, b=2, c=3), :b)
(a = 1, c = 3)
```
