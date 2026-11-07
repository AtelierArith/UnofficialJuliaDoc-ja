```julia
@nospecs def
```

`def` の注釈が付いていない引数に、`@nospecialize` の注釈を追加します。

```julia
(Core.Compiler) julia> @macroexpand @nospecs function tfunc(𝕃::AbstractLattice, x, y::Bool, zs...)
                           x, ys
                       end
:(function tfunc($(Expr(:meta, :specialize, :(𝕃::AbstractLattice))), x, y::Bool, zs...)
      #= REPL[3]:1 =#
      $(Expr(:meta, :nospecialize, :x, :zs))
      #= REPL[3]:2 =#
      (x, ys)
  end)
```
