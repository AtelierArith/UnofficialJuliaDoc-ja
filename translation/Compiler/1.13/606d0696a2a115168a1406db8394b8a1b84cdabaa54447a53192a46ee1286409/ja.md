```julia
info::ConstCallInfo <: CallInfo
```

定数情報を利用して、この呼び出しの精度が向上しました。元の呼び出し情報`info.call`に加えて、定数推論の結果も保持されます（`info.results::Vector{Union{Nothing,ConstResult}}`）。
