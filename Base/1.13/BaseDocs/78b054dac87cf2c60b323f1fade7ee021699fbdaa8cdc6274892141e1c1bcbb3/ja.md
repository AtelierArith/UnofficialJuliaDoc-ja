```julia
Union{}
```

`Union{}`は、型の集合が空である[`Union`](@ref)であり、型システムにおける*最下位*の型です。つまり、各`T::Type`について、`Union{} <: T`です。部分型演算子のドキュメントも参照してください: [`<:`](@ref)。

そのため、`Union{}`も*空*/*要素を持たない*型であり、値を持ちません。つまり、各`x`について、`isa(x, Union{}) == false`です。

`Base.Bottom`はその別名として定義されており、`Union{}`の型は`Core.TypeofBottom`です。

# Examples

```jldoctest
julia> isa(nothing, Union{})
false

julia> Union{} <: Int
true

julia> typeof(Union{}) === Core.TypeofBottom
true

julia> isa(Union{}, Union)
false
```
