```julia
is_mutation_free_argtype(argtype)::Bool
```

`argtype` オブジェクトが、型自体にもフィールド経由にも、到達可能な可変メモリを持たないという意味で変更不能である場合（`Base.ismutationfree` を参照）、`true` を返します。このクエリは、`:inaccessiblememonly` 効果プロパティの解析に特化して記述されており、変更不能なグローバルオブジェクトへのアクセスがある場合に `:inaccessiblememonly` プロパティを汚染しないことで、解析精度を高めることを目的としています。
