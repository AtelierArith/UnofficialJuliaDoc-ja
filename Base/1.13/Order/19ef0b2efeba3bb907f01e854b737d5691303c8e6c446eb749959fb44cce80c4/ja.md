```julia
ReverseOrdering(fwd::Ordering=Forward)
```

順序を逆転させるラッパー。

与えられた `Ordering` `o` について、すべての `a`、`b` に対して、次が成り立つ。

```julia
lt(ReverseOrdering(o), a, b) == lt(o, b, a)
```
