```
isapprox(x, y; atol::Real=0, rtol::Real=atol>0 ? 0 : √eps, nans::Bool=false[, norm::Function])
```

不正確な等価比較。2つの数は、相対距離*または*絶対距離が許容範囲内である場合に等しいと比較されます：`isapprox`は`norm(x-y) <= max(atol, rtol*max(norm(x), norm(y)))`が成り立つ場合に`true`を返します。デフォルトの`atol`（絶対許容誤差）はゼロで、デフォルトの`rtol`（相対許容誤差）は`x`と`y`の型に依存します。キーワード引数`nans`は、NaN値が等しいと見なされるかどうかを決定します（デフォルトはfalseです）。

実数または複素数の浮動小数点値の場合、`atol > 0`が指定されていない場合、`rtol`は`x`または`y`の型の[`eps`](@ref)の平方根にデフォルト設定され、どちらか大きい方（最も精度が低い）になります。これは、約半分の有効桁の等価性を要求することに相当します。それ以外の場合、例えば整数引数の場合や`atol > 0`が指定されている場合、`rtol`はゼロにデフォルト設定されます。

`norm`キーワードは、数値の`(x,y)`の場合は`abs`に、配列の場合は`LinearAlgebra.norm`にデフォルト設定されます（代替の`norm`の選択が時々便利です）。`x`と`y`が配列の場合、`norm(x-y)`が有限でない場合（すなわち`±Inf`または`NaN`）、比較は`x`と`y`のすべての要素が成分ごとにほぼ等しいかどうかを確認することに戻ります。

二項演算子`≈`は、デフォルトの引数を持つ`isapprox`と同等であり、`x ≉ y`は`!isapprox(x,y)`と同等です。

`x ≈ 0`（すなわち、デフォルトの許容誤差でゼロと比較すること）は、デフォルトの`atol`が`0`であるため、`x == 0`と同等です。このような場合、適切な`atol`を指定するか（または`norm(x) ≤ atol`を使用するか）、コードを再配置する必要があります（例えば、`x - y ≈ 0`ではなく`x ≈ y`を使用する）。非ゼロの`atol`を自動的に選択することはできません。なぜなら、それは問題の全体的なスケーリング（「単位」）に依存するからです：例えば、`x - y ≈ 0`において、`atol=1e-9`は`x`がメートル単位の[地球の半径](https://en.wikipedia.org/wiki/Earth_radius)である場合には非常に小さな許容誤差ですが、`x`がメートル単位の[水素原子の半径](https://en.wikipedia.org/wiki/Bohr_radius)である場合には非常に大きな許容誤差です。

!!! compat "Julia 1.6"
    数値（非配列）引数を比較する際に`norm`キーワード引数を渡すには、Julia 1.6以降が必要です。


# 例

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
