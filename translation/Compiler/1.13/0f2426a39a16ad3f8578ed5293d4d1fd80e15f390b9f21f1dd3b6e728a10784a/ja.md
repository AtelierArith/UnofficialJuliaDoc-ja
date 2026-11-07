```julia
add_remark!(::AbstractInterpreter, sv::InferenceState, remark)
```

現在の行に対する推論中に解析コメントを出力します（つまり、`sv.currpc`）。これらの注釈はデフォルトでは無視されますが、外部ツールで推論結果に注釈を付けるために使用できます。
