```julia
hi, lo = canonicalize2(big, little)
```

`hi` のすべての非ゼロビットが、`lo` のどの非ゼロビットよりも上位になる表現を生成してください。`big` の絶対値は、`little` より大きくなければなりません。
