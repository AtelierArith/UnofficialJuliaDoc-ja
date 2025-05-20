```
@spawn expr
```

式の周りにクロージャを作成し、自動的に選択されたプロセスで実行し、結果への[`Future`](@ref)を返します。このマクロは非推奨です; 代わりに`@spawnat :any expr`を使用するべきです。

# 例

```julia-repl
julia> addprocs(3);

julia> f = @spawn myid()
Future(2, 1, 5, nothing)

julia> fetch(f)
2

julia> f = @spawn myid()
Future(3, 1, 7, nothing)

julia> fetch(f)
3
```

!!! compat "Julia 1.3"
    Julia 1.3以降、このマクロは非推奨です。代わりに`@spawnat :any`を使用してください。

