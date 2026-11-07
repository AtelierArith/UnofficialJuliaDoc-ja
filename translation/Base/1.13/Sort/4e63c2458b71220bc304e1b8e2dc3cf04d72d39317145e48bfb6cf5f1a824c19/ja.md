```julia
send_to_end!(f::Function, v::AbstractVector, o::Base.Order.DirectOrdering[, end_stable]; lo, hi)
```

`v[a:b]` に送られない要素を `(a, b)` として返します。

`o isa ReverseOrdering` の場合、`v` の「末尾」は `v[lo]` です。

`end_stable` が設定されている場合、末尾に送られる要素は、送られない要素ではなく安定しています。
