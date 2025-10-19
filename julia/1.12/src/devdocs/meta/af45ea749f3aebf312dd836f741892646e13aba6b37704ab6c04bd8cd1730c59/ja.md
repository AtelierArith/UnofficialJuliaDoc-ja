# Talking to the compiler (the `:meta` mechanism)

特定の状況では、特定のコードブロックが特別な特性を持っていることを示すヒントや指示を提供したい場合があります。常にインライン化したい場合や、特別なコンパイラ最適化パスを有効にしたい場合などです。バージョン0.4以降、Juliaにはこれらの指示を `:meta` 式の中に置くという慣習があります。これは通常（必ずしもそうではありませんが）関数の本体の最初の式です。

`:meta` 表現はマクロを使って作成されます。例として、`@inline` マクロの実装を考えてみましょう：

```julia
macro inline(ex)
    esc(isa(ex, Expr) ? pushmeta!(ex, :inline) : ex)
end
```

ここで、`ex` は関数を定義する式であることが期待されています。このような文：

```julia
@inline function myfunction(x)
    x*(x+3)
end
```

このような表現に変わります：

```julia
quote
    function myfunction(x)
        Expr(:meta, :inline)
        x*(x+3)
    end
end
```

`Base.pushmeta!(ex, tag::Union{Symbol,Expr})` は `:meta` 式の末尾に `:tag` を追加し、必要に応じて新しい `:meta` 式を作成します。

メタデータを使用するには、これらの `:meta` 表現を解析する必要があります。実装がJulia内で行える場合、`Base.popmeta!` は非常に便利です： `Base.popmeta!(body, :symbol)` は関数の *body* 表現（関数シグネチャのないもの）をスキャンし、最初の `:meta` 表現を含む `:symbol` を探し、引数を抽出してタプル `(found::Bool, args::Array{Any})` を返します。メタデータに引数がなかった場合、または `:symbol` が見つからなかった場合、`args` 配列は空になります。

まだ提供されていないのは、C++から`:meta`式を解析するための便利なインフラストラクチャです。
