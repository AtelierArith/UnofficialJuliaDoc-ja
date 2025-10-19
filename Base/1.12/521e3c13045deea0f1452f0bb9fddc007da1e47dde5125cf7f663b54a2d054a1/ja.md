```julia
promote_typejoin(T, S)
```

`T` と `S` の両方を含む型を計算します。これは、両方の型の親であるか、適切であれば `Union` である可能性があります。 [`typejoin`](@ref) にフォールバックします。

代わりに [`promote`](@ref)、[`promote_type`](@ref) を参照してください。

# 例

```jldoctest
julia> Base.promote_typejoin(Int, Float64)
Real

julia> Base.promote_type(Int, Float64)
Float64
```
