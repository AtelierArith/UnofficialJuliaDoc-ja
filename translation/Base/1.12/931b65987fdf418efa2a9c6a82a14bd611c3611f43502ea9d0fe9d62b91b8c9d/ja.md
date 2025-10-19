```julia
something(x...)
```

引数の中で [`nothing`](@ref) と等しくない最初の値を返します。もしそのような値がなければ、エラーをスローします。型 [`Some`](@ref) の引数はアンラップされます。

関連項目としては [`coalesce`](@ref)、[`skipmissing`](@ref)、[`@something`](@ref) があります。

# 例

```jldoctest
julia> something(nothing, 1)
1

julia> something(Some(1), nothing)
1

julia> something(Some(nothing), 2) === nothing
true

julia> something(missing, nothing)
missing

julia> something(nothing, nothing)
ERROR: ArgumentError: No value arguments present
```
