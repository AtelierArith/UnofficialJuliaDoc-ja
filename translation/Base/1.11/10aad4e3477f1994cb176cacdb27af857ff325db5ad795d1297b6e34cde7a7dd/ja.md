```
something(x...)
```

引数の中で [`nothing`](@ref) と等しくない最初の値を返します。もし存在しない場合はエラーをスローします。型 [`Some`](@ref) の引数はアンラップされます。

関連情報として [`coalesce`](@ref)、[`skipmissing`](@ref)、[`@something`](@ref) も参照してください。

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
