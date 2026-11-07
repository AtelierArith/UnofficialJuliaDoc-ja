```julia
Base.checked_length(r)
```

`length(r)` を計算します。ただし、結果が `Union{Integer(eltype(r)),Int}` に収まらない場合は、該当する箇所でオーバーフローエラーをチェックすることがあります。
