```julia
Profile.take_heap_snapshot(filepath::String, all_one::Bool=false;
                           redact_data::Bool=true, streaming::Bool=false)
Profile.take_heap_snapshot(all_one::Bool=false; redact_data:Bool=true,
                           dir::String=nothing, streaming::Bool=false)
```

ヒープのスナップショットを、Chrome DevTools の Heap Snapshot ビューアーが想定する JSON 形式（拡張子は .heapsnapshot）で、デフォルトではカレントディレクトリ内のファイル `$pid_$timestamp.heapsnapshot` に書き込みます。カレントディレクトリに書き込めない場合は tempdir に書き込みます。指定があれば `dir`、指定されたフルパス、または IO ストリームに書き込みます。

`all_one` が true の場合、オブジェクトを簡単に数えられるよう、すべてのオブジェクトのサイズを 1 として記録します。それ以外の場合は、実際のサイズを記録します。

`redact_data` が true（デフォルト）の場合、オブジェクトの内容は出力しません。

`streaming` が true の場合、スナップショットデータをストリーミングし、filepath をプレフィックスとして 4 つのファイルに出力します。これにより、スナップショット全体をメモリ上に保持せずに済みます。これらのファイルは、Profile.HeapSnapshot.assemble_snapshot() を呼び出すことで再構成できます。この処理はオフラインで実行できます。

注意：パフォーマンス上の理由から、streaming=true を強く推奨します。分割されたファイルからスナップショットを再構成するには、スナップショット全体をメモリ上に保持する必要があります。そのため、スナップショットが大きい場合、処理中にメモリ不足になる可能性があります。ストリーミングを使えば、ワークロードの実行が終わった後にオフラインで再構成できます。streaming=false（デフォルト。後方互換性のため）でスナップショットを取得しようとしてプロセスが強制終了された場合、分割ファイルは常に指定した filepath と同じディレクトリに保存されます。そのため、後から `assemble_snapshot()` を使ってスナップショットを再構成できます。
