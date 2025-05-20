```
hypot(x, y)
```

直角三角形の斜辺を計算します $\sqrt{|x|^2+|y|^2}$ オーバーフローとアンダーフローを避けながら。

このコードは、Carlos F. Borgesによる「`hypot(a,b)`の改善されたアルゴリズム」に記載されたアルゴリズムの実装です。この記事は、次のリンクでarXivでオンラインで入手できます: https://arxiv.org/abs/1904.09481

```
hypot(x...)
```

直角三角形の斜辺を計算します $\sqrt{\sum |x_i|^2}$ オーバーフローとアンダーフローを避けながら。

標準ライブラリの[`LinearAlgebra`](@ref man-linalg)にある`norm`も参照してください。

# 例

```jldoctest; filter = r"Stacktrace:(\n \[[0-9]+\].*)*"
julia> a = Int64(10)^10;

julia> hypot(a, a)
1.4142135623730951e10

julia> √(a^2 + a^2) # a^2はオーバーフローします
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
