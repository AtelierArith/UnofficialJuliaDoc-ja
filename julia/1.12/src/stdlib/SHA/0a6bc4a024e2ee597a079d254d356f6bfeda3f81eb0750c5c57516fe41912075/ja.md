```@meta
EditURL = "https://github.com/JuliaCrypto/SHA.jl/blob/master/docs/src/index.md"
```

# SHA

```@meta
DocTestSetup = quote
    using SHA
    using InteractiveUtils
end
```

## SHA functions

使用は非常に簡単です：

```jldoctest
julia> using SHA

julia> bytes2hex(sha256("test"))
"9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
```

各エクスポートされた関数（この記事執筆時点では、SHA-1、SHA-2 224、256、384、512、およびSHA-3 224、256、384、512関数が実装されています）は、`AbstractVector{UInt8}`、`AbstractString`、または`IO`オブジェクトのいずれかを受け取ります。これにより、ファイルのチェックサムを簡単に計算できます：

```julia
shell> cat /tmp/test.txt
test
julia> using SHA

julia> open("/tmp/test.txt") do f
           sha2_256(f)
       end
32-element Vector{UInt8}:
 0x9f
 0x86
 0xd0
 0x81
 0x88
 0x4c
 0x7d
 0x65
    ⋮
 0x5d
 0x6c
 0x15
 0xb0
 0xf0
 0x0a
 0x08
```

### All SHA functions

`sha256`を`sha2_256`を指すための口語的な使用法のため、`shaxxx()`関数の呼び出しを`sha2_xxx()`にマッピングする便利な関数が提供されています。SHA-3については、そのような口語は存在せず、ユーザーは完全な`sha3_xxx()`の名前を使用する必要があります。

`shaxxx()` は `AbstractString` と要素が `UInt8` 型の配列のようなオブジェクト（`NTuple` と `Vector`）を受け取ります。

**SHA-1**

```@docs
sha1
```

**SHA-2**

```@docs
sha224
sha256
sha384
sha512
sha2_224
sha2_256
sha2_384
sha2_512
sha2_512_224
sha2_512_256
```

**SHA-3**

```@docs
sha3_224
sha3_256
sha3_384
sha3_512
```

## Working with context

複数のアイテムからハッシュを作成するには、`SHAX_XXX_CTX()` タイプを使用して、`update!` で更新され、`digest!` で最終化される状態を持つハッシュオブジェクトを作成できます。

```jldoctest
julia> using SHA

julia> ctx = SHA2_256_CTX()
SHA2 256-bit hash state

julia> update!(ctx, b"some data")
0x0000000000000009

julia> update!(ctx, b"some more data")
0x0000000000000017

julia> digest!(ctx)
32-element Vector{UInt8}:
 0xbe
 0xcf
 0x23
 0xda
 0xaf
 0x02
 0xf7
 0xa3
 0x57
 0x92
    ⋮
 0x89
 0x4f
 0x59
 0xd8
 0xb3
 0xb4
 0x81
 0x8b
 0xc5
```

この執筆時点では、SHA3コードは最適化されておらず、そのためSHA2よりもおおよそ1桁遅いことに注意してください。

```@docs
update!
digest!
```

### All SHA context types

**SHA-1**

```@docs
SHA1_CTX
```

**SHA-2**

便利なタイプも提供されており、`SHAXXX_CTX`は`SHA2_XXX_CTX`の型エイリアスです。

```@docs
SHA224_CTX
SHA256_CTX
SHA384_CTX
SHA512_CTX
SHA2_224_CTX
SHA2_256_CTX
SHA2_384_CTX
SHA2_512_CTX
SHA2_512_224_CTX
SHA2_512_256_CTX
```

**SHA-3**

```@docs
SHA3_224_CTX
SHA3_256_CTX
SHA3_384_CTX
SHA3_512_CTX
```

## HMAC functions

```jldoctest
julia> using SHA

julia> key = collect(codeunits("key_string"))
10-element Vector{UInt8}:
 0x6b
 0x65
 0x79
 0x5f
 0x73
 0x74
 0x72
 0x69
 0x6e
 0x67

julia> bytes2hex(hmac_sha3_256(key, "test-message"))
"bc49a6f2aa29b27ee5ed1e944edd7f3d153e8a01535d98b5e24dac9a589a6248"
```

複数のアイテムからハッシュを作成するには、`HMAC_CTX()` タイプを使用して、`update!` で更新され、`digest!` で最終化される状態を持つハッシュオブジェクトを作成できます。

```jldoctest
julia> using SHA

julia> key = collect(codeunits("key_string"))
10-element Vector{UInt8}:
 0x6b
 0x65
 0x79
 0x5f
 0x73
 0x74
 0x72
 0x69
 0x6e
 0x67

julia> ctx = HMAC_CTX(SHA3_256_CTX(), key);

julia> update!(ctx, b"test-")
0x0000000000000000000000000000008d

julia> update!(ctx, b"message")
0x00000000000000000000000000000094

julia> bytes2hex(digest!(ctx))
"bc49a6f2aa29b27ee5ed1e944edd7f3d153e8a01535d98b5e24dac9a589a6248"
```

### All HMAC functions

**HMAC コンテキストタイプ**

```@docs
HMAC_CTX
```

**SHA-1**

```@docs
hmac_sha1
```

**SHA-2**

```@docs
hmac_sha224
hmac_sha256
hmac_sha384
hmac_sha512
hmac_sha2_224
hmac_sha2_256
hmac_sha2_384
hmac_sha2_512
```

**SHA-3**

```@docs
hmac_sha3_224
hmac_sha3_256
hmac_sha3_384
hmac_sha3_512
```
