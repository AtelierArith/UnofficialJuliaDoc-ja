```julia
copyto!(dest, doffs, src, soffs, n)
```

コレクション `src` から線形インデックス `soffs` で始まる `n` 要素を配列 `dest` のインデックス `doffs` で始まる位置にコピーします。`dest` を返します。
