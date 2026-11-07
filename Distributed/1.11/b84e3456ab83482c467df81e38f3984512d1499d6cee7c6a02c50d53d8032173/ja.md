```julia
@everywhere [procs()] expr
```

`Main` の式を、すべての `procs` 上で実行します。いずれかのプロセスで発生したエラーは [`CompositeException`](@ref) にまとめられ、スローされます。たとえば、次のようにします。

```julia
@everywhere bar = 1
```

これにより、現在のすべてのプロセスで `Main.bar` が定義されます。後から追加されたプロセス（たとえば [`addprocs()`](@ref)）では、この式は定義されません。

[`@spawnat`](@ref) とは異なり、`@everywhere` はローカル変数をキャプチャしません。代わりに、補間を使ってローカル変数をブロードキャストできます。

```julia
foo = 1
@everywhere bar = $foo
```

省略可能な引数 `procs` を指定すると、式を実行するプロセスを全プロセスの一部に限定できます。

`remotecall_eval(Main, procs, expr)` の呼び出しと同様ですが、次の2つの機能が追加されています。

  * `using` 文と `import` 文は、パッケージが事前コンパイルされるよう、まず呼び出し元のプロセスで実行されます。
  * `include` が使用する現在のソースファイルのパスが、他のプロセスにも引き継がれます。
