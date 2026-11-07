```julia
Base64EncodePipe(ostream)
```

書き込まれたバイト列をBase64エンコードしたASCIIバイト列に変換し、`ostream`に書き込む、書き込み専用のI/Oストリームを返します。エンコードを完了するには、`Base64EncodePipe`ストリームに対して[`close`](@ref)を呼び出す必要があります（ただし、`ostream`は閉じられません）。

# Examples

```jldoctest
julia> io = IOBuffer();

julia> iob64_encode = Base64EncodePipe(io);

julia> write(iob64_encode, "Hello!")
6

julia> close(iob64_encode);

julia> str = takestring!(io)
"SGVsbG8h"

julia> String(base64decode(str))
"Hello!"
```
