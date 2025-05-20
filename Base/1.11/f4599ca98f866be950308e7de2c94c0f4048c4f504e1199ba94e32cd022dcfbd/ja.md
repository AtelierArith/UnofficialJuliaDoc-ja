```
asyncmap(f, c...; ntasks=0, batch_size=nothing)
```

複数の同時タスクを使用して、コレクション（または複数の同じ長さのコレクション）に対して `f` をマッピングします。複数のコレクション引数がある場合、`f` は要素ごとに適用されます。

`ntasks` は同時に実行するタスクの数を指定します。コレクションの長さに応じて、`ntasks` が指定されていない場合、最大100のタスクが同時マッピングに使用されます。

`ntasks` はゼロ引数関数としても指定できます。この場合、各要素を処理する前に並行して実行するタスクの数がチェックされ、`ntasks_func` の値が現在のタスク数を超えている場合に新しいタスクが開始されます。

`batch_size` が指定されている場合、コレクションはバッチモードで処理されます。この場合、`f` は引数タプルの `Vector` を受け入れ、結果のベクターを返す関数でなければなりません。入力ベクターの長さは `batch_size` 以下になります。

以下の例は、マッピング関数が実行されるタスクの `objectid` を返すことで、異なるタスクでの実行を強調しています。

まず、`ntasks` が未定義の場合、各要素は異なるタスクで処理されます。

```
julia> tskoid() = objectid(current_task());

julia> asyncmap(x->tskoid(), 1:5)
5-element Array{UInt64,1}:
 0x6e15e66c75c75853
 0x440f8819a1baa682
 0x9fb3eeadd0c83985
 0xebd3e35fe90d4050
 0x29efc93edce2b961

julia> length(unique(asyncmap(x->tskoid(), 1:5)))
5
```

`ntasks=2` の場合、すべての要素は2つのタスクで処理されます。

```
julia> asyncmap(x->tskoid(), 1:5; ntasks=2)
5-element Array{UInt64,1}:
 0x027ab1680df7ae94
 0xa23d2f80cd7cf157
 0x027ab1680df7ae94
 0xa23d2f80cd7cf157
 0x027ab1680df7ae94

julia> length(unique(asyncmap(x->tskoid(), 1:5; ntasks=2)))
2
```

`batch_size` が定義されている場合、マッピング関数は引数タプルの配列を受け入れ、結果の配列を返すように変更する必要があります。これを達成するために、修正されたマッピング関数では `map` が使用されます。

```
julia> batch_func(input) = map(x->string("args_tuple: ", x, ", element_val: ", x[1], ", task: ", tskoid()), input)
batch_func (generic function with 1 method)

julia> asyncmap(batch_func, 1:5; ntasks=2, batch_size=2)
5-element Array{String,1}:
 "args_tuple: (1,), element_val: 1, task: 9118321258196414413"
 "args_tuple: (2,), element_val: 2, task: 4904288162898683522"
 "args_tuple: (3,), element_val: 3, task: 9118321258196414413"
 "args_tuple: (4,), element_val: 4, task: 4904288162898683522"
 "args_tuple: (5,), element_val: 5, task: 9118321258196414413"
```
