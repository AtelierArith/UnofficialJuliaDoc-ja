```julia
pmap(f, [::AbstractWorkerPool], c...; distributed=true, batch_size=1, on_error=nothing, retry_delays=[], retry_check=nothing) -> collection
```

コレクション `c` の各要素に `f` を適用し、利用可能なワーカーとタスクを使って変換します。

複数のコレクションを引数に指定した場合は、要素ごとに `f` を適用します。

`f` はすべてのワーカープロセスで利用できるようにする必要があります。詳しくは [Code Availability and Loading Packages](@ref code-availability) を参照してください。

ワーカープールを指定しない場合は、[`CachingPool`](@ref) を介して、利用可能なすべてのワーカーが使用されます。

デフォルトでは、`pmap` は指定されたすべてのワーカーに計算を分散します。ローカルプロセスのみを使い、タスクに分散させるには、`distributed=false` を指定します。これは [`asyncmap`](@ref) を使うのと同じです。たとえば、`pmap(f, c; distributed=false)` は `asyncmap(f,c; ntasks=()->nworkers())` と同じです。

`pmap` では、`batch_size` 引数を使って、プロセスとタスクを組み合わせることもできます。バッチサイズが 1 より大きい場合、コレクションは複数のバッチに分けて処理されます。各バッチの長さは `batch_size` 以下です。バッチは単一のリクエストとして空いているワーカーに送られ、そのワーカー上のローカルな [`asyncmap`](@ref) が、複数の並行タスクを使ってバッチ内の要素を処理します。

エラーが発生すると、`pmap` はコレクションの残りの処理を中止します。この動作を変更するには、引数 `on_error` でエラー処理関数を指定します。この関数は例外を単一の引数として受け取ります。エラーを再スローすると処理を中止でき、任意の値を返すと処理を続行できます。返された値は、結果に含めて呼び出し元に返されます。

次の 2 つの例を見てください。1 つ目は例外オブジェクトを結果に含めて返し、2 つ目は例外の代わりに 0 を返します。

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

失敗した計算を再試行することで、エラーを処理することもできます。キーワード引数 `retry_delays` と `retry_check` は、それぞれキーワード引数 `delays` と `check` として [`retry`](@ref) に渡されます。バッチ処理を指定してバッチ全体が失敗した場合は、そのバッチ内のすべての項目が再試行されます。

`on_error` と `retry_delays` の両方を指定した場合、再試行の前に `on_error` フックが呼び出されることに注意してください。`on_error` が例外をスロー（または再スロー）しない場合、その要素は再試行されません。

例：エラーが発生した場合、要素に対する `f` を、再試行の間隔を空けずに最大 3 回再試行します。

```julia
pmap(f, c; retry_delays = zeros(3))
```

例：例外が [`InexactError`](@ref) 型でない場合に限り `f` を再試行し、間隔を指数関数的に延ばしながら最大 3 回再試行します。すべての `InexactError` の箇所では、代わりに `NaN` を返します。

```julia
pmap(f, c; on_error = e->(isa(e, InexactError) ? NaN : rethrow()), retry_delays = ExponentialBackOff(n = 3))
```
