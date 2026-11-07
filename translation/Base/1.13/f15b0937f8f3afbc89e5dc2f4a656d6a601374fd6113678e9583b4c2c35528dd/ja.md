```julia
print_statement_costs(io::IO, f, types)
```

`f`について、引数の型が`types`の場合に、型推論および最適化後のコードを出力します。各行の先頭には、コンパイラのインライン化エンジンが推定したコストを付けます。
