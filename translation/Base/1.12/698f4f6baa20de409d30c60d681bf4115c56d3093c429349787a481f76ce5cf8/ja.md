```julia
promote(xs...)
```

すべての引数を共通の型に変換し、それらをすべて（タプルとして）返します。引数を変換できない場合は、エラーが発生します。

参照: [`promote_type`](@ref), [`promote_rule`](@ref).

# 例

```jldoctest
julia> promote(Int8(1), Float16(4.5), Float32(4.1))
(1.0f0, 4.5f0, 4.1f0)

julia> promote_type(Int8, Float16, Float32)
Float32

julia> reduce(Base.promote_typejoin, (Int8, Float16, Float32))
Real

julia> promote(1, "x")
ERROR: promotion of types Int64 and String failed to change any arguments
[...]

julia> promote_type(Int, String)
Any
```
