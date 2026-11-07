```julia
base64encode(writefunc, args...; context=nothing)
base64encode(args...; context=nothing)
```

最初の引数として I/O ストリームを受け取る [`write`](@ref)のような関数 `writefunc`では、`base64encode(writefunc, args...)`が `writefunc`を呼び出して `args...`を base64 エンコード文字列に書き込み、その文字列を返します。`base64encode(args...)`は `base64encode(write, args...)`と同等です。標準の [`write`](@ref)関数を使って引数をバイト列に変換し、base64 エンコード文字列を返します。

省略可能なキーワード引数 `context`には、`:key=>value`のペア、または `IO`や [`IOContext`](@ref)のオブジェクトを指定できます。これらの属性は、`writefunc`または `write`に渡される I/O ストリームに使用されます。

[`base64decode`](@ref)も参照してください。
