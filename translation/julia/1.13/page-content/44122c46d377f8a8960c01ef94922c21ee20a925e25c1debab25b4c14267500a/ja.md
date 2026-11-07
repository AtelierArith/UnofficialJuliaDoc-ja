# Talking to the compiler (the `:meta` mechanism)

状況によっては、あるコードブロックに特別な性質があることを示すヒントや指示を与えたい場合があります。たとえば、常にインライン展開したい場合や、特別なコンパイラ最適化パスを有効にしたい場合です。Julia 0.4 以降では、こうした指示を `:meta` 式の中に記述する慣例があります。この式は通常、関数本体の最初の式ですが、必ずしもそうとは限りません。

`:meta` 式はマクロで作成します。例として、`@inline` マクロの実装を見てみましょう。

```julia
macro inline(ex)
    esc(isa(ex, Expr) ? pushmeta!(ex, :inline) : ex)
end
```

ここでは、`ex` は関数を定義する式であることが想定されています。次のような文は、

```julia
@inline function myfunction(x)
    x*(x+3)
end
```

次のような式に変換されます。

```julia
quote
    function myfunction(x)
        Expr(:meta, :inline)
        x*(x+3)
    end
end
```

`Base.pushmeta!(ex, tag::Union{Symbol,Expr})` は、`:meta` 式の末尾に `:tag` を追加します。必要に応じて、新しい `:meta` 式を作成します。

メタデータを利用するには、これらの `:meta` 式を解析する必要があります。Julia 内で実装できる場合は、`Base.popmeta!` が非常に便利です。`Base.popmeta!(body, :symbol)` は、関数の *本体* の式（関数シグネチャを含まないもの）を走査し、`:symbol` を含む最初の `:meta` 式を探します。引数があれば取り出し、タプル `(found::Bool, args::Array{Any})` を返します。メタデータに引数がない場合、または `:symbol` が見つからない場合、`args` 配列は空になります。

C++ から `:meta` 式を解析するための便利な仕組みは、まだ用意されていません。
