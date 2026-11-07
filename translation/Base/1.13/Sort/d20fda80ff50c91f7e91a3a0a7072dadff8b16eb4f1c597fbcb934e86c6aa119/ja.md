```julia
partialsort(v, k, by=identity, lt=isless, rev=false, order::Base.Order.Ordering=Base.Order.Forward)
```

[`partialsort!`](@ref)の変種です。`v`をコピーしてから部分ソートするため、`partialsort!`と同じものを返しますが、`v`は変更されません。
