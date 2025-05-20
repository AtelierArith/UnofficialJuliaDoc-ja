```
first(coll)
```

イテラブルコレクションの最初の要素を取得します。空であっても[`AbstractRange`](@ref)の開始点を返します。

関連情報: [`only`](@ref), [`firstindex`](@ref), [`last`](@ref).

# 例

```jldoctest
julia> first(2:2:10)
2

julia> first([1; 2; 3; 4])
1
```
