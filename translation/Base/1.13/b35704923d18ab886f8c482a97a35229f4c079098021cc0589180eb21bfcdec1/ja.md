```julia
promote_typejoin(T, S)
```

`T`と`S`の両方を含む型を計算します。これは、両方の型の親型、または適切な場合は`Union`のいずれかです。該当しない場合は[`typejoin`](@ref)にフォールバックします。

代わりに[`promote`](@ref)、[`promote_type`](@ref)を参照してください。

# Examples

```jldoctest
julia> Base.promote_typejoin(Int, Float64)
Real

julia> Base.promote_type(Int, Float64)
Float64
```
