```julia
structdiff(a::NamedTuple, b::Union{NamedTuple,Type{NamedTuple}})
```

名前付きタプル `a` のコピーを作成します。ただし、`b` に存在するフィールドは除外されます。`b` には、名前付きタプルまたは `NamedTuple{field_names}` 形式の型を指定できます。
