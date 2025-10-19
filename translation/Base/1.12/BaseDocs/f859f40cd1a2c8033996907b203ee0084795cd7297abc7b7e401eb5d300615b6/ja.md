```julia
Integer <: Real
```

すべての整数の抽象スーパタイプ（例：[`Signed`](@ref)、[`Unsigned`](@ref)、および[`Bool`](@ref)）。

他に[`isinteger`](@ref)、[`trunc`](@ref)、[`div`](@ref)も参照してください。

# 例

```julia
julia> 42 isa Integer
true

julia> 1.0 isa Integer
false

julia> isinteger(1.0)
true
```
