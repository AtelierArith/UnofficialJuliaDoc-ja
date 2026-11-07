```julia
isless(A::AbstractVector, B::AbstractVector)
```

`true`を返します。ただし、`A`が`B`より小さい場合です。ベクトルは、まず開始インデックスで比較し、次に要素を辞書順で比較します。
