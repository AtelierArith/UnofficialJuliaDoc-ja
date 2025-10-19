```julia
copyto!(dest::AbstractMatrix, src::UniformScaling)
```

[`UniformScaling`](@ref) を行列にコピーします。

!!! compat "Julia 1.1"
    Julia 1.0 ではこのメソッドは正方行列の宛先のみをサポートしていました。Julia 1.1 では長方形の行列のサポートが追加されました。

