```julia
parentmodule(m::Module)::Module
```

モジュールを包含する `Module` を取得します。`Main` の親はそれ自身です。

関連項目: [`names`](@ref)、[`nameof`](@ref)、[`fullname`](@ref)、[`@__MODULE__`](@ref)。

# Examples

```jldoctest
julia> parentmodule(Main)
Main

julia> parentmodule(Base.Broadcast)
Base
```
