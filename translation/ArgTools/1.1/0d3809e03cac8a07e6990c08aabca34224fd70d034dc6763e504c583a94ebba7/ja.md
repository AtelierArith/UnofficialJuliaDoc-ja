```julia
ArgWrite = Union{AbstractString, AbstractCmd, IO}
```

`ArgWrite`型は、`arg_write`関数が書き込み可能なIOハンドルに変換できる型の和集合です。ただし、`arg_write`が一時ファイルを生成して処理する`Nothing`は除きます。詳しくは[`arg_write`](@ref)を参照してください。
