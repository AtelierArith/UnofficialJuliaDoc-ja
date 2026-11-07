```julia
AbstractIrrational <: Real
```

厳密な無理数値を表す数値型です。他の数値との算術演算では、結果が適切な精度に自動的に丸められます。

サブタイプ `MyIrrational <: AbstractIrrational` は、少なくとも `==(::MyIrrational, ::MyIrrational)`、`hash(x::MyIrrational, h::UInt)`、`convert(::Type{F}, x::MyIrrational) where {F <: Union{BigFloat,Float32,Float64}}` を実装する必要があります。

サブタイプが有理数になる場合もある値を表すために使われる場合（たとえば、整数 `n` に対する `√n` を表す平方根型では、`n` が完全平方数なら有理数の結果になります）、さらに `isinteger`、`iszero`、`isone`、`==` も `Real` の値で実装する必要があります（これらはすべて、`AbstractIrrational` 型ではデフォルトで `false` になるため）。また、[`hash`](@ref) が対応する `Rational` と同じ値になるよう定義する必要があります。
