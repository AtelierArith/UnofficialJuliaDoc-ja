```julia
has_offset_axes(A)
has_offset_axes(A, B, ...)
```

`A`のインデックスが任意の軸に沿って1以外の値で始まる場合は`true`を返します。複数の引数が渡された場合、`has_offset_axes(A) || has_offset_axes(B) || ...`と同等です。

関連情報は[`require_one_based_indexing`](@ref)を参照してください。
