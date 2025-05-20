```
StepRangeLen(         ref::R, step::S, len, [offset=1]) where {  R,S}
StepRangeLen{T,R,S}(  ref::R, step::S, len, [offset=1]) where {T,R,S}
StepRangeLen{T,R,S,L}(ref::R, step::S, len, [offset=1]) where {T,R,S,L}
```

範囲 `r` は `r[i]` が型 `T` の値を生成します（最初の形式では、`T` は自動的に推論されます）。これは、`ref` 値、`step`、および `len` によってパラメータ化されています。デフォルトでは `ref` は開始値 `r[1]` ですが、代わりに他のインデックス `1 <= offset <= len` の `r[offset]` の値として供給することもできます。構文 `a:b` または `a:b:c` は、`a`、`b`、または `c` のいずれかが浮動小数点数である場合、`StepRangeLen` を作成します。

!!! compat "Julia 1.7"
    4番目の型パラメータ `L` は少なくとも Julia 1.7 が必要です。

