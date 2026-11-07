```julia
eof(stream)::Bool
```

I/Oストリームがファイル終端に達しているかどうかを調べます。ストリームのデータがまだ尽きていない場合、この関数は必要に応じて追加データが届くまでブロックし、その後`false`を返します。したがって、`eof`が`false`を返した後は、常に安全に1バイト読み取れます。接続のリモート側が閉じられていても、バッファにデータが残っている限り、`eof`は`false`を返します。

# Examples

```jldoctest
julia> b = IOBuffer("my buffer");

julia> eof(b)
false

julia> seekend(b);

julia> eof(b)
true
```
