```julia
typeintersect(T::Type, S::Type)
```

`T` と `S` の交差を含む型を計算します。通常、これはそのような型の中で最も小さいもの、またはそれに近いものになります。

正確な動作が保証される特別なケース: `T <: S` の場合、`typeintersect(S, T) == T == typeintersect(T, S)` です。
