```julia
Small{N}(small=SMALL_ALGORITHM, big) isa Base.Sort.Algorithm
```

入力を`length(lo:hi) <= N`で並べ替える場合は、`small`アルゴリズムを使用します。それ以外の場合は、`big`アルゴリズムを使用します。
