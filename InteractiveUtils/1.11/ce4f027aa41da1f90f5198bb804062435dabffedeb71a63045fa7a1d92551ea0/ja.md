```julia
versioninfo(io::IO=stdout; verbose::Bool=false)
```

使用中の Julia のバージョン情報を表示します。出力内容は、次のブール値キーワード引数で制御できます。

  * `verbose`: 追加情報をすべて表示します

!!! warning
    この関数の出力には、機密情報が含まれる場合があります。出力を共有する前に内容を確認し、公開すべきでないデータを削除してください。


関連項目: [`VERSION`](@ref)。
