```julia
cglobal((symbol, library) [, type=Cvoid])
```

C でエクスポートされた共有ライブラリ内のグローバル変数へのポインターを取得します。指定方法は [`ccall`](@ref) と同じです。`Type` 引数が指定されていない場合は、デフォルトで `Ptr{Cvoid}` となる `Ptr{Type}` を返します。値の読み取りと書き込みには、それぞれ [`unsafe_load`](@ref) と [`unsafe_store!`](@ref) を使用できます。
