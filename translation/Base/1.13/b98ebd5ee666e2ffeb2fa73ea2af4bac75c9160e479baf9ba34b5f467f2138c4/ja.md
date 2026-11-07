```julia
typeintersect(T::Type, S::Type)
```

`T`と`S`の共通部分を含む型を計算します。通常は、そのような型のうち最小のもの、またはそれに近い型になります。

次の場合は、特別に動作が厳密に保証されます。`T <: S`、`typeintersect(S, T) == T == typeintersect(T, S)`。
