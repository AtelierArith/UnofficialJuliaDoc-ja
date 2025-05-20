```
unsafe_read(io::IO, ref, nbytes::UInt)
```

`IO` ストリームオブジェクトから `ref` に `nbytes` をコピーします（ポインタに変換されます）。

サブタイプ `T<:IO` は、より効率的な実装を提供するために、次のメソッドシグネチャをオーバーライドすることを推奨します: `unsafe_read(s::T, p::Ptr{UInt8}, n::UInt)`
