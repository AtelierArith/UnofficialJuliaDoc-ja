```julia
isnextchar(state::State, char::Char) -> Bool
isnextchar(state::State, chars::NTuple{N, Char}) -> Bool
```

`state` に次の文字があるかどうかを確認し、ある場合はそれが `char` または `chars` のいずれかであるかを確認します。
