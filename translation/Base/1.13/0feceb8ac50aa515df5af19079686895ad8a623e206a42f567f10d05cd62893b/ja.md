```julia
unsafe_write(io::IO, ref, nbytes::UInt)
```

`ref`（ポインターに変換したもの）から `nbytes` をコピーし、`IO` オブジェクトに格納します。

より効率的な実装を提供するため、サブタイプ `T<:IO` では、次のメソッドシグネチャをオーバーライドすることを推奨します。`unsafe_write(s::T, p::Ptr{UInt8}, n::UInt)`
