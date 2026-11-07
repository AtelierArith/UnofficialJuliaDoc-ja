```julia
_terminfo_read_strings(table::Vector{UInt8}, indices::Vector{Int16})
```

`table`から、`indices`の各位置を開始位置として文字列を読み取ります。各文字列はヌル終端でなければなりません。インデックスが-1または-2の場合は、文字列の代わりに`nothing`が与えられます。
