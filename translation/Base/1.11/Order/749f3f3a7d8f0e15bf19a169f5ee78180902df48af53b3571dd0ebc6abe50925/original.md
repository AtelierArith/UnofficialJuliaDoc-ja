```
ReverseOrdering(fwd::Ordering=Forward)
```

A wrapper which reverses an ordering.

For a given `Ordering` `o`, the following holds for all  `a`, `b`:

```
lt(ReverseOrdering(o), a, b) == lt(o, b, a)
```
