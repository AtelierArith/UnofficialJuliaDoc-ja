```julia
@invoke f(arg::T, ...; kwargs...)
```

[`invoke`](@ref)を呼び出す便利な方法を提供し、`@invoke f(arg1::T1, arg2::T2; kwargs...)`を`invoke(f, Tuple{T1,T2}, arg1, arg2; kwargs...)`に展開します。引数の型アノテーションが省略されると、その引数の`Core.Typeof`に置き換えられます。引数が型指定されていないか、明示的に`Any`として型指定されているメソッドを呼び出すには、引数に`::Any`でアノテーションを付けます。

以下の構文もサポートしています：

  * `@invoke (x::X).f`は`invoke(getproperty, Tuple{X,Symbol}, x, :f)`に展開されます
  * `@invoke (x::X).f = v::V`は`invoke(setproperty!, Tuple{X,Symbol,V}, x, :f, v)`に展開されます
  * `@invoke (xs::Xs)[i::I]`は`invoke(getindex, Tuple{Xs,I}, xs, i)`に展開されます
  * `@invoke (xs::Xs)[i::I] = v::V`は`invoke(setindex!, Tuple{Xs,V,I}, xs, v, i)`に展開されます

# 例

```jldoctest
julia> @macroexpand @invoke f(x::T, y)
:(Core.invoke(f, Tuple{T, Core.Typeof(y)}, x, y))

julia> @invoke 420::Integer % Unsigned
0x00000000000001a4

julia> @macroexpand @invoke (x::X).f
:(Core.invoke(Base.getproperty, Tuple{X, Core.Typeof(:f)}, x, :f))

julia> @macroexpand @invoke (x::X).f = v::V
:(Core.invoke(Base.setproperty!, Tuple{X, Core.Typeof(:f), V}, x, :f, v))

julia> @macroexpand @invoke (xs::Xs)[i::I]
:(Core.invoke(Base.getindex, Tuple{Xs, I}, xs, i))

julia> @macroexpand @invoke (xs::Xs)[i::I] = v::V
:(Core.invoke(Base.setindex!, Tuple{Xs, V, I}, xs, v, i))
```

!!! compat "Julia 1.7"
    このマクロはJulia 1.7以降が必要です。


!!! compat "Julia 1.9"
    このマクロはJulia 1.9以降でエクスポートされます。


!!! compat "Julia 1.10"
    追加の構文はJulia 1.10以降でサポートされています。

