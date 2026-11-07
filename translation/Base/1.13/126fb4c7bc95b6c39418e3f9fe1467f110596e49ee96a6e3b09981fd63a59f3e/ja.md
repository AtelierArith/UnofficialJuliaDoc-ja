```julia
has_offset_axes(A)
has_offset_axes(A, B, ...)
```

いずれかの軸に沿った`A`のインデックスが1以外から始まる場合は、`true`を返します。複数の引数が渡された場合は、`has_offset_axes(A) || has_offset_axes(B) || ...`と同等です。

[`require_one_based_indexing`](@ref)も参照してください。
