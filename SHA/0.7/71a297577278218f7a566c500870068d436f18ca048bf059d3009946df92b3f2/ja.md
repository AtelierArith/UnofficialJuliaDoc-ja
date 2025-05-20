```
digest!(context)
```

SHAコンテキストを最終化し、ハッシュをバイトの配列（Array{Uint8, 1}）として返します。`digest!`を呼び出した後にコンテキストを更新するとエラーになります。

# 例

```julia-repl
julia> ctx = SHA1_CTX()
SHA1ハッシュ状態

julia> update!(ctx, b"ハッシュされるデータ")

julia> digest!(ctx)
20要素のArray{UInt8,1}:
 0x83
 0xe4
 ⋮
 0x89
 0xf5

julia> update!(ctx, b"さらにデータ")
ERROR: `digest!`が呼び出された後にCTXを更新することはできません
[...]
```
