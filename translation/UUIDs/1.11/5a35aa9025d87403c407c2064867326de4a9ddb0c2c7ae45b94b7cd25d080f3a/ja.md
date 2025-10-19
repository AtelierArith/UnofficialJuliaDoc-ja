```julia
uuid7([rng::AbstractRNG]) -> UUID
```

バージョン7（ランダムまたは擬似ランダム）のユニバーサルユニーク識別子（UUID）を生成します。これは[RFC 9562](https://tools.ietf.org/html/rfc9562)で指定されています。

`uuid7`で使用されるデフォルトのrngは`Random.default_rng()`ではなく、引数なしで`uuid7()`を呼び出すたびにユニークな識別子が返されることが期待されます。重要なことに、`uuid7`の出力は、`Random.seed!(seed)`が呼ばれても繰り返されることはありません。現在（Julia 1.12時点）、`uuid7`はデフォルトのrngとして`Random.RandomDevice`を使用しています。ただし、これは将来的に変更される可能性のある実装の詳細です。

!!! compat "Julia 1.12"
    `uuid7()`はJulia 1.12以降で利用可能です。


# 例

```jldoctest; filter = r"[a-z0-9]{8}-([a-z0-9]{4}-){3}[a-z0-9]{12}"
julia> using Random

julia> rng = Xoshiro(123);

julia> uuid7(rng)
UUID("019026ca-e086-772a-9638-f7b8557cd282")
```
