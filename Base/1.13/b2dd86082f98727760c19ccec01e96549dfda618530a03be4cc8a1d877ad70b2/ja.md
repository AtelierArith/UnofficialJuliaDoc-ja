```julia
unsafe_read(io::IO, ref, nbytes::UInt)
```

`IO`ストリームオブジェクトから`nbytes`をコピーし、`ref`（ポインターに変換済み）に格納します。

より効率的な実装を提供するため、サブタイプ`T<:IO`では、次のメソッドシグネチャをオーバーライドすることを推奨します。`unsafe_read(s::T, p::Ptr{UInt8}, n::UInt)`
