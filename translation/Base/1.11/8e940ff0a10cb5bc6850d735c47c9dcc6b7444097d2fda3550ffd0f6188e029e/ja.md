```
@inbounds(blk)
```

式内での配列の境界チェックを排除します。

以下の例では、配列 `A` の要素 `i` を参照するための範囲内チェックがスキップされ、パフォーマンスが向上します。

```julia
function sum(A::AbstractArray)
    r = zero(eltype(A))
    for i in eachindex(A)
        @inbounds r += A[i]
    end
    return r
end
```

!!! warning
    `@inbounds` を使用すると、範囲外のインデックスに対して不正な結果/クラッシュ/破損が返される可能性があります。ユーザーは手動でチェックする責任があります。すべてのアクセスが境界内であることがローカルに利用可能な情報から確実である場合にのみ `@inbounds` を使用してください。特に、上記のような関数で `eachindex(A)` の代わりに `1:length(A)` を使用することは、`AbstractArray` をサブタイプ化するすべてのユーザー定義型に対して `A` の最初のインデックスが `1` でない可能性があるため、安全に境界内とは言えません。

