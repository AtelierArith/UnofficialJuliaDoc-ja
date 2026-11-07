```julia
Some{T}
```

`Union{Some{T}, Nothing}`で、値が存在しない状態（[`nothing`](@ref)）と、`nothing`の値が存在する状態（つまり`Some(nothing)`）を区別するために使われるラッパー型です。

`Some`オブジェクトにラップされた値にアクセスするには、[`something`](@ref)を使います。
