```julia
ordschur(F::GeneralizedSchur, select::Union{Vector{Bool},BitVector}) -> F::GeneralizedSchur
```

行列ペア `(A, B) = (Q*S*Z', Q*T*Z')` の一般化 Schur 分解 `F` を、論理配列 `select` に従って並べ替え、GeneralizedSchur オブジェクト `F` を返します。選択された固有値は `F.S` と `F.T` の両方の対角成分の先頭に配置されます。また、左および右の直交／ユニタリ Schur ベクトルも並べ替えられ、`(A, B) = F.Q*(F.S, F.T)*F.Z'` が引き続き成り立ち、`A` と `B` の一般化固有値を `F.α./F.β` で引き続き求められるようになります。
