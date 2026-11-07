```julia
begin_style!(state::State, i::Int, char::Char)
```

`i`（`char`）で始まるスタイル宣言を`read_annotation!`で解析し、アクティブなスタイルリストに登録します。
