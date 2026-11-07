```julia
tokenize(x)
```

トークン化された入力を含む`Iterable`を返します。たとえば、`join(untokenize.(tokenize(x)))`で元に戻せます。
