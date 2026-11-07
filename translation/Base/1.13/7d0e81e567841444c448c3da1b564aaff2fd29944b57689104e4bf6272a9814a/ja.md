```julia
@gensym
```

変数用のgensymシンボルを生成します。たとえば、`@gensym x y`は`x = gensym("x"); y = gensym("y")`に変換されます。
