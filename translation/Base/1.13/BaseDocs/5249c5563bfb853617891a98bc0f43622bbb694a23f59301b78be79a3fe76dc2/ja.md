```julia
.
```

ドット演算子は、オブジェクトのフィールドやプロパティへのアクセス、およびモジュール内で定義された変数へのアクセスに使われます。

一般に、`a.b` は `getproperty(a, :b)` を呼び出します（[`getproperty`](@ref Base.getproperty) を参照）。

# Examples

```jldoctest
julia> z = 1 + 2im; z.im
2

julia> Iterators.product
product (generic function with 1 method)
```
