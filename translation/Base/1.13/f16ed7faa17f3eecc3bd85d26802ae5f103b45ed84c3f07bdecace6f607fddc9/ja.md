```julia
Base.@nospecializeinfer function f(args...)
    @nospecialize ...
    ...
end
Base.@nospecializeinfer f(@nospecialize args...) = ...
```

コンパイラーに、`@nospecialize`d 引数の宣言型を使って `f` を推論するよう指示します。推論時にコンパイラーが生成する特殊化の数を制限するために使用できます。

# Examples

```jldoctest; setup = :(using InteractiveUtils)
julia> f(A::AbstractArray) = g(A)
f (generic function with 1 method)

julia> @noinline Base.@nospecializeinfer g(@nospecialize(A::AbstractArray)) = A[1]
g (generic function with 1 method)

julia> @code_typed f([1.0])
CodeInfo(
1 ─ %1 =    invoke g(A::AbstractArray)::Any
└──      return %1
) => Any
```

この例では、`f` は `A` の具体的な型ごとに推論されますが、`g` は、宣言された引数型 `A::AbstractArray` を使って一度だけ推論されます。そのため、具体的な戻り値の型を推論できない場合でも、コンパイラーで過剰な推論時間が発生する可能性は低くなります。`@nospecializeinfer` がない場合、`f([1.0])` は `g` の戻り値の型を `Float64` と推論します。これは、特殊化されたコードの生成が禁止されているにもかかわらず、`g(::Vector{Float64})` に対して推論が実行されたことを示しています。

!!! compat "Julia 1.10"
    `Base.@nospecializeinfer` を使用するには、Julia 1.10 が必要です。

