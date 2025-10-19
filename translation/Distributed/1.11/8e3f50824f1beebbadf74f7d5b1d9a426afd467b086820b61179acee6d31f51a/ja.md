```julia
pmap(f, [::AbstractWorkerPool], c...; distributed=true, batch_size=1, on_error=nothing, retry_delays=[], retry_check=nothing) -> collection
```

コレクション `c` を変換し、利用可能なワーカーとタスクを使用して各要素に `f` を適用します。

複数のコレクション引数がある場合、要素ごとに `f` を適用します。

`f` はすべてのワーカープロセスで利用可能でなければなりません。詳細については、[Code Availability and Loading Packages](@ref code-availability) を参照してください。

ワーカープールが指定されていない場合、すべての利用可能なワーカーが [`CachingPool`](@ref) を介して使用されます。

デフォルトでは、`pmap` は指定されたすべてのワーカーに計算を分散します。ローカルプロセスのみを使用し、タスクに分散させるには、`distributed=false` を指定します。これは [`asyncmap`](@ref) を使用するのと同等です。たとえば、`pmap(f, c; distributed=false)` は `asyncmap(f,c; ntasks=()->nworkers())` と同等です。

`pmap` は `batch_size` 引数を介してプロセスとタスクの混合を使用することもできます。バッチサイズが 1 より大きい場合、コレクションは複数のバッチで処理され、各バッチの長さは `batch_size` 以下になります。バッチは、空いているワーカーに対して単一のリクエストとして送信され、ローカルの [`asyncmap`](@ref) が複数の同時タスクを使用してバッチの要素を処理します。

エラーが発生すると、`pmap` はコレクションの残りの部分の処理を停止します。この動作をオーバーライドするには、引数 `on_error` を介してエラーハンドリング関数を指定できます。この関数は単一の引数、すなわち例外を受け取ります。関数はエラーを再スローすることで処理を停止するか、処理を続行するために任意の値を返し、その値は結果とともに呼び出し元に返されます。

次の2つの例を考えてみましょう。最初の例は例外オブジェクトをインラインで返し、2番目は例外の代わりに 0 を返します：

```julia-repl
julia> pmap(x->iseven(x) ? error("foo") : x, 1:4; on_error=identity)
4-element Array{Any,1}:
 1
  ErrorException("foo")
 3
  ErrorException("foo")

julia> pmap(x->iseven(x) ? error("foo") : x, 1:4; on_error=ex->0)
4-element Array{Int64,1}:
 1
 0
 3
 0
```

エラーは、失敗した計算を再試行することで処理することもできます。キーワード引数 `retry_delays` と `retry_check` は、[`retry`](@ref) にキーワード引数 `delays` と `check` として渡されます。バッチ処理が指定されている場合、バッチ全体が失敗した場合、バッチ内のすべてのアイテムが再試行されます。

`on_error` と `retry_delays` の両方が指定されている場合、再試行の前に `on_error` フックが呼び出されることに注意してください。`on_error` が例外をスロー（または再スロー）しない場合、その要素は再試行されません。

例：エラーが発生した場合、要素に対して最大 3 回 `f` を再試行し、再試行の間に遅延を入れない。

```julia
pmap(f, c; retry_delays = zeros(3))
```

例：例外が [`InexactError`](@ref) 型でない場合にのみ `f` を再試行し、最大 3 回まで指数的に増加する遅延を設定します。すべての `InexactError` の発生に対して `NaN` を返します。

```julia
pmap(f, c; on_error = e->(isa(e, InexactError) ? NaN : rethrow()), retry_delays = ExponentialBackOff(n = 3))
```
