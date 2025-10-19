```julia
@everywhere [procs()] expr
```

すべての `procs` で `Main` の下で式を実行します。プロセスのいずれかでエラーが発生した場合、それらは [`CompositeException`](@ref) に収集され、スローされます。例えば：

```julia
@everywhere bar = 1
```

はすべての現在のプロセスで `Main.bar` を定義します。後で追加されたプロセス（例えば [`addprocs()`](@ref) を使用して）には、式は定義されません。

[`@spawnat`](@ref) とは異なり、`@everywhere` はローカル変数をキャプチャしません。代わりに、ローカル変数は補間を使用してブロードキャストできます：

```julia
foo = 1
@everywhere bar = $foo
```

オプションの引数 `procs` は、式を実行するプロセスのサブセットを指定することを可能にします。

`remotecall_eval(Main, procs, expr)` を呼び出すのと似ていますが、2つの追加機能があります：

  * `using` と `import` ステートメントは、パッケージが事前コンパイルされることを保証するために、呼び出しプロセスで最初に実行されます。
  * `include` によって使用される現在のソースファイルパスが他のプロセスに伝播されます。
