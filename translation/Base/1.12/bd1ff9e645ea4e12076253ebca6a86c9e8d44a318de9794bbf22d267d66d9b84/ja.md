```julia
circshift!(dest, src, shifts)
```

`src`のデータを円環的にシフト（回転）し、結果を`dest`に格納します。`shifts`は各次元でのシフト量を指定します。

!!! warning
    変更された引数が他の引数とメモリを共有している場合、動作が予期しないものになることがあります。


関連情報は[`circshift`](@ref)を参照してください。
