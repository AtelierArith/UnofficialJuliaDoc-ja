```julia
digest!(context)
```

SHAコンテキストを確定し、ハッシュをバイト配列（Vector{Uint8}）として返します。コンテキストに対して`digest!`を呼び出した後に更新しようとすると、エラーになります。

# Examples

```julia-repl
julia> ctx = SHA1_CTX()
SHA1 hash state

julia> update!(ctx, b"data to to be hashed")

julia> digest!(ctx)
20-element Vector{UInt8}:
 0x83
 0xe4
 ⋮
 0x89
 0xf5

julia> update!(ctx, b"more data")
ERROR: Cannot update CTX after `digest!` has been called on it
[...]
```
