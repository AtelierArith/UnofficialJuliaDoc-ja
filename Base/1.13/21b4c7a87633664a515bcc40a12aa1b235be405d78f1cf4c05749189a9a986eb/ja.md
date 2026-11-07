```julia
precompile(f, argtypes::Tuple{Vararg{Any}}, m::Method)
```

指定した引数型に対する特定のメソッドを事前コンパイルします。これにより、通常のディスパッチで選択されるメソッドとは異なるメソッドを事前コンパイルでき、`invoke` を模倣できます。
