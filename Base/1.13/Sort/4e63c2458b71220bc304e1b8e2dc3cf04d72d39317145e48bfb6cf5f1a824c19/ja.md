```julia
send_to_end!(f::Function, v::AbstractVector, o::Base.Order.DirectOrdering[, end_stable]; lo, hi)
```

`v[a:b]` に送信されない要素を `(a, b)` として返します。

`o isa ReverseOrdering` の場合、`v` の「end」は `v[lo]` です。

`end_stable` が設定されている場合、送信される要素は、送信されない要素ではなく安定した要素になります。
