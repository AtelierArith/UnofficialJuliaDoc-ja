```julia
@invoke f(arg::T, ...; kwargs...)
```

[`invoke`](@ref) を、`@invoke f(arg1::T1, arg2::T2; kwargs...)` を `invoke(f, Tuple{T1,T2}, arg1, arg2; kwargs...)` に展開して呼び出すための便利な方法を提供します。引数の型注釈を省略すると、その引数は `Core.Typeof` に置き換えられます。引数が型指定されていないメソッド、または明示的に `Any` として型指定されたメソッドを呼び出すには、引数に `::Any` と注釈を付けます。

次の構文にも対応しています。

  * `@invoke (x::X).f` は `invoke(getproperty, Tuple{X,Symbol}, x, :f)` に展開されます
  * `@invoke (x::X).f = v::V` は `invoke(setproperty!, Tuple{X,Symbol,V}, x, :f, v)` に展開されます
  * `@invoke (xs::Xs)[i::I]` は `invoke(getindex, Tuple{Xs,I}, xs, i)` に展開されます
  * `@invoke (xs::Xs)[i::I] = v::V` は `invoke(setindex!, Tuple{Xs,V,I}, xs, v, i)` に展開されます

# Examples

```jldoctest
julia> @macroexpand @invoke f(x::T, y)
:(Core.invoke(f, Base.Tuple{T, Core.Typeof(y)}, x, y))

julia> @invoke 420::Integer % Unsigned
0x00000000000001a4

julia> @macroexpand @invoke (x::X).f
:(Core.invoke(Base.getproperty, Base.Tuple{X, Core.Typeof(:f)}, x, :f))

julia> @macroexpand @invoke (x::X).f = v::V
:(Core.invoke(Base.setproperty!, Base.Tuple{X, Core.Typeof(:f), V}, x, :f, v))

julia> @macroexpand @invoke (xs::Xs)[i::I]
:(Core.invoke(Base.getindex, Base.Tuple{Xs, I}, xs, i))

julia> @macroexpand @invoke (xs::Xs)[i::I] = v::V
:(Core.invoke(Base.setindex!, Base.Tuple{Xs, V, I}, xs, v, i))
```

!!! compat "Julia 1.7"
    このマクロを使用するには、Julia 1.7 以降が必要です。


!!! compat "Julia 1.9"
    このマクロは Julia 1.9 以降でエクスポートされます。


!!! compat "Julia 1.10"
    追加の構文は Julia 1.10 以降でサポートされます。

