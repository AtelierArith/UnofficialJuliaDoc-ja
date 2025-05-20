```
parentmodule(m::Module) -> Module
```

モジュールの囲む `Module` を取得します。`Main` は自分自身の親です。

関連情報: [`names`](@ref), [`nameof`](@ref), [`fullname`](@ref), [`@__MODULE__`](@ref).

# 例

```jldoctest
julia> parentmodule(Main)
Main

julia> parentmodule(Base.Broadcast)
Base
```
