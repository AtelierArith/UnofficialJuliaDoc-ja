```
Base.@nospecializeinfer function f(args...)
    @nospecialize ...
    ...
end
Base.@nospecializeinfer f(@nospecialize args...) = ...
```

コンパイラに`@nospecialize`された引数の宣言された型を使用して`f`を推論するよう指示します。これは、推論中にコンパイラ生成の特化の数を制限するために使用できます。

# 例

```julia
julia> f(A::AbstractArray) = g(A)
f (generic function with 1 method)

julia> @noinline Base.@nospecializeinfer g(@nospecialize(A::AbstractArray)) = A[1]
g (generic function with 1 method)

julia> @code_typed f([1.0])
CodeInfo(
1 ─ %1 = invoke Main.g(_2::AbstractArray)::Any
└──      return %1
) => Any
```

この例では、`f`は`A`の各特定の型に対して推論されますが、`g`は宣言された引数型`A::AbstractArray`で一度だけ推論されるため、コンパイラはそれに対して過剰な推論時間を見ない可能性が高く、具体的な戻り値の型を推論できません。`@nospecializeinfer`がなければ、`f([1.0])`は`g`の戻り値の型を`Float64`として推論し、特化コード生成が禁止されているにもかかわらず`g(::Vector{Float64})`のために推論が実行されたことを示します。

!!! compat "Julia 1.10"
    `Base.@nospecializeinfer`を使用するには、Juliaバージョン1.10が必要です。


```
