```
realloc(addr::Ptr, size::Integer) -> Ptr{Cvoid}
```

C標準ライブラリから`realloc`を呼び出します。

[`free`](@ref)に関するドキュメントの警告を参照し、元々[`malloc`](@ref)から取得したメモリにのみ使用することに注意してください。
