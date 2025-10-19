```julia
Profile.take_heap_snapshot(filepath::String, all_one::Bool=false;
                           redact_data::Bool=true, streaming::Bool=false)
Profile.take_heap_snapshot(all_one::Bool=false; redact_data:Bool=true,
                           dir::String=nothing, streaming::Bool=false)
```

ヒープのスナップショットを、Chrome Devtools Heap Snapshot ビューアーが期待する JSON 形式でファイルに書き込みます（.heapsnapshot 拡張子）。デフォルトでは現在のディレクトリにファイル（`$pid_$timestamp.heapsnapshot`）を書き込みます（または現在のディレクトリが書き込み不可の場合は tempdir に）。また、`dir` が指定されている場合はそこに、または指定されたフルファイルパス、または IO ストリームに書き込みます。

`all_one` が true の場合、すべてのオブジェクトのサイズを 1 として報告し、簡単にカウントできるようにします。そうでない場合は、実際のサイズを報告します。

`redact_data` が true の場合（デフォルト）、オブジェクトの内容は出力されません。

`streaming` が true の場合、スナップショットデータを 4 つのファイルにストリーミングし、filepath をプレフィックスとして使用します。これにより、全体のスナップショットをメモリに保持する必要がなくなります。このオプションは、メモリが制約されている設定で使用する必要があります。これらのファイルは、Profile.HeapSnapshot.assemble_snapshot() を呼び出すことで再構成できます。これはオフラインで行うことができます。

注意: パフォーマンスの理由から、streaming=true を設定することを強く推奨します。部分からスナップショットを再構成するには、全体のスナップショットをメモリに保持する必要があるため、スナップショットが大きい場合、処理中にメモリが不足する可能性があります。ストリーミングを使用すると、ワークロードの実行が完了した後にオフラインでスナップショットを再構成できます。streaming=false（デフォルト、後方互換性のため）でスナップショットを収集しようとし、プロセスが終了した場合、提供されたファイルパスと同じディレクトリに常に部分が保存されるため、`assemble_snapshot()` を介して後でスナップショットを再構成できます。
