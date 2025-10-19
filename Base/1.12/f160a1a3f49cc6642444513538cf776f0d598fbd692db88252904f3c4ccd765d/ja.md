```julia
similar(storagetype, axes)
```

指定された `storagetype` に類似した初期化されていない可変配列を作成しますが、最後の引数で指定された `axes` を持ちます。

**例**:

```julia
similar(Array{Int}, axes(A))
```

は、`Array{Int}` のように「動作する」配列を作成します（実際にその配列に基づいている可能性があります）が、インデックスは `A` と同じになります。`A` が従来のインデックス付けを持つ場合、これは `Array{Int}(undef, size(A))` と同じになりますが、`A` が非従来のインデックス付けを持つ場合、結果のインデックスは `A` に一致します。

```julia
similar(BitArray, (axes(A, 2),))
```

は、`A` の列のインデックスに一致する1次元の論理配列を作成します。
