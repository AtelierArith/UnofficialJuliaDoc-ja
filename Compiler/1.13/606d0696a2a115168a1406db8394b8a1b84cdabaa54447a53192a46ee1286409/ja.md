```julia
info::ConstCallInfo <: CallInfo
```

定数に関する情報を利用して、この呼び出しの精度が向上しました。元の呼び出し情報`info.call`に加えて、この情報には定数推論の結果`info.results::Vector{Union{Nothing,ConstResult}}`も保持されています。
