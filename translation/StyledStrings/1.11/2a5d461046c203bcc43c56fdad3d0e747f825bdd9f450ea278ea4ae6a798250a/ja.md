```julia
parse(::Type{SimpleColor}, rgb::String)
```

`tryparse(SimpleColor, rgb::String)`の類似で、エラーを発生させる代わりに`nothing`を返します。
