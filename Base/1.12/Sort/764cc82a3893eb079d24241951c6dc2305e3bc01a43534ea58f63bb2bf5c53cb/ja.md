```julia
sort!(v; alg::Base.Sort.Algorithm=Base.Sort.defalg(v), lt=isless, by=identity, rev::Bool=false, order::Base.Order.Ordering=Base.Order.Forward)
```

ベクター `v` をその場でソートします。デフォルトでは安定したアルゴリズムが使用されます：等しいと比較される要素の順序は保持されます。特定のアルゴリズムは `alg` キーワードを介して選択できます（利用可能なアルゴリズムについては [Sorting Algorithms](@ref) を参照してください）。

要素は最初に `by` 関数で変換され、その後 `lt` 関数または `order` に従って比較されます。最後に、`rev=true` の場合は結果の順序が逆転されます（これにより前方の安定性が保持されます：等しいと比較される要素は逆転されません）。現在の実装では、各比較の前に `by` 変換が適用され、要素ごとに一度だけではありません。

`isless` 以外の `lt` を `Base.Order.Forward` または [`Base.Order.Reverse`](@ref) 以外の `order` と一緒に渡すことは許可されていません。それ以外はすべてのオプションは独立しており、すべての可能な組み合わせで一緒に使用できます。`order` は "by" 変換を含むこともでき、その場合は `by` キーワードで定義された後に適用されます。`order` 値に関する詳細は [Alternate Orderings](@ref) のドキュメントを参照してください。

2つの要素間の関係は次のように定義されます（`rev=true` の場合は「小さい」と「大きい」が交換されます）：

  * `x` は `y` より小さい場合、`lt(by(x), by(y))`（または `Base.Order.lt(order, by(x), by(y))`）が真を返します。
  * `x` は `y` より大きい場合、`y` が `x` より小さいです。
  * `x` と `y` は互いに小さくない場合、等価です（「比較不能」は「等価」の同義語として時々使用されます）。

`sort!` の結果は、すべての要素が前の要素より大きいか等価であるという意味でソートされています。

`lt` 関数は厳密な弱順序を定義する必要があります。つまり、次の条件を満たさなければなりません：

  * 非反射的：`lt(x, x)` は常に `false` を返す。
  * 非対称的：`lt(x, y)` が真を返す場合、`lt(y, x)` は偽を返す。
  * 推移的：`lt(x, y) && lt(y, z)` は `lt(x, z)` を含意する。
  * 等価における推移的：`!lt(x, y) && !lt(y, x)` と `!lt(y, z) && !lt(z, y)` が一緒にある場合、`!lt(x, z) && !lt(z, x)` を含意する。言い換えれば：`x` と `y` が等価であり、`y` と `z` が等価である場合、`x` と `z` も等価でなければなりません。

例えば、`<` は `Int` 値に対する有効な `lt` 関数ですが、`≤` はそうではありません：それは非反射性に違反します。`Float64` 値の場合、`<` でさえ無効です。なぜなら、4番目の条件に違反するからです：`1.0` と `NaN` は等価であり、`NaN` と `2.0` も等価ですが、`1.0` と `2.0` は等価ではありません。

他にも [`sort`](@ref)、[`sortperm`](@ref)、[`sortslices`](@ref)、[`partialsort!`](@ref)、[`partialsortperm`](@ref)、[`issorted`](@ref)、[`searchsorted`](@ref)、[`insorted`](@ref)、[`Base.Order.ord`](@ref) を参照してください。

# 例

```jldoctest
julia> v = [3, 1, 2]; sort!(v); v
3-element Vector{Int64}:
 1
 2
 3

julia> v = [3, 1, 2]; sort!(v, rev = true); v
3-element Vector{Int64}:
 3
 2
 1

julia> v = [(1, "c"), (3, "a"), (2, "b")]; sort!(v, by = x -> x[1]); v
3-element Vector{Tuple{Int64, String}}:
 (1, "c")
 (2, "b")
 (3, "a")

julia> v = [(1, "c"), (3, "a"), (2, "b")]; sort!(v, by = x -> x[2]); v
3-element Vector{Tuple{Int64, String}}:
 (3, "a")
 (2, "b")
 (1, "c")

julia> sort(0:3, by=x->x-2, order=Base.Order.By(abs))
4-element Vector{Int64}:
 2
 1
 3
 0

julia> sort(0:3, by=x->x-2, order=Base.Order.By(abs)) == sort(0:3, by=x->abs(x-2))
true

julia> sort([2, NaN, 1, NaN, 3]) # correct sort with default lt=isless
5-element Vector{Float64}:
   1.0
   2.0
   3.0
 NaN
 NaN

julia> sort([2, NaN, 1, NaN, 3], lt=<) # wrong sort due to invalid lt. This behavior is undefined.
5-element Vector{Float64}:
   2.0
 NaN
   1.0
 NaN
   3.0
```
