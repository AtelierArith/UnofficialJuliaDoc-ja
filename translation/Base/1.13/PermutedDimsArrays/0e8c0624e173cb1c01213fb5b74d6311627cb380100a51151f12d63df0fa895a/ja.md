```julia
permutedims!(dest, src, perm)
```

配列 `src` の次元を並べ替え、その結果を配列 `dest` に格納します。`perm` は、長さ `ndims(src)` の置換を指定するベクトルです。事前に確保した配列 `dest` は `size(dest) == size(src)[perm]` を満たす必要があり、内容はすべて上書きされます。インプレースでの置換には対応していません。また、`src` と `dest` のメモリ領域が重複していると、予期しない結果になります。

関連項目: [`permutedims`](@ref)。
