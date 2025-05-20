```
cglobal((symbol, library) [, type=Cvoid])
```

Cでエクスポートされた共有ライブラリ内のグローバル変数へのポインタを取得します。これは[`ccall`](@ref)で指定された通りです。`Type`引数が供給されない場合は、デフォルトで`Ptr{Cvoid}`になります。値はそれぞれ[`unsafe_load`](@ref)または[`unsafe_store!`](@ref)によって読み書きできます。
