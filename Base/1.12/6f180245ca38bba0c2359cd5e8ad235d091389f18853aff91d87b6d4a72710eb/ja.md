```julia
cglobal((symbol, library) [, type=Cvoid])
```

Cでエクスポートされた共有ライブラリ内のグローバル変数へのポインタを取得します。これは[`ccall`](@ref)と正確に同じように指定されます。`Ptr{Type}`を返し、`Type`引数が供給されない場合はデフォルトで`Ptr{Cvoid}`になります。値はそれぞれ[`unsafe_load`](@ref)または[`unsafe_store!`](@ref)によって読み書きできます。
