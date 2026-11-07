```julia
is_mutation_free_argtype(argtype)::Bool
```

`argtype` オブジェクトについて、その型自体またはフィールドを介して到達可能な可変メモリが存在しない場合（`Base.ismutationfree` を参照）、`true` を返します。このクエリは、`:inaccessiblememonly` 効果プロパティの解析に特化して記述されています。変更不可能なグローバルオブジェクトにアクセスした場合に `:inaccessiblememonly` プロパティを汚染せず、解析の精度を高めることを目的としています。
