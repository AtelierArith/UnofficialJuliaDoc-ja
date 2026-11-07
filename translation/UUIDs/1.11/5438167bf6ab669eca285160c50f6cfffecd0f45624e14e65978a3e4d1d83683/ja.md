```julia
uuid4([rng::AbstractRNG])::UUID
```

[RFC 4122](https://tools.ietf.org/html/rfc4122)で規定されている、バージョン4（ランダムまたは疑似ランダム）の汎用一意識別子（UUID）を生成します。

`uuid4`で使用されるデフォルトのrngは`Random.default_rng()`ではありません。引数なしで`uuid4()`を呼び出すたびに、一意の識別子が返されると考えて差し支えありません。重要なのは、`Random.seed!(seed)`を呼び出しても、`uuid4`の出力が重複しないことです。現在（Julia 1.6時点）、`uuid4`はデフォルトのrngとして`Random.RandomDevice`を使用します。ただし、これは実装の詳細であり、将来変更される可能性があります。

!!! compat "Julia 1.6"
    Julia 1.6以降、`uuid4`の出力は`Random.default_rng()`に依存しません。


# Examples

```jldoctest
julia> using Random

julia> rng = Xoshiro(123);

julia> uuid4(rng)
UUID("856e446e-0c6a-472a-9638-f7b8557cd282")
```
