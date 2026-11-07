```julia
is_identity_free_argtype(argtype)::Bool
```

`argtype`オブジェクトが、アイデンティティフリーである場合（この型、またはそのフィールドをたどって到達できる型が、いずれも内容に基づかないアイデンティティを持たない場合。詳細は`Base.isidentityfree`を参照）、`true`を返します。このクエリは、特に`adjust_effects`向けに設計されています。戻り値の型が`is_identity_free_argtype`の場合、解析対象の呼び出しグラフ内での可変オブジェクトの割り当てによって汚染された`:consistent`のエフェクトプロパティを絞り込み、割り当てられた可変オブジェクトが決して返されないことを保証します。
