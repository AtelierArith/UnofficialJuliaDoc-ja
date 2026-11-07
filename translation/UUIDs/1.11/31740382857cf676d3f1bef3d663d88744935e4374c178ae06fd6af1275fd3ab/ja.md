```julia
uuid1([rng::AbstractRNG])::UUID
```

[RFC 4122](https://tools.ietf.org/html/rfc4122)で規定されている、バージョン1（時刻ベース）の汎用一意識別子（UUID）を生成します。RFCのセクション4.5に従い、ノードIDはランダムに生成されます（ホストを識別するものではありません）。

`uuid1`で使用されるデフォルトのrngは`Random.default_rng()`ではないため、引数なしで`uuid1()`を呼び出すたびに、一意の識別子が返されると考えて差し支えありません。重要なのは、`Random.seed!(seed)`を呼び出しても、`uuid1`の出力が重複しないことです。現在（Julia 1.6時点）、`uuid1`はデフォルトのrngとして`Random.RandomDevice`を使用します。ただし、これは実装の詳細であり、将来変更される可能性があります。

!!! compat "Julia 1.6"
    Julia 1.6以降、`uuid1`の出力は`Random.default_rng()`に依存しません。


# Examples

```jldoctest; filter = r"[a-z0-9]{8}-([a-z0-9]{4}-){3}[a-z0-9]{12}"
julia> using Random

julia> rng = MersenneTwister(1234);

julia> uuid1(rng)
UUID("cfc395e8-590f-11e8-1f13-43a2532b2fa8")
```
