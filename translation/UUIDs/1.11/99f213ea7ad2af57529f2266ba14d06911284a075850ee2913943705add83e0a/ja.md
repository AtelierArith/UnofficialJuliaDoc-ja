```julia
uuid7([rng::AbstractRNG])::UUID
```

[RFC 9562](https://tools.ietf.org/html/rfc9562)で規定されている、バージョン7の（ランダムまたは疑似ランダムな）汎用一意識別子（UUID）を生成します。

`uuid7`で使われるデフォルトの乱数生成器は`Random.default_rng()`ではありません。引数なしで`uuid7()`を呼び出すたびに、一意な識別子が返されると考えてください。重要なのは、`Random.seed!(seed)`を呼び出しても、`uuid7`の出力が重複しないことです。現在（Julia 1.12時点）、`uuid7`は`Random.RandomDevice`をデフォルトの乱数生成器として使用します。ただし、これは実装の詳細であり、将来変更される可能性があります。

!!! compat "Julia 1.12"
    `uuid7()`はJulia 1.12以降で利用できます。


# Examples

```jldoctest; filter = r"[a-z0-9]{8}-([a-z0-9]{4}-){3}[a-z0-9]{12}"
julia> using Random

julia> rng = Xoshiro(123);

julia> uuid7(rng)
UUID("019026ca-e086-772a-9638-f7b8557cd282")
```
