```julia
copy_oftype(A, T)
```

`A` の要素型を `T` にしたコピーを作成します。結果が変更可能かどうかについては、何も保証しません。`eltype(A) == T` の場合は、カスタム配列型でオーバーロードできる `copy(A)` を呼び出します。それ以外の場合は、`convert(AbstractArray{T}, A)` を呼び出します。
