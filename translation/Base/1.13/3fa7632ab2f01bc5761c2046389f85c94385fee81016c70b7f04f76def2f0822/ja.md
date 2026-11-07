```julia
eof(stream)::Bool
```

I/Oストリームがファイル終端に達しているかどうかを調べます。ストリームのデータがまだ尽きていない場合、必要に応じて追加データを待ってから、`false`を返します。そのため、`eof`が`false`を返した後であれば、常に安全に1バイト読み取れます。接続のリモート側が閉じられていても、バッファーにデータが残っている限り、`eof`は`false`を返します。

# Examples

```jldoctest
julia> b = IOBuffer("my buffer");

julia> eof(b)
false

julia> seekend(b);

julia> eof(b)
true
```
