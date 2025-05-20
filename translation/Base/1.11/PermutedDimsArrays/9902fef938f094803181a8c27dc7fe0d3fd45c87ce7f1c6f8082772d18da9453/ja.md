```
permutedims!(dest, src, perm)
```

配列 `src` の次元を入れ替え、その結果を配列 `dest` に格納します。`perm` は `ndims(src)` の長さを持つ順列を指定するベクターです。事前に確保された配列 `dest` は `size(dest) == size(src)[perm]` である必要があり、完全に上書きされます。インプレースの入れ替えはサポートされておらず、`src` と `dest` が重複するメモリ領域を持つ場合、予期しない結果が生じる可能性があります。

詳細は [`permutedims`](@ref) を参照してください。
