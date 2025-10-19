```julia
Base64EncodePipe(ostream)
```

書き込まれたバイトを `ostream` に書き込まれる base64 エンコードされた ASCII バイトに変換する新しい書き込み専用 I/O ストリームを返します。 `Base64EncodePipe` ストリームで [`close`](@ref) を呼び出すことは、エンコーディングを完了するために必要です（ただし、`ostream` は閉じません）。

# 例

```jldoctest
julia> io = IOBuffer();

julia> iob64_encode = Base64EncodePipe(io);

julia> write(iob64_encode, "Hello!")
6

julia> close(iob64_encode);

julia> str = String(take!(io))
"SGVsbG8h"

julia> String(base64decode(str))
"Hello!"
```
