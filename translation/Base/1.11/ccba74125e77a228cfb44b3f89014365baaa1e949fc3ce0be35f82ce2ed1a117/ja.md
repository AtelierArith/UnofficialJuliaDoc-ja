```
copymutable(a)
```

配列または反復可能なオブジェクト `a` の可変コピーを作成します。 `a::Array` の場合、これは `copy(a)` と同等ですが、他の配列タイプでは `similar(a)` のタイプによって異なる場合があります。 一般的な反復可能なオブジェクトの場合、これは `collect(a)` と同等です。

# 例

```jldoctest
julia> tup = (1, 2, 3)
(1, 2, 3)

julia> Base.copymutable(tup)
3-element Vector{Int64}:
 1
 2
 3
```
