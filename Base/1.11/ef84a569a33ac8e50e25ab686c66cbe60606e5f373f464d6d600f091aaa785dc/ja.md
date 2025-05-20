```
nameof(m::Module) -> Symbol
```

`Module`の名前を[`Symbol`](@ref)として取得します。

# 例

```jldoctest
julia> nameof(Base.Broadcast)
:Broadcast
```
