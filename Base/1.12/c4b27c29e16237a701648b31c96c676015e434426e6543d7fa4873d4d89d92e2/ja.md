```julia
closewrite(stream)
```

フルデュプレックスI/Oストリームの書き込み半分をシャットダウンします。最初に[`flush`](@ref)を実行します。基盤となるファイルにデータがこれ以上書き込まれないことを他の端に通知します。これはすべてのIOタイプでサポートされているわけではありません。

実装されている場合、`closewrite`は、ブロックするはずの後続の`read`または`eof`呼び出しが、代わりにEOFをスローするか、真を返すようにします。ストリームがすでに閉じている場合、これは冪等です。

# 例

```jldoctest
julia> io = Base.BufferStream(); # これは決してブロックしないので、同じタスクで読み書きできます

julia> write(io, "request");

julia> # ここで`read(io)`を呼び出すと永遠にブロックされます

julia> closewrite(io);

julia> read(io, String)
"request"
```
