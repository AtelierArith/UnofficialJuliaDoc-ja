```
SHA
```

SHAモジュールは、SHA1、SHA2、およびSHA3アルゴリズムのハッシュ機能を提供します。

これらは、単一のデータのハッシュ化のための純粋な関数として、または`update!`関数で更新できる状態を持つコンテキストとして実装されています。そして、`digest!`で最終化されます。

```julia-repl julia> sha1(b"some data") 20-element Vector{UInt8}:  0xba  0xf3     ⋮  0xe3  0x56

julia> ctx = SHA1_CTX() SHA1 hash state

julia> update!(ctx, b"some data") 0x0000000000000009

julia> digest!(ctx) 20-element Vector{UInt8}:  0xba  0xf3     ⋮  0xe3  0x56
```
