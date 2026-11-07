```julia
PersistentDict
```

`PersistentDict` は、ハッシュ配列マップトライとして実装された辞書です。永続性が必要な場合に最適で、各操作は以前の辞書とは別の新しい辞書を返します。一方、内部実装はメモリ効率に優れており、複数の独立した辞書間でストレージを共有できる場合があります。

!!! note
    IdDict と同じように動作します。


```julia
PersistentDict(KV::Pair)
```

# Examples

```jldoctest
julia> dict = Base.PersistentDict(:a=>1)
Base.PersistentDict{Symbol, Int64} with 1 entry:
  :a => 1

julia> dict2 = Base.delete(dict, :a)
Base.PersistentDict{Symbol, Int64}()

julia> dict3 = Base.PersistentDict(dict, :a=>2)
Base.PersistentDict{Symbol, Int64} with 1 entry:
  :a => 2
```
