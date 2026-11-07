```julia
Profile.take_heap_snapshot(filepath::String, all_one::Bool=false;
                           redact_data::Bool=true, streaming::Bool=false)
Profile.take_heap_snapshot(all_one::Bool=false; redact_data:Bool=true,
                           dir::String=nothing, streaming::Bool=false)
```

ヒープのスナップショットを、Chrome DevTools のヒープスナップショットビューアーが想定する JSON 形式（拡張子は .heapsnapshot）でファイルに書き込みます。デフォルトではカレントディレクトリ（書き込み不可の場合は tempdir）に `$pid_$timestamp.heapsnapshot` という名前で保存します。指定があれば `dir` に保存します。また、フルパスまたは IO ストリームを指定することもできます。

`all_one` が true の場合、オブジェクトを簡単に数えられるよう、すべてのオブジェクトのサイズを 1 として記録します。それ以外の場合は、実際のサイズを記録します。

`redact_data` が true（デフォルト）の場合、オブジェクトの内容は出力しません。

`streaming` が true の場合、スナップショット全体をメモリに保持せずに済むよう、filepath をプレフィックスとして、スナップショットデータを 4 つのファイルにストリーミング出力します。メモリに制約のある環境では、このオプションを使用してください。これらのファイルは、Profile.HeapSnapshot.assemble_snapshot() を呼び出すことで再構成できます。この処理はオフラインで実行できます。

注：パフォーマンス上の理由から、streaming=true を設定することを強く推奨します。分割されたファイルからスナップショットを再構成するには、スナップショット全体をメモリに保持する必要があります。そのため、スナップショットが大きい場合、処理中にメモリ不足になる可能性があります。ストリーミングを使えば、ワークロードの実行終了後にオフラインで再構成できます。streaming=false（デフォルト。後方互換性のため）でスナップショットを取得しようとしてプロセスが強制終了された場合でも、分割ファイルは指定した filepath と同じディレクトリに必ず保存されます。そのため、後から `assemble_snapshot()` を使ってスナップショットを再構成できます。
