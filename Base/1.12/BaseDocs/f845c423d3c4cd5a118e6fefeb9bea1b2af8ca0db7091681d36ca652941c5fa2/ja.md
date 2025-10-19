```julia
.
```

ドット演算子は、オブジェクトのフィールドやプロパティにアクセスしたり、モジュール内で定義された変数にアクセスするために使用されます。

一般に、`a.b` は `getproperty(a, :b)` を呼び出します（[`getproperty`](@ref Base.getproperty)を参照）。

# 例

```jldoctest
julia> z = 1 + 2im; z.im
2

julia> Iterators.product
product (generic function with 1 method)
```
