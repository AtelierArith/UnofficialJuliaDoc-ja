```julia
something(x...)
```

引数のうち、[`nothing`](@ref) と等しくない最初の値を返します。該当する値がない場合は、エラーをスローします。[`Some`](@ref) 型の引数はアンラップされます。

関連項目: [`coalesce`](@ref)、[`skipmissing`](@ref)、[`@something`](@ref)。

# Examples

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
