```julia
IdentityUnitRange(range::AbstractUnitRange)
```

AbstractUnitRange `range` をオフセットベクトルとして表現し、`range[i] == i` とします。

`IdentityUnitRange` は、オフセット配列の軸としてよく使われます。
