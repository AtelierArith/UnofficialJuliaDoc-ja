```julia
asyncmap(f, c...; ntasks=0, batch_size=nothing)
```

コレクション（または複数の同じ長さのコレクション）に対して、複数の並行タスクを使って `f` を適用します。複数のコレクションを引数に指定した場合、`f` は要素ごとに適用されます。

出力の順序は、コレクションの要素の順序 `c` と同じになることが保証されています。

`ntasks` は、同時に実行するタスク数を指定します。コレクションの長さに応じて、`ntasks` が指定されていない場合、並行マッピングには最大100個のタスクが使用されます。

`ntasks` には、引数を取らない関数を指定することもできます。この場合、各要素の処理前に並列実行するタスク数が確認され、`ntasks_func` の値が現在のタスク数を上回ると、新しいタスクが開始されます。

`batch_size` を指定すると、コレクションはバッチモードで処理されます。この場合、`f` は、引数タプルの `Vector` を受け取り、結果のベクトルを返す関数でなければなりません。入力ベクトルの長さは `batch_size` 以下です。

以下の例では、マッピング関数が実行されたタスクの `objectid` を返すことで、異なるタスクでの実行を示します。

まず、`ntasks` が未定義の場合、各要素はそれぞれ異なるタスクで処理されます。

```julia-repl
julia> tskoid() = objectid(current_task());

julia> asyncmap(x->tskoid(), 1:5)
5-element Vector{UInt64}:
 0x6e15e66c75c75853
 0x440f8819a1baa682
 0x9fb3eeadd0c83985
 0xebd3e35fe90d4050
 0x29efc93edce2b961

julia> length(unique(asyncmap(x->tskoid(), 1:5)))
5
```

`ntasks=2` を指定すると、すべての要素が2つのタスクで処理されます。

```julia-repl
julia> asyncmap(x->tskoid(), 1:5; ntasks=2)
5-element Vector{UInt64}:
 0x027ab1680df7ae94
 0xa23d2f80cd7cf157
 0x027ab1680df7ae94
 0xa23d2f80cd7cf157
 0x027ab1680df7ae94

julia> length(unique(asyncmap(x->tskoid(), 1:5; ntasks=2)))
2
```

`batch_size` を定義した場合、マッピング関数は引数タプルの配列を受け取り、結果の配列を返すように変更する必要があります。変更後のマッピング関数では、これを実現するために `map` を使用します。

```julia-repl
julia> batch_func(input) = map(x->string("args_tuple: ", x, ", element_val: ", x[1], ", task: ", tskoid()), input)
batch_func (generic function with 1 method)

julia> asyncmap(batch_func, 1:5; ntasks=2, batch_size=2)
5-element Vector{String}:
 "args_tuple: (1,), element_val: 1, task: 9118321258196414413"
 "args_tuple: (2,), element_val: 2, task: 4904288162898683522"
 "args_tuple: (3,), element_val: 3, task: 9118321258196414413"
 "args_tuple: (4,), element_val: 4, task: 4904288162898683522"
 "args_tuple: (5,), element_val: 5, task: 9118321258196414413"
```
