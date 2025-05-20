```
AbstractIrrational <: Real
```

正確な無理数値を表す数値型であり、他の数値量との算術演算において自動的に正しい精度に丸められます。

サブタイプ `MyIrrational <: AbstractIrrational` は、少なくとも `==(::MyIrrational, ::MyIrrational)`、`hash(x::MyIrrational, h::UInt)`、および `convert(::Type{F}, x::MyIrrational) where {F <: Union{BigFloat,Float32,Float64}}` を実装する必要があります。

サブタイプが、時折有理数を表す値を表すために使用される場合（例えば、整数 `n` に対して `√n` を表す平方根型は、`n` が完全平方数であるときに有理数の結果を返します）、その場合は `isinteger`、`iszero`、`isone`、および `Real` 値との `==` を実装する必要があります（これらはすべて `AbstractIrrational` 型に対してデフォルトで `false` になります）。さらに、[`hash`](@ref) を対応する `Rational` のものと等しく定義する必要があります。
