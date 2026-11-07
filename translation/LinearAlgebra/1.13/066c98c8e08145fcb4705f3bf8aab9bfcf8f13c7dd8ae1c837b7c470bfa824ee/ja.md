```julia
RankDeficientException
```

入力行列が[rank deficient](https://en.wikipedia.org/wiki/Rank_(linear_algebra))の場合にスローされる例外です。コレスキー分解など、一部の線形代数関数は、ランク落ちしていない行列にのみ適用できます。`info`フィールドは、行列の計算されたランクを示します。
