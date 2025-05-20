```
ordschur(F::Schur, select::Union{Vector{Bool},BitVector}) -> F::Schur
```

行列 `A = Z*T*Z'` のシュール分解 `F` を論理配列 `select` に従って再配置し、再配置された分解 `F` オブジェクトを返します。選択された固有値は `F.Schur` の主対角線に現れ、対応する `F.vectors` の主列は対応する右不変部分空間の直交/ユニタリ基底を形成します。実数の場合、複素共役の固有値の対は、`select` を介して両方とも含めるか、両方とも除外する必要があります。
