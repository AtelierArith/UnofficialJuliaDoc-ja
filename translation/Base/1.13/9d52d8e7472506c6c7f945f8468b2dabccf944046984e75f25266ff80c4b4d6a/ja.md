```julia
Base.showarg(io::IO, x, toplevel)
```

`x`の準型を表示します。準型とは、`x`の型、または`x`と同じ型のオブジェクトを生成する式（準型を含む場合もあります）です。通常は、この2つのうち短い方が使われます。

この関数は、オブジェクトに対する関数呼び出しの列として型情報を表示するために、`summary`によって使われます。

型を表示する際、`toplevel`が`false`の場合は、先頭に`::`を表示します。`toplevel`は、`summary`からの直接の呼び出しでは`true`、入れ子になった（再帰的な）呼び出しでは`false`です。

フォールバック定義では、引数`x`をその型で表すため、`x`を「::``(typeof(x))" or "``(typeof(x))」として出力します。ただし、特定の型に対してこの関数を特殊化し、表示をカスタマイズできます。このカスタマイズは、単純で公開されたコンストラクターを持つ一方、型や型パラメーターが冗長または内部的な型（`reinterpret`化配列や`SubArray`など）に便利です。

# Examples

`a`が3次元のFloat64配列であるとき、`view(a, :, 3, 2:5)`として作成されたSubArrayの型は次のとおりです。

```julia
SubArray{Float64, 2, Array{Float64, 3}, Tuple{Colon, Int64, UnitRange{Int64}}, false}
```

デフォルトの`show`による表示では、この完全な型が出力されます。しかし、SubArrayの概要は実際には次のように表示されます。

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

親配列の型に対して`showarg`を再帰的に呼び出している点に注意してください。これは、再帰呼び出しがトップレベルではないことを示します。親を`::Array{Float64,3}`として表示するのは、トップレベル以外でのフォールバック動作です。`Array`に対する特殊化メソッドが定義されていないためです。
