```julia
hypot(x, y)
```

オーバーフローとアンダーフローを避けて、斜辺 $\sqrt{|x|^2+|y|^2}$ を計算します。

このコードは、Carlos F. Borgesによる「`hypot(a,b)`の改善されたアルゴリズム」に記載されたアルゴリズムの実装です。この記事は、リンク https://arxiv.org/abs/1904.09481 でarXivにオンラインで入手できます。

```julia
hypot(x...)
```

オーバーフローとアンダーフローを避けて、斜辺 $\sqrt{\sum |x_i|^2}$ を計算します。

[`LinearAlgebra`](@ref man-linalg) 標準ライブラリの `norm` も参照してください。

# 例

```jldoctest; filter = r"Stacktrace:(\n \[[0-9]+\].*)*"
julia> a = Int64(10)^10;

julia> hypot(a, a)
1.4142135623730951e10

julia> √(a^2 + a^2) # a^2 はオーバーフローします
ERROR: DomainError with -2.914184810805068e18:
sqrtは負の実引数で呼び出されましたが、複素引数で呼び出された場合にのみ複素結果を返します。sqrt(Complex(x))を試してください。
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
