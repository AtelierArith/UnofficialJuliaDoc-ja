```julia
GitHash(ptr::Ptr{UInt8})
```

SHA-1ハッシュのバイト列を含む`UInt8`データへのポインターから、`GitHash`を構築します。ポインターがnull、つまり`C_NULL`と等しい場合、コンストラクターはエラーをスローします。
