```julia
versioninfo(io::IO=stdout; verbose::Bool=false)
```

使用中のJuliaのバージョンに関する情報を印刷します。出力はブールキーワード引数で制御されます：

  * `verbose`: すべての追加情報を印刷する

!!! warning
    この関数の出力には機密情報が含まれている可能性があります。出力を共有する前に、出力を確認し、公開すべきでないデータを削除してください。


参照: [`VERSION`](@ref).
