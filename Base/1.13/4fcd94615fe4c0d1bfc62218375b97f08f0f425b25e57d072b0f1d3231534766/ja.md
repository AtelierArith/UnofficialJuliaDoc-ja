```julia
closewrite(stream)
```

全二重 I/O ストリームの書き込み側をシャットダウンします。まず [`flush`](@ref) を実行します。基盤となるファイルにはこれ以上データを書き込まないことを、相手側に通知します。この操作は、すべての IO 型でサポートされているわけではありません。

実装されている場合、`closewrite` を呼び出すと、その後の `read` または `eof` の呼び出しがブロックする状況では、代わりに EOF がスローされるか、true が返されます。ストリームがすでに閉じている場合、この操作は冪等です。

# Examples

```jldoctest
julia> io = Base.BufferStream(); # this never blocks, so we can read and write on the same Task

julia> write(io, "request");

julia> # calling `read(io)` here would block forever

julia> closewrite(io);

julia> read(io, String)
"request"
```
