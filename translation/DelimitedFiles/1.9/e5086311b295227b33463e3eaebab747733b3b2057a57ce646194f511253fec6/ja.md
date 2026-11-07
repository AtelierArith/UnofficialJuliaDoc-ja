```julia
readdlm(source, delim::AbstractChar, eol::AbstractChar; options...)
```

すべてのデータが数値の場合、結果は数値配列になります。数値として解析できない要素がある場合は、数値と文字列が混在する配列が返されます。
