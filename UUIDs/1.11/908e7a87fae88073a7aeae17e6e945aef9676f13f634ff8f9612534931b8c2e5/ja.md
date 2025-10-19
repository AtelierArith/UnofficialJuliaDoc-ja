```julia
uuid4([rng::AbstractRNG]) -> UUID
```

バージョン4（ランダムまたは擬似ランダム）のユニバーサルユニーク識別子（UUID）を生成します。これは[RFC 4122](https://tools.ietf.org/html/rfc4122)で指定されています。

`uuid4`で使用されるデフォルトのrngは`Random.default_rng()`ではなく、引数なしで`uuid4()`を呼び出すたびにユニークな識別子が返されることが期待されます。重要なことに、`uuid4`の出力は`Random.seed!(seed)`が呼ばれても繰り返されることはありません。現在（Julia 1.6時点）、`uuid4`はデフォルトのrngとして`Random.RandomDevice`を使用しています。ただし、これは将来的に変更される可能性のある実装の詳細です。

!!! compat "Julia 1.6"
    `uuid4`の出力は、Julia 1.6時点では`Random.default_rng()`に依存しません。


# 例

```jldoctest
julia> using Random

julia> rng = Xoshiro(123);

julia> uuid4(rng)
UUID("856e446e-0c6a-472a-9638-f7b8557cd282")
```
