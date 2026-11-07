```julia
@spawnat p expr
```

式をクロージャで囲み、そのクロージャをプロセス `p` 上で非同期に実行します。結果への [`Future`](@ref) を返します。

`p` が引用符で囲まれたリテラルシンボル `:any` の場合、システムが使用するプロセッサを自動的に選択します。`:any` では負荷分散は行われません。負荷分散が必要な場合は、[`WorkerPool`](@ref) と [`remotecall(f, ::WorkerPool)`](@ref) の使用を検討してください。

# Examples

```julia-repl
julia> addprocs(3);

julia> f = @spawnat 2 myid()
Future(2, 1, 3, nothing)

julia> fetch(f)
2

julia> f = @spawnat :any myid()
Future(3, 1, 7, nothing)

julia> fetch(f)
3
```

!!! compat "Julia 1.3"
    `:any` 引数は Julia 1.3 以降で使用できます。

