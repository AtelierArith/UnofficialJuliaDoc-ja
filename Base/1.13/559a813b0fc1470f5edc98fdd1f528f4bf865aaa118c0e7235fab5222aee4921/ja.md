```julia
Base.iskindtype(T)
```

`T`がkind、つまりJuliaの型の型であるかどうかを判定します。[`DataType`](@ref)、[`Union`](@ref)、[`UnionAll`](@ref)、または[`Core.TypeofBottom`](@ref)です。

型はJuliaの値であるため、すべてのkindは[concrete](@ref isconcretetype)です。
