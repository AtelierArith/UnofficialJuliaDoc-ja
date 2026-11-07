```julia
SHA
```

SHA モジュールは、SHA1、SHA2、SHA3 アルゴリズムによるハッシュ機能を提供します。

単一のデータをハッシュする純粋関数と、`update!` 関数で更新し、`digest!` 関数で確定する状態を持つコンテキストの、どちらの形式でも利用できます。

```julia-repl julia> sha1(b"some data") 20-element Vector{UInt8}:  0xba  0xf3     ⋮  0xe3  0x56

julia> ctx = SHA1_CTX() SHA1 hash state

julia> update!(ctx, b"some data") 0x0000000000000009

julia> digest!(ctx) 20-element Vector{UInt8}:  0xba  0xf3     ⋮  0xe3  0x56
