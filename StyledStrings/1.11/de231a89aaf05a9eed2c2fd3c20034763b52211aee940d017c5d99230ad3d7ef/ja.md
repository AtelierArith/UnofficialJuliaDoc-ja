```julia
termcolor8bit(io::IO, color::RGBTuple, category::Char)
```

`category` の色を `color` に近づける、最適な 8 ビット SGR カラーコードを `io` に出力してください。
