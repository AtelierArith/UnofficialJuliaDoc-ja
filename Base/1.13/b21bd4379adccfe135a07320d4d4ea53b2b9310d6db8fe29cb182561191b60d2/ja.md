```julia
@nospecialize
```

関数の引数名に適用すると、その引数の型ごとにメソッド実装を特殊化せず、宣言された引数の型を使うようコンパイラーに指示します。仮引数リスト内の引数にも、関数本体内にも適用できます。引数に適用する場合、マクロは引数名だけでなく、引数式全体を囲む必要があります。たとえば、`@nospecialize(x::Real)` や `@nospecialize(i::Integer...)` のようにします。関数本体内で使う場合は、マクロを文の位置に置き、ほかのコードより前に記述する必要があります。

引数なしで使うと、親スコープ内のすべての引数に適用されます。ローカルスコープでは、これにより包含する関数のすべての引数が対象になります。グローバル（トップレベル）スコープでは、現在のモジュールで以降に定義されるすべてのメソッドが対象になります。

[`@specialize`](@ref) を使うと、特殊化をデフォルトの状態に戻せます。

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
    `@nospecialize` はコード生成に影響しますが、推論には影響しません。生成されるネイティブコードの多様性は制限されますが、型推論には（標準的な制限を除き）制約を課しません。推論も抑制するには、[`Base.@nospecializeinfer`](@ref) と `@nospecialize` を併用してください。


# Examples

```jldoctest; setup = :(using InteractiveUtils)
julia> f(A::AbstractArray) = g(A)
f (generic function with 1 method)

julia> @noinline g(@nospecialize(A::AbstractArray)) = A[1]
g (generic function with 1 method)

julia> @code_typed f([1.0])
CodeInfo(
1 ─ %1 =    invoke g(A::AbstractArray)::Float64
└──      return %1
) => Float64
```

ここでは、`@nospecialize` アノテーションにより、次と同等の処理が行われます。

```julia
f(A::AbstractArray) = invoke(g, Tuple{AbstractArray}, A)
```

これにより、`g` に対して生成されるネイティブコードは1種類だけとなり、あらゆる `AbstractArray` に対応する汎用的なものになります。ただし、`g` と `f` のどちらについても、具体的な戻り値の型は引き続き推論されます。また、その推論結果は `f` と `g` の呼び出し元を最適化する際にも引き続き使われます。
