```julia
print([to_toml::Function], io::IO [=stdout], data::AbstractDict; sorted=false, by=identity, inline_tables::IdSet{<:AbstractDict})
```

`data`をTOML構文で`io`に書き込みます。キーワード引数`sorted`に`true`が設定されている場合、キーワード引数`by`で指定された関数に従ってテーブルを並べ替えます。キーワード引数`inline_tables`を指定する場合は、「インライン」で出力するテーブルの集合を指定してください。

!!! compat "Julia 1.11"
    キーワード引数`inline_tables`は、Julia 1.11以降でサポートされています。


次のデータ型がサポートされています：`AbstractDict`、`AbstractVector`、`AbstractString`、`Integer`、`AbstractFloat`、`Bool`、`Dates.DateTime`、`Dates.Time`、`Dates.Date`。整数と浮動小数点数は、それぞれ`Float64`および`Int64`に変換可能である必要があります。それ以外のデータ型については、そのデータ型を受け取り、サポート対象の型の値を返す関数`to_toml`を渡してください。
