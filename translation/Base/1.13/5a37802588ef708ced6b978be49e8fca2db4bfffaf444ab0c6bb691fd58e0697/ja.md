```julia
isapprox(x, y; atol::Real=0, rtol::Real=atol>0 ? 0 : √eps, nans::Bool=false[, norm::Function])
```

近似的な等値比較。2つの数値は、相対距離 *または* 絶対距離が許容範囲内であれば等しいと判定されます。`isapprox` は、`norm(x-y) <= max(atol, rtol*max(norm(x), norm(y)))` の場合に `true` を返します。デフォルトの `atol`（絶対許容誤差）はゼロで、デフォルトの `rtol`（相対許容誤差）は `x` と `y` の型によって決まります。キーワード引数 `nans` は、NaN 値を等しいとみなすかどうかを指定します（デフォルトは false）。

実数または複素数の浮動小数点値の場合、`atol > 0` が指定されていなければ、`rtol` は、`x` または `y` の型のうち、より大きい（精度の低い）方の [`eps`](@ref) の平方根がデフォルトになります。これは、有効桁数のおよそ半分が一致することを要求するのに相当します。一方、整数の引数の場合や、`atol > 0` が指定されている場合などは、`rtol` のデフォルトはゼロです。

キーワード `norm` は、数値の `(x,y)` ではデフォルトで `abs` に、配列では `LinearAlgebra.norm` になります（別の `norm` を選ぶと便利な場合もあります）。`x` と `y` が配列で、`norm(x-y)` が有限でない場合（つまり、`±Inf` または `NaN` の場合）、比較は、`x` と `y` のすべての要素が成分ごとに近似的に等しいかどうかを調べる方法に切り替わります。

二項演算子 `≈` は、デフォルトの引数を指定した `isapprox` と同等であり、`x ≉ y` は `!isapprox(x,y)` と同等です。

なお、`x ≈ 0`（つまり、デフォルトの許容誤差でゼロと比較すること）は、デフォルトの `atol` が `0` であるため、`x == 0` と同等です。このような場合は、適切な `atol` を指定する（または `norm(x) ≤ atol` を使う）か、コードの書き方を変えてください（たとえば、`x - y ≈ 0` ではなく `x ≈ y` を使います）。問題全体のスケーリング（「単位」）によって異なるため、ゼロでない `atol` を自動的に選ぶことはできません。たとえば、`x - y ≈ 0` では、`x` がメートル単位の [radius of the Earth](https://en.wikipedia.org/wiki/Earth_radius) なら、`atol=1e-9` は途方もなく小さい許容誤差ですが、`x` がメートル単位の [radius of a Hydrogen atom](https://en.wikipedia.org/wiki/Bohr_radius) なら、途方もなく大きい許容誤差になります。

!!! compat "Julia 1.6"
    数値（配列以外）の引数を比較する際に `norm` キーワード引数を渡すには、Julia 1.6 以降が必要です。


# Examples

```jldoctest
julia> isapprox(0.1, 0.15; atol=0.05)
true

julia> isapprox(0.1, 0.15; rtol=0.34)
true

julia> isapprox(0.1, 0.15; rtol=0.33)
false

julia> 0.1 + 1e-10 ≈ 0.1
true

julia> 1e-10 ≈ 0
false

julia> isapprox(1e-10, 0, atol=1e-8)
true

julia> isapprox([10.0^9, 1.0], [10.0^9, 2.0]) # using `norm`
true
```
