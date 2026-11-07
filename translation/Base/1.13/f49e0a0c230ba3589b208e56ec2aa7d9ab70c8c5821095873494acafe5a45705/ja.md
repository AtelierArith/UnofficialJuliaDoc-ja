```julia
isgreater(x, y)
```

`isless` の逆ではありません。`x` が `y` より大きいかどうかを、`min` と互換性のある固定された全順序に従って判定します。

`isless` で定義されるこの関数は、通常は `isless(y, x)` ですが、`NaN` と [`missing`](@ref) は、`missing` が `NaN` より小さい通常の値よりも小さいものとして順序付けられます。

したがって、`isless` は、最大値を `NaN` と `missing` とする昇順の全順序を定義し、`isgreater` は、最小値を `NaN` と `missing` とする降順の全順序を定義します。

!!! note
    `min` と同様に、`isgreater` は、コンテナ（タプル、ベクトルなど）を自身で再帰的に順序付けるのではなく、`isless(y, x)` を使って辞書順に順序付けます。

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

これはエクスポートされていません。通常、型がこの関数を実装するべきではありません。代わりに、`isless` を実装してください。
