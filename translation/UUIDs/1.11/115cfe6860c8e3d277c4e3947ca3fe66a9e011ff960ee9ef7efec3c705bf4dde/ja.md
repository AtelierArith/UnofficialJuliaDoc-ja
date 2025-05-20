```
uuid1([rng::AbstractRNG]) -> UUID
```

RFC 4122で指定されたバージョン1（時間ベース）のユニバーサルユニーク識別子（UUID）を生成します。ノードIDはRFCのセクション4.5に従ってランダムに生成されるため、ホストを特定するものではありません。

`uuid1`で使用されるデフォルトのrngは`Random.default_rng()`ではなく、引数なしで`uuid1()`を呼び出すたびにユニークな識別子が返されることが期待されます。重要なことに、`uuid1`の出力は、`Random.seed!(seed)`が呼ばれても繰り返されることはありません。現在（Julia 1.6時点）、`uuid1`はデフォルトのrngとして`Random.RandomDevice`を使用しています。ただし、これは将来的に変更される可能性のある実装の詳細です。

!!! compat "Julia 1.6"
    Julia 1.6以降、`uuid1`の出力は`Random.default_rng()`に依存しません。


# 例

```jldoctest; filter = r"[a-z0-9]{8}-([a-z0-9]{4}-){3}[a-z0-9]{12}"
julia> using Random

julia> rng = MersenneTwister(1234);

julia> uuid1(rng)
UUID("cfc395e8-590f-11e8-1f13-43a2532b2fa8")
```
