```julia
ImmutableDict
```

`ImmutableDict`は、不変の連結リストとして実装された辞書です。個別の挿入を何度も行って構築する小さな辞書に最適です。値を削除することはできませんが、同じキーで新しい値を挿入すれば、既存の値を部分的に上書きして隠すことができます。

```julia
ImmutableDict(KV::Pair)
```

`ImmutableDict`に`key => value`のペアを新しく追加します。

  * この組み合わせがプロパティセットに含まれているかどうかを確認するには、`(key => value) in dict`を使用します。
  * 特定のキーに対応する最新の値を取得するには、`get(dict, key, default)`を使用します。
