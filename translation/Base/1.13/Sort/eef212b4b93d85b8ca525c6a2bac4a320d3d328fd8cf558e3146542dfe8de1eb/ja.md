```julia
send_to_end!(f::Function, v::AbstractVector; [lo, hi])
```

`f` が `true` を返す `v` の各要素をベクトルの末尾に移動し、`f` が `false` を返す最後の要素のインデックスを返します。

`send_to_end!(f, v, lo, hi)` は `send_to_end!(f, view(v, lo:hi))+lo-1` と同等です。

末尾に移動しない要素の順序は保持されます。
