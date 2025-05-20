```
@invokelatest f(args...; kwargs...)
```

[`invokelatest`](@ref)を呼び出すための便利な方法を提供します。`@invokelatest f(args...; kwargs...)`は単に`Base.invokelatest(f, args...; kwargs...)`に展開されます。

以下の構文もサポートしています：

  * `@invokelatest x.f`は`Base.invokelatest(getproperty, x, :f)`に展開されます
  * `@invokelatest x.f = v`は`Base.invokelatest(setproperty!, x, :f, v)`に展開されます
  * `@invokelatest xs[i]`は`Base.invokelatest(getindex, xs, i)`に展開されます
  * `@invokelatest xs[i] = v`は`Base.invokelatest(setindex!, xs, v, i)`に展開されます

```jldoctest
julia> @macroexpand @invokelatest f(x; kw=kwv)
:(Base.invokelatest(f, x; kw = kwv))

julia> @macroexpand @invokelatest x.f
:(Base.invokelatest(Base.getproperty, x, :f))

julia> @macroexpand @invokelatest x.f = v
:(Base.invokelatest(Base.setproperty!, x, :f, v))

julia> @macroexpand @invokelatest xs[i]
:(Base.invokelatest(Base.getindex, xs, i))

julia> @macroexpand @invokelatest xs[i] = v
:(Base.invokelatest(Base.setindex!, xs, v, i))
```

!!! compat "Julia 1.7"
    このマクロはJulia 1.7以降が必要です。


!!! compat "Julia 1.9"
    Julia 1.9以前は、このマクロはエクスポートされておらず、`Base.@invokelatest`として呼び出されていました。


!!! compat "Julia 1.10"
    追加の`x.f`および`xs[i]`構文はJulia 1.10が必要です。

