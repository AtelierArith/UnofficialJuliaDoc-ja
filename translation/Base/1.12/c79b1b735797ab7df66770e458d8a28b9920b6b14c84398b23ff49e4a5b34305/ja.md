```julia
eof(stream) -> Bool
```

I/O ストリームがファイルの終わりにあるかどうかをテストします。ストリームがまだ消耗していない場合、この関数は必要に応じてデータを待つためにブロックし、その後 `false` を返します。したがって、`eof` が `false` を返した後にバイトを 1 つ読み取ることは常に安全です。`eof` は、リモート接続の端が閉じられていても、バッファリングされたデータがまだ利用可能な限り `false` を返します。

# 例

```jldoctest
julia> b = IOBuffer("my buffer");

julia> eof(b)
false

julia> seekend(b);

julia> eof(b)
true
```
