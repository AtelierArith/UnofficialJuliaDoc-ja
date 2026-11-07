```julia
circshift!(dest, src, shifts)
```

`src` 内のデータを循環シフト（回転）し、結果を `dest` に格納します。`shifts` には、各次元でのシフト量を指定します。

!!! warning
    変更される引数がほかの引数とメモリを共有している場合、予期しない動作になることがあります。


関連項目: [`circshift`](@ref)。
