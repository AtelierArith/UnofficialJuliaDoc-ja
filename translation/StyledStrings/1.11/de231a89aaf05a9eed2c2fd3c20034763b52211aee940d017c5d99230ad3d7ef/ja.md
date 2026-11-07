```julia
termcolor8bit(io::IO, color::RGBTuple, category::Char)
```

`category`の色を`color`に近づける、最適な8ビットSGRカラーコードを`io`に出力してください。
