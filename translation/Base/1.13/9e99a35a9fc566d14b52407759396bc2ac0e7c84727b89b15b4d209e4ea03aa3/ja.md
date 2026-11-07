```julia
StepRangeLen(         ref::R, step::S, len, [offset=1]) where {  R,S}
StepRangeLen{T,R,S}(  ref::R, step::S, len, [offset=1]) where {T,R,S}
StepRangeLen{T,R,S,L}(ref::R, step::S, len, [offset=1]) where {T,R,S,L}
```

`r` の範囲は、`r[i]` が `T` 型の値を生成します（最初の形式では、`T` は自動的に推論されます）。この型は、`ref`erence 値、`step`、および `len`gth をパラメーターとします。デフォルトでは、`ref` は開始値 `r[1]` ですが、別のインデックス `1 <= offset <= len` に対応する値を `r[offset]` として指定することもできます。`a`、`b`、`c` のいずれかが浮動小数点数である場合、構文 `a:b` または `a:b:c` は `StepRangeLen` を生成します。

!!! compat "Julia 1.7"
    4番目の型パラメーター `L` を使用するには、Julia 1.7 以降が必要です。

