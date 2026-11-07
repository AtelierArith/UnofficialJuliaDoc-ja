```julia
ismutable(v)::Bool
```

値 `v` が可変である場合に限り、`true` を返します。不変性については [Mutable Composite Types](@ref) を参照してください。この関数は値を対象とするため、`DataType` を渡すと、その型の値は可変であると判定されます。

!!! note
    技術的な理由により、`ismutable` は、`String` や `Symbol` など、一部の特殊な型の値について、許容される方法では変更できないにもかかわらず、`true` を返します。


[`isbits`](@ref)、[`isstructtype`](@ref) も参照してください。

# Examples

```jldoctest
julia> ismutable(1)
false

julia> ismutable([1,2])
true
```

!!! compat "Julia 1.5"
    この関数を使用するには、Julia 1.5 以降が必要です。

