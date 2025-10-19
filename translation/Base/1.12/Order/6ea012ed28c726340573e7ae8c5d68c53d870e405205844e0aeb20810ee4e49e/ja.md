```julia
ReverseOrdering(fwd::Ordering=Forward)
```

順序を逆にするラッパーです。

与えられた `Ordering` `o` に対して、すべての `a`, `b` に対して以下が成り立ちます：

```julia
lt(ReverseOrdering(o), a, b) == lt(o, b, a)
```
