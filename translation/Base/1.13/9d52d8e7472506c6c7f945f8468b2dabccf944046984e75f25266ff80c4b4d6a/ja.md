```julia
Base.showarg(io::IO, x, toplevel)
```

`x`の準型を表示します。ここで準型とは、`x`の型、または`x`と同じ型のオブジェクトを生成する式（準型を含む場合もあります）を指します。通常は、これら2つの選択肢のうち短い方を使います。

この関数は、オブジェクトに対する関数呼び出しの列として型情報を表示するために、`summary`で使われます。

`toplevel`が`false`で、型を表示する場合は、先頭に`::`を付けます。`toplevel`は、`summary`からの直接の呼び出しでは`true`、入れ子になった（再帰的な）呼び出しでは`false`です。

フォールバック定義では、引数`x`をその型で表すため、`x`を「::``(typeof(x))" or "``(typeof(x))」として出力します。ただし、特定の型に対してこの関数を特殊化し、出力をカスタマイズできます。このカスタマイズは、単純で公開されたコンストラクターを持つ一方、型や型パラメーターが冗長または内部的な型に便利です。たとえば、`reinterpret`化された配列や`SubArray`などが該当します。

# Examples

`a`が3次元のFloat64配列であるとき、`view(a, :, 3, 2:5)`として作成されたSubArrayの型は次のとおりです。

```julia
SubArray{Float64, 2, Array{Float64, 3}, Tuple{Colon, Int64, UnitRange{Int64}}, false}
```

デフォルトの`show`出力では、この型全体が表示されます。しかし、SubArrayの概要は実際には次のように表示されます。

```julia
2×4 view(::Array{Float64, 3}, :, 3, 2:5) with eltype Float64
```

これは、次のような定義によるものです。

```julia
function Base.showarg(io::IO, v::SubArray, toplevel)
    print(io, "view(")
    showarg(io, parent(v), false)
    print(io, ", ", join(v.indices, ", "))
    print(io, ')')
    toplevel && print(io, " with eltype ", eltype(v))
end
```

親配列の型に対して`showarg`を再帰的に呼び出している点に注意してください。これは、再帰呼び出しがトップレベルではないことを示しています。親を`::Array{Float64,3}`として出力するのは、フォールバック（非トップレベル）の動作です。`Array`に対する特殊化メソッドが定義されていないためです。
