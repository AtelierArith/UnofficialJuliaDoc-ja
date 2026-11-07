```julia
ainfo::AbstractIterationInfo
```

単一の値に対する抽象反復解析に必要な情報をすべて保持します。`iterate` の各（抽象）呼び出しは、`ainfo.each::Vector{CallMeta}` の1つのエントリに対応します。
