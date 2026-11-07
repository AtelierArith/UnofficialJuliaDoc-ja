```julia
StepRangeLen(         ref::R, step::S, len, [offset=1]) where {  R,S}
StepRangeLen{T,R,S}(  ref::R, step::S, len, [offset=1]) where {T,R,S}
StepRangeLen{T,R,S,L}(ref::R, step::S, len, [offset=1]) where {T,R,S,L}
```

`r` の範囲では、`r[i]` によって `T` 型の値が生成されます（最初の形式では、`T` が自動的に推論されます）。この型は、`ref`erence 値、`step`、および `len`gth をパラメーターとします。デフォルトでは、`ref` は開始値 `r[1]` ですが、別のインデックス `1 <= offset <= len` に対する値として `r[offset]` を指定することもできます。`a:b` または `a:b:c` の構文では、`a`、`b`、`c` のいずれかが浮動小数点数の場合、`StepRangeLen` が作成されます。

!!! compat "Julia 1.7"
    4 番目の型パラメーター `L` を使用するには、Julia 1.7 以降が必要です。

