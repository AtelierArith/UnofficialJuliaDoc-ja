```julia
Base.@acquire s::Semaphore expr
```

`f`関数の代わりに`expr`を使う、`Base.acquire(f, s::Semaphore)`のマクロ版です。次のように展開されます。

```julia
Base.acquire(s)
try
    expr
finally
    Base.release(s)
end
```

[`acquire`](@ref)を`do`ブロックとともに使う方法に似ていますが、クロージャの作成を避けられます。

!!! compat "Julia 1.13"
    `Base.@acquire`はJulia 1.13で追加されました

