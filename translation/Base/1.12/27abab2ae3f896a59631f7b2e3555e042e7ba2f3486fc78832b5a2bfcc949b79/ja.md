```julia
@nospecialize
```

関数引数名に適用されると、コンパイラに対してその引数の異なる型に対してメソッド実装を特化させず、代わりにその引数の宣言された型を使用するようにヒントを与えます。これは、形式的な引数リスト内の引数や関数本体内の引数に適用できます。引数に適用される場合、マクロは引数の全体の式をラップする必要があります。例えば、`@nospecialize(x::Real)`や`@nospecialize(i::Integer...)`のように、引数名だけをラップするのではありません。関数本体で使用される場合、マクロは文の位置にあり、任意のコードの前に出現する必要があります。

引数なしで使用されると、親スコープのすべての引数に適用されます。ローカルスコープでは、これは含まれる関数のすべての引数を意味します。グローバル（トップレベル）スコープでは、これは現在のモジュールでその後に定義されるすべてのメソッドを意味します。

特化は、[`@specialize`](@ref)を使用することでデフォルトにリセットできます。

```julia
function example_function(@nospecialize x)
    ...
end

function example_function(x, @nospecialize(y = 1))
    ...
end

function example_function(x, y, z)
    @nospecialize x y
    ...
end

@nospecialize
f(y) = [x for x in y]
@specialize
```

!!! note
    `@nospecialize`はコード生成に影響を与えますが、推論には影響を与えません：生成されるネイティブコードの多様性を制限しますが、型推論に対しては（標準的な制限を超えて）制限を課しません。推論を追加で抑制するために、`@nospecialize`と一緒に[`Base.@nospecializeinfer`](@ref)を使用してください。


# 例

```julia-repl
julia> f(A::AbstractArray) = g(A)
f (generic function with 1 method)

julia> @noinline g(@nospecialize(A::AbstractArray)) = A[1]
g (generic function with 1 method)

julia> @code_typed f([1.0])
CodeInfo(
1 ─ %1 = invoke Main.g(_2::AbstractArray)::Float64
└──      return %1
) => Float64
```

ここで、`@nospecialize`アノテーションは次のように等価になります。

```julia
f(A::AbstractArray) = invoke(g, Tuple{AbstractArray}, A)
```

これにより、`g`のためにネイティブコードの1つのバージョンのみが生成されることが保証され、これは任意の`AbstractArray`に対して一般的なものです。しかし、特定の戻り値の型は、`g`と`f`の両方に対して依然として推論され、これは`f`と`g`の呼び出し元の最適化に使用されます。
