```julia
print_candidate(io::IO, search::FilterSpec, cand::HistEntry, width::Int; selected::Bool, hover::Bool)
```

マーカー、モードのヒント、経過時間、強調表示された内容を含む履歴エントリーを1行で表示します。

`width` に収まるよう、切り詰めて一致箇所にフォーカスします。
