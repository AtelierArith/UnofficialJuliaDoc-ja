```julia
copyto!(dest::AbstractMatrix, src::UniformScaling)
```

[`UniformScaling`](@ref)を行列にコピーします。

!!! compat "Julia 1.1"
    Julia 1.0では、このメソッドは正方形のコピー先行列のみをサポートしていました。Julia 1.1では、長方形の行列もサポートするようになりました。

