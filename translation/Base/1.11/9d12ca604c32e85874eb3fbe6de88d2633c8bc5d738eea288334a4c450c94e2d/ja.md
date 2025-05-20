```
PersistentDict
```

`PersistentDict` はハッシュ配列マップトライとして実装された辞書で、永続性が必要な状況に最適です。各操作は前の辞書とは別の新しい辞書を返しますが、基盤となる実装は空間効率が良く、複数の別々の辞書間でストレージを共有することがあります。

!!! note
    IdDictのように振る舞います。


```julia
PersistentDict(KV::Pair)
```

# 例

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
