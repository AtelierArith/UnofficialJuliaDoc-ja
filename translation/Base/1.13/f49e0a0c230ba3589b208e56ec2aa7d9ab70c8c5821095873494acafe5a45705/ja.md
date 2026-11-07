```julia
isgreater(x, y)
```

`isless` の逆ではありません。`x` が `y` より大きいかどうかを、`min` と互換性のある固定された全順序に従って判定します。

`isless` で定義されており、この関数は通常 `isless(y, x)` ですが、`NaN` と [`missing`](@ref) は、`missing` が `NaN` より小さい場合、通常の値より小さいものとして順序付けられます。

したがって、`isless` は `NaN` と `missing` を最大値とする昇順の全順序を定義し、`isgreater` は `NaN` と `missing` を最小値とする降順の全順序を定義します。

!!! note
    `min` と同様に、`isgreater` はコンテナ（タプル、ベクトルなど）を、再帰的に自身を使うのではなく、`isless(y, x)` を使って辞書順に並べます。

    ```jldoctest
    julia> Base.isgreater(1, NaN) # 1 is greater than NaN
    true

    julia> Base.isgreater((1,), (NaN,)) # But (1,) is not greater than (NaN,)
    false

    julia> sort([1, 2, 3, NaN]; lt=Base.isgreater)
    4-element Vector{Float64}:
       3.0
       2.0
       1.0
     NaN

    julia> sort(tuple.([1, 2, 3, NaN]); lt=Base.isgreater)
    4-element Vector{Tuple{Float64}}:
     (NaN,)
     (3.0,)
     (2.0,)
     (1.0,)
    ```


# Implementation

これはエクスポートされていません。通常、型がこの関数を実装するべきではありません。代わりに `isless` を実装してください。
