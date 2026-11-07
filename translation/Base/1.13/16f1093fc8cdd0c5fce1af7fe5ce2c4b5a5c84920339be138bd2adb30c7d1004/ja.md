```julia
copymutable(a)
```

配列または反復可能オブジェクト `a` の変更可能なコピーを作成します。`a::Array` の場合、これは `copy(a)` と同等ですが、その他の配列型では `similar(a)` の型によって異なる場合があります。一般的な反復可能オブジェクトの場合、これは `collect(a)` と同等です。

# Examples

```jldoctest
julia> tup = (1, 2, 3)
(1, 2, 3)

julia> Base.copymutable(tup)
3-element Vector{Int64}:
 1
 2
 3
```
