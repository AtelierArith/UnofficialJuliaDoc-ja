```
ordschur(F::GeneralizedSchur, select::Union{Vector{Bool},BitVector}) -> F::GeneralizedSchur
```

行列ペア `(A, B) = (Q*S*Z', Q*T*Z')` の一般化シュア分解 `F` を論理配列 `select` に従って再配置し、一般化シュアオブジェクト `F` を返します。選択された固有値は、`F.S` と `F.T` の両方の主対角線に現れ、左および右の直交/ユニタリシュアベクトルも再配置されるため、`(A, B) = F.Q*(F.S, F.T)*F.Z'` が依然として成り立ち、`A` と `B` の一般化固有値は `F.α./F.β` で依然として取得できます。
