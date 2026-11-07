```julia
parse!(TreeType, io::IO; rule=:all, version=VERSION)
```

シーク可能な`IO`オブジェクトからJuliaソースコードを解析します。出力はタプル`(tree, diagnostics)`です。`parse!`が返ると、ストリーム`io`は、解析中に読み取られた最後のバイトの直後に位置しています。
