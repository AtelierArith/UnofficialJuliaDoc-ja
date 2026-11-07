```julia
similar(storagetype, axes)
```

`storagetype`で指定されたものと同様の、未初期化の可変配列を作成します。ただし、`axes`は最後の引数で指定します。

**例**:

```julia
similar(Array{Int}, axes(A))
```

これは、`Array{Int}`のように振る舞う（実際にそれを基盤としている場合もある）配列を作成しますが、インデックスは`A`と同じです。`A`が通常のインデックスを持つ場合、これは`Array{Int}(undef, size(A))`と同一になります。一方、`A`が通常とは異なるインデックスを持つ場合、結果のインデックスは`A`と一致します。

```julia
similar(BitArray, (axes(A, 2),))
```

これは、インデックスが`A`の列のインデックスと一致する、1次元の論理配列を作成します。
