```julia
is_identity_free_argtype(argtype)::Bool
```

`argtype` オブジェクトが、フィールドを通じて到達可能な型も含めて、内容に依存しない同一性を持たない場合は `true` を返します（詳細は `Base.isidentityfree` を参照）。このクエリは特に `adjust_effects` 向けに設計されており、戻り値の型が `is_identity_free_argtype` の場合に、解析対象の呼び出しグラフ内での可変オブジェクトの割り当てによって汚染された `:consistent` 効果プロパティを絞り込めるようにします。これにより、割り当てられた可変オブジェクトが決して返されないことを保証します。
