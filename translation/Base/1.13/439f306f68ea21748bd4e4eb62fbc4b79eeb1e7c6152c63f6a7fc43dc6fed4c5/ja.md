```julia
parentmodule(m::Module)::Module
```

モジュールを囲む`Module`を取得します。`Main`は、それ自体が親です。

関連項目: [`names`](@ref)、[`nameof`](@ref)、[`fullname`](@ref)、[`@__MODULE__`](@ref)。

# Examples

```jldoctest
julia> parentmodule(Main)
Main

julia> parentmodule(Base.Broadcast)
Base
```
