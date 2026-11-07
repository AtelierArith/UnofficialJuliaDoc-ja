```julia
update!(context, data[, datalen])
```

data 内のバイト列で SHA コンテキストを更新します。ハッシュの確定については、[`digest!`](@ref) も参照してください。

# Examples

```julia-repl
julia> ctx = SHA1_CTX()
SHA1 hash state

julia> update!(ctx, b"data to to be hashed")
```
