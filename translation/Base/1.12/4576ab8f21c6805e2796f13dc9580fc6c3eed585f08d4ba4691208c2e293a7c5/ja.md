```julia
empty(v::AbstractVector, [eltype])
```

`v`に似た空のベクトルを作成し、オプションで`eltype`を変更します。

参照: [`empty!`](@ref), [`isempty`](@ref), [`isassigned`](@ref).

# 例

```jldoctest
julia> empty([1.0, 2.0, 3.0])
Float64[]

julia> empty([1.0, 2.0, 3.0], String)
String[]
```
