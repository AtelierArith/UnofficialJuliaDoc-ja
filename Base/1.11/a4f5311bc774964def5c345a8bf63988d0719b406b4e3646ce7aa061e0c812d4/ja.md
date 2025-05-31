```
Generator(f, iter)
```

関数 `f` とイテレータ `iter` が与えられたとき、`iter` の要素に適用された `f` の値を生成するイテレータを構築します。構文 `f(x) for x in iter` は、このタイプのインスタンスを構築するための構文です。

```jldoctest
julia> g = (abs2(x) for x in 1:5);

julia> for x in g
           println(x)
       end
1
4
9
16
25

julia> collect(g)
5-element Vector{Int64}:
  1
  4
  9
 16
 25
```
