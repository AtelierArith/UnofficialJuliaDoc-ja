```julia
empty(v::AbstractVector, [eltype])
```

`v`に似た空のベクトルを作成します。必要に応じて`eltype`を変更できます。

関連項目: [`empty!`](@ref)、[`isempty`](@ref)、[`isassigned`](@ref)。

# Examples

```jldoctest
julia> empty([1.0, 2.0, 3.0])
Float64[]

julia> empty([1.0, 2.0, 3.0], String)
String[]
```
