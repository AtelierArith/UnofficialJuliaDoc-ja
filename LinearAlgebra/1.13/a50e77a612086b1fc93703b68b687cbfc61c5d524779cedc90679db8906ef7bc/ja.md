```julia
dot(x, y)
x ⋅ y
```

2つのベクトルの内積を計算します。複素ベクトルの場合は、最初のベクトルを共役します。

`dot` は、要素に対して `dot` が定義されていれば、任意の次元の配列を含む、任意の反復可能オブジェクトにも使用できます。

`dot` は意味的には `sum(dot(vx,vy) for (vx,vy) in zip(x, y))` と同等ですが、引数の長さが等しくなければならないという制約が追加されています。

`x ⋅ y`（REPL で `\cdot` をタブ補完すると `⋅` と入力できます）は、`dot(x, y)` の同義語です。

# Examples

```jldoctest
julia> dot([1; 1], [2; 3])
5

julia> dot([im; im], [1; 1])
0 - 2im

julia> dot(1:5, 2:6)
70

julia> x = fill(2., (5,5));

julia> y = fill(3., (5,5));

julia> dot(x, y)
150.0
```
