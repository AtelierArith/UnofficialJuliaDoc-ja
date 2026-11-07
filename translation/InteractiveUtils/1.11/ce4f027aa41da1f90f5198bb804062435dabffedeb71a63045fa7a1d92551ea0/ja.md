```julia
versioninfo(io::IO=stdout; verbose::Bool=false)
```

使用中の Julia のバージョン情報を出力します。出力内容は、次の真偽値キーワード引数で制御できます。

  * `verbose`: 追加情報をすべて出力します

!!! warning
    この関数の出力には、機密情報が含まれる場合があります。共有する前に出力を確認し、公開すべきでないデータを削除してください。


関連項目: [`VERSION`](@ref)。
