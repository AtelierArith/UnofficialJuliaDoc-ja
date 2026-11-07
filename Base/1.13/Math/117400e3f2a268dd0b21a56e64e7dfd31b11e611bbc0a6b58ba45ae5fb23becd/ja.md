```julia
hypot(x, y)
```

オーバーフローやアンダーフローを避けて、斜辺 ``\sqrt{|x|^2+|y|^2}`` を計算します。

このコードは、Carlos F. Borges による「An Improved Algorithm for `hypot(a,b)`」で説明されているアルゴリズムを実装したものです。論文は arXiv で公開されています。リンクはこちらです。   https://arxiv.org/abs/1904.09481

```julia
hypot(x...)
```

オーバーフローやアンダーフローを避けて、斜辺 ``\sqrt{\sum |x_i|^2}`` を計算します。

標準ライブラリの `norm` も参照してください。[`LinearAlgebra`](@ref man-linalg)

# Examples

```jldoctest; filter = r"Stacktrace:(\n \[[0-9]+\].*)*"
julia> a = Int64(10)^10;

julia> hypot(a, a)
1.4142135623730951e10

julia> √(a^2 + a^2) # a^2 overflows
ERROR: DomainError with -2.914184810805068e18:
sqrt was called with a negative real argument but will only return a complex result if called with a complex argument. Try sqrt(Complex(x)).
Stacktrace:
[...]

julia> hypot(3, 4im)
5.0

julia> hypot(-5.7)
5.7

julia> hypot(3, 4im, 12.0)
13.0

julia> using LinearAlgebra

julia> norm([a, a, a, a]) == hypot(a, a, a, a)
true
```
