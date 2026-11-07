```julia
Threads.@threads [schedule] for ... end
```

`for` ループを並列実行するマクロです。反復空間は粗粒度のタスクに分割されます。このポリシーは `schedule` 引数で指定できます。ループの実行は、すべての反復の評価が完了するまで待機します。

`@threads` が生成するタスクは、`:default` スレッドプールでスケジュールされます。つまり、メインスレッドやインタラクティブプールのタスクから呼び出された場合でも、`@threads` は `:interactive` スレッドプールのスレッドを使用しません。`:default` スレッドプールは、計算負荷の高い並列ワークロードを対象としています。

関連項目: [`@spawn`](@ref Threads.@spawn) および `pmap`（[`Distributed`](@ref man-distributed)）。スレッドプールの詳細については、[threadpools](@ref man-threadpools) の章を参照してください。

# Extended help

## Semantics

スケジューリングオプションでより強い保証が指定されていない限り、`@threads` マクロが実行するループは、次のセマンティクスに従います。

`@threads` マクロは、ループ本体を順序未指定で、場合によっては並行して実行します。タスクとワーカースレッドの正確な割り当ては指定されておらず、実行ごとに異なる可能性があります。ループ本体のコード（そこから推移的に呼び出されるコードを含む）は、反復がタスクにどのように分配されるか、またはどのワーカースレッドで実行されるかについて、いかなる前提も置いてはなりません。各反復のループ本体は、他の反復に依存せずに処理を進められ、データ競合が発生しないものでなければなりません。そのため、反復間の不適切な同期はデッドロックを引き起こす可能性があり、同期されていないメモリアクセスは未定義の動作につながる可能性があります。

たとえば、上記の条件から次のことが導かれます。

  * ある反復で取得したロックは、その反復内で必ず解放しなければなりません。
  * `Channel` などのブロッキングプリミティブを使って反復間で通信するのは不適切です。
  * ロックまたはアトミック操作を使わない限り、反復間で共有されていない場所にのみ書き込んでください。
  * `:static` スケジュールを使用しない限り、[`threadid()`](@ref Threads.threadid) の値は、単一の反復内でも変化する可能性があります。[`Task Migration`](@ref man-task-migration) を参照してください。

## Schedulers

スケジューラ引数を指定しない場合、正確なスケジューリング方法は未指定であり、Julia のリリースによって異なります。現在は、スケジューラを指定しないと `:dynamic` が使用されます。

!!! compat "Julia 1.5"
    `schedule` 引数は Julia 1.5 以降で使用できます。


### `:dynamic` (default)

`:dynamic` スケジューラは、利用可能なワーカースレッドに反復を動的に割り当てます。現在の実装では、各反復のワークロードが均一であることを前提としています。ただし、この前提は将来変更される可能性があります。

このスケジューリングオプションは、基盤となる実行機構へのヒントにすぎません。ただし、いくつかの性質が期待できます。`:dynamic` スケジューラが使用する `Task` の数は、利用可能なワーカースレッド数（[`Threads.threadpoolsize()`](@ref)）の小さな定数倍以下に制限されます。各タスクは、反復空間内の連続した領域を処理します。そのため、`length(xs)` がワーカースレッド数を大幅に上回り、`f(x)` の実行時間がタスクの生成と同期にかかるコスト（通常は 10 マイクロ秒未満）より比較的短い場合、`@threads :dynamic for x in xs; f(x); end` は通常、`@sync for x in xs; @spawn f(x); end` より効率的です。

!!! compat "Julia 1.8"
    `schedule` 引数の `:dynamic` オプションは、Julia 1.8 以降で利用可能であり、デフォルトです。


### `:greedy`

`:greedy` スケジューラは、最大 [`Threads.threadpoolsize()`](@ref) 個のタスクを生成します。各タスクは、イテレータが値を生成するたびに、その値を貪欲に処理します。タスクが処理を終えると、次の値をイテレータから取得します。個々のタスクが処理する値は、イテレータ上で連続しているとは限りません。指定されたイテレータは無限に値を生成してもかまいません。必要なのはイテレータインターフェースだけであり、インデックス付けは不要です。

各反復のワークロードが均一でない場合や、ばらつきが大きい場合は、一般にこのスケジューリングオプションが適しています。

!!! compat "Julia 1.11"
    `schedule` 引数の `:greedy` オプションは、Julia 1.11 以降で使用できます。


### `:static`

`:static` スケジューラはスレッドごとに1つのタスクを作成し、反復を均等に分割して、各タスクを特定のスレッドに割り当てます。特に、[`threadid()`](@ref Threads.threadid) の値は、1つの反復内で一定であることが保証されます。別の `@threads` ループ内、またはスレッド1以外から `:static` を指定すると、エラーになります。

!!! note
    `:static` スケジューリングは、Julia 1.3 より前に書かれたコードの移行を支援するために用意されています。このオプションを使う関数は任意のワーカースレッドから呼び出せないため、新たに作成するライブラリ関数では `:static` スケジューリングの使用は推奨されません。


## Examples

異なるスケジューリング戦略を説明するため、指定した秒数だけ実行される、yield しない時間計測ループを含む次の関数 `busywait` を考えてみましょう。

```julia-repl
julia> function busywait(seconds)
            tstart = time_ns()
            while (time_ns() - tstart) / 1e9 < seconds
            end
        end

julia> @time begin
            Threads.@spawn busywait(5)
            Threads.@threads :static for i in 1:Threads.threadpoolsize()
                busywait(1)
            end
        end
6.003001 seconds (16.33 k allocations: 899.255 KiB, 0.25% compilation time)

julia> @time begin
            Threads.@spawn busywait(5)
            Threads.@threads :dynamic for i in 1:Threads.threadpoolsize()
                busywait(1)
            end
        end
2.012056 seconds (16.05 k allocations: 883.919 KiB, 0.66% compilation time)
```

`:dynamic` の例は2秒かかります。空いているスレッドの1つが、1秒の反復を2回実行して for ループを完了できるためです。
