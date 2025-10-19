```julia
Union{}
```

`Union{}`、型の空の [`Union`](@ref) は、型システムの *ボトム* 型です。つまり、各 `T::Type` に対して、`Union{} <: T` です。また、部分型演算子のドキュメントも参照してください: [`<:`](@ref)。

そのため、`Union{}` は *空*/*居住していない* 型でもあり、値を持たないことを意味します。つまり、各 `x` に対して、`isa(x, Union{}) == false` です。

`Base.Bottom` はそのエイリアスとして定義されており、`Union{}` の型は `Core.TypeofBottom` です。

# 例

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
