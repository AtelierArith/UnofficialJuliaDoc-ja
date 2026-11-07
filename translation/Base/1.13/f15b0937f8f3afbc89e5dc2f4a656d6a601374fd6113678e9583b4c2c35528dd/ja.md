```julia
print_statement_costs(io::IO, f, types)
```

`f`に型`types`の引数を渡した場合の、型推論後および最適化後のコードを出力します。各行の先頭には、コンパイラのインライン化エンジンが推定したコストを付けます。
