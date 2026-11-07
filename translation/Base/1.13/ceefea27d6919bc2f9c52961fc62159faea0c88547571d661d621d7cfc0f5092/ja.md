```julia
unsafe_string(p::Ptr{UInt8}, [length::Integer])
unsafe_string(p::Cstring)
```

UTF-8でエンコードされたC形式（NUL終端）文字列のアドレスから文字列をコピーします（コピー後、ポインターは安全に解放できます）。`length`（データのバイト長）を指定した場合、文字列をNUL終端する必要はありません。

`p`が、指定された長さのデータを格納する有効なメモリアドレスでない場合、この関数はクラッシュするため、「unsafe」とされています。
