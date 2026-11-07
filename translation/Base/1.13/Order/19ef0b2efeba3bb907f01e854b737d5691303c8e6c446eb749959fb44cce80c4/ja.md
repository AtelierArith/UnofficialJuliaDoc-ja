```julia
ReverseOrdering(fwd::Ordering=Forward)
```

順序を逆転させるラッパー。

`Ordering` `o` が与えられたとき、すべての `a`、`b` について、次が成り立つ。

```julia
lt(ReverseOrdering(o), a, b) == lt(o, b, a)
```
