```julia
print([to_toml::Function], io::IO [=stdout], data::AbstractDict; sorted=false, by=identity, inline_tables::IdSet{<:AbstractDict})
```

`data`をストリーム`io`にTOML構文として書き込みます。キーワード引数`sorted`が`true`に設定されている場合、キーワード引数`by`で指定された関数に従ってテーブルをソートします。キーワード引数`inline_tables`が指定されている場合、それは「インライン」で印刷されるべきテーブルのセットである必要があります。

次のデータ型がサポートされています: `AbstractDict`, `AbstractVector`, `AbstractString`, `Integer`, `AbstractFloat`, `Bool`, `Dates.DateTime`, `Dates.Time`, `Dates.Date`。整数と浮動小数点数はそれぞれ`Float64`と`Int64`に変換可能である必要があります。他のデータ型については、データ型を受け取りサポートされている型の値を返す`to_toml`関数を渡してください。
