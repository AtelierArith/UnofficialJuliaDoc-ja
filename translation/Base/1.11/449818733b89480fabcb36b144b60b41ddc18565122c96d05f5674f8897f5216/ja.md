```
unsafe_write(io::IO, ref, nbytes::UInt)
```

`ref`（ポインタに変換された）から`nbytes`を`IO`オブジェクトにコピーします。

サブタイプ`T<:IO`は、より効率的な実装を提供するために、次のメソッドシグネチャをオーバーライドすることを推奨します：`unsafe_write(s::T, p::Ptr{UInt8}, n::UInt)`
