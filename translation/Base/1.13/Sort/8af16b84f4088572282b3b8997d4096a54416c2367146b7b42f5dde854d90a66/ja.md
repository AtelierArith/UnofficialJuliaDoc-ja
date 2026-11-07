```julia
sort!(v; alg::Base.Sort.Algorithm=Base.Sort.defalg(v), lt=isless, by=identity, rev::Bool=false, order::Base.Order.Ordering=Base.Order.Forward)
```

ベクトル `v` を並べ替えて、ソート済みにします。

デフォルトでは安定アルゴリズムが使われ、比較結果が等しい要素の順序は保持されます。特定のアルゴリズムは `alg` キーワードで選択できます（利用可能なアルゴリズムについては [Sorting Algorithms](@ref) を参照）。

まず要素を関数 `by` で変換し、その後、関数 `lt` または順序 `order` に従って比較します。最後に、`rev=true` の場合は結果の順序を逆にします（この場合も前方安定性は保たれ、比較結果が等しい要素の順序は逆転しません）。現在の実装では、要素ごとに一度だけ変換するのではなく、比較のたびに `by` 変換を適用します。

`lt` に `isless` 以外を指定し、同時に `order` に [`Base.Order.Forward`](@ref) または [`Base.Order.Reverse`](@ref) 以外を指定することはできません。それ以外のオプションは互いに独立しており、あらゆる組み合わせで併用できます。`order` に「by」変換を含めることもできます。その場合、この変換は `by` キーワードで定義した変換の後に適用されます。`order` の値について詳しくは、[Alternate Orderings](@ref) のドキュメントを参照してください。

2つの要素間の関係は、次のように定義されます（`rev=true` の場合は「小さい」と「大きい」が入れ替わります）。

  * `x` は、`lt(by(x), by(y))`（または `Base.Order.lt(order, by(x), by(y))`）が true を返す場合、`y` より小さいとします。
  * `x` は、`y` が `x` より小さい場合、`y` より大きいとします。
  * `x` と `y` は、どちらも相手より小さくない場合、同値とします（「比較不能」が「同値」の同義語として使われることもあります）。

`sort!` の結果は、すべての要素が直前の要素より大きいか、または同値であるという意味でソート済みです。

`lt` 関数は狭義弱順序を定義しなければなりません。つまり、次の性質を満たす必要があります。

  * 非反射性：`lt(x, x)` は常に `false` を返す。
  * 非対称性：`lt(x, y)` が `true` を返すなら、`lt(y, x)` は `false` を返す。
  * 推移性：`lt(x, y) && lt(y, z)` ならば `lt(x, z)`。
  * 同値関係の推移性：`!lt(x, y) && !lt(y, x)` と `!lt(y, z) && !lt(z, y)` がともに成り立つなら、`!lt(x, z) && !lt(z, x)` が成り立つ。言い換えると、`x` と `y` が同値で、`y` と `z` も同値なら、`x` と `z` も同値でなければなりません。

たとえば、`<` は `Int` の値に対する有効な `lt` 関数ですが、`≤` は非反射性に違反するため有効ではありません。`Float64` の値では、`<` も第4の条件に違反するため無効です。`1.0` と `NaN` は同値であり、`NaN` と `2.0` も同値ですが、`1.0` と `2.0` は同値ではありません。

関連項目：[`sort`](@ref)、[`sortperm`](@ref)、[`sortslices`](@ref)、[`partialsort!`](@ref)、[`partialsortperm`](@ref)、[`issorted`](@ref)、[`searchsorted`](@ref)、[`insorted`](@ref)、[`Base.Order.ord`](@ref)。

# Examples

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
