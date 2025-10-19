```julia
dot(x, y)
x ⋅ y
```

2つのベクトル間のドット積を計算します。複素ベクトルの場合、最初のベクトルは共役されます。

`dot`は、要素に対して`dot`が定義されている限り、任意の次元の配列を含む任意の反復可能なオブジェクトでも機能します。

`dot`は、引数が等しい長さであるという追加の制約があることを除いて、`sum(dot(vx,vy) for (vx,vy) in zip(x, y))`と意味的に同等です。

`x ⋅ y`（ここで`⋅`はREPLで`\cdot`をタブ補完することで入力できます）は`dot(x, y)`の同義語です。

# 例

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
