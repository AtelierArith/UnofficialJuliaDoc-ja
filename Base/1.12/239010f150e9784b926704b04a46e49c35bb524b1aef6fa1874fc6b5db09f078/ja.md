```julia
Some{T}
```

`Union{Some{T}, Nothing}`内で値の欠如（[`nothing`](@ref)）と`nothing`値の存在（すなわち`Some(nothing)`）を区別するために使用されるラッパー型です。

`Some`オブジェクトによってラップされた値にアクセスするには[`something`](@ref)を使用してください。
