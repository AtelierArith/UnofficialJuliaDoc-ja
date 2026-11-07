```julia
promote_op(f, argtypes...)
```

`f(::argtypes...)` の結果を格納するのに適切なコンテナの要素型を推測します。この推測は型推論に一部基づいているため、いつでも変わる可能性があります。

したがって、次の条件を満たす型 `R` を返します。`f(args...) isa R` であり、`args isa T` であることです。

!!! warning
    脆弱な仕組みであるため、`promote_op` の使用は避けてください。コンテナの要素型は、実際の要素の型に基づいて決めるのが望ましいです。要素が存在しない場合（結果コンテナが空の場合）に限り、`promote_op` の呼び出しが避けられないことがあります。


`promote_op` から得られる型 `R` は、単なる上限にすぎません。より厳密な型 `S` が存在し、`S <: R` および `S != R` を満たすすべての `args isa T` について、`f(args...) isa S` となる場合があります。さらに、`promote_op` から得られる正確な型 `R` は、使用する Julia のバージョン、読み込まれているパッケージ、コマンドラインオプションなど、さまざまな要因によって異なります。そのため、公開登録されているパッケージでは、`promote_op` から得られる正確な型 `R` に、パッケージが提供する API の保証が依存しないようにする責任は、パッケージ作者にあります。

また、結果として `DataType`、`Type`、`Union{...}` など、必要以上に具体的な型が返されることがありますが、入力や出力には別の型が望ましい場合もあります。このような場合には、内部関数 `promote_typejoin_union` を使うと、結果を改善できることがあります。

# Extended help

## Examples

次の関数は、`promote_op` の不適切な使用例です。

```julia
"""
    invalid_usecase1(f, xs::AbstractArray) -> ys::Array

Return an array `ys` such that `vec(ys)` is `isequal`-equivalent to

    [f(xs[1]), f(xs[2]), ..., f(xs[end])]
"""
function invalid_usecase1(f, xs)
    R = promote_op(f, eltype(xs))
    ys = similar(xs, R)
    for i in eachindex(xs, ys)
        ys[i] = f(xs[i])
    end
    return ys
end
```

これは、`eltype(invalid_usecase1(f, xs))` で得られる値が、`promote_op` が何を返すかに正確に依存するためです。結果を返す前に要素型を再計算すれば、改善できます。

```julia
function valid_usecase1(f, xs)
    R = promote_typejoin_union(promote_op(f, eltype(xs)))
    ys = similar(xs, R)
    S = Union{}
    for i in eachindex(xs, ys)
        ys[i] = f(xs[i])
        S = promote_type(S, typeof(ys[i]))
    end
    if S != R
        zs = similar(xs, S)
        copyto!(zs, ys)
        return zs
    end
    return ys
end
```

結果に対して [`isconcretetype`](@ref) を使うだけでは、`promote_op` を安全に使うには不十分です。次の関数も、`promote_op` の不適切な使用例です。

```julia
function invalid_usecase2(f, xs)
    R = promote_op(f, eltype(xs))
    if isconcretetype(R)
        ys = similar(xs, R)
    else
        ys = similar(xs, Any)
    end
    for i in eachindex(xs, ys)
        ys[i] = f(xs[i])
    end
    return ys
end
```

呼び出し元が `Any` の要素型を得られるかどうかは、`promote_op` が指定された関数の具体的な戻り値型を推論できるかどうかに依存するためです。`valid_usecase1` と同様の修正を適用できます。

*技術的には*、`invalid_usecase1` と `invalid_usecase2` に対する別の修正方法として、API の保証を緩和することもできます。

> ```
> another_valid_usecase1(f, xs::AbstractArray) -> ys::Array
> ```
>
> 配列 `ys` を返します。この配列では、`xs` の各要素が、同じインデックスにある要素と `f` によって対応付けられます。
>
> `ys` の要素型は*未定義*です。`ys` の要素型に依存する動作をする汎用関数に渡してはなりません。


ただし、このような慣例に反する API の保証を定義することは推奨されません。
