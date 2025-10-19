```julia
@spawnat p expr
```

式の周りにクロージャを作成し、プロセス `p` で非同期にクロージャを実行します。結果への [`Future`](@ref) を返します。

`p` が引用されたリテラルシンボル `:any` の場合、システムは自動的に使用するプロセッサを選択します。`:any` を使用すると、負荷分散は適用されないため、負荷分散が必要な場合は [`WorkerPool`](@ref) と [`remotecall(f, ::WorkerPool)`](@ref) の使用を検討してください。

# 例

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
    `:any` 引数は Julia 1.3 以降で利用可能です。

