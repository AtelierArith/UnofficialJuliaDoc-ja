```julia
open(command, stdio=devnull; write::Bool = false, read::Bool = !write)
```

`command` の実行を非同期で開始し、`process::IO` オブジェクトを返します。`read` が true の場合、プロセスからの読み取り元はプロセスの標準出力となり、`stdio` でプロセスの標準入力ストリームを任意に指定できます。`write` が true の場合、書き込み先はプロセスの標準入力となり、`stdio` でプロセスの標準出力ストリームを任意に指定できます。プロセスの標準エラーストリームは、現在のグローバルな `stderr` に接続されます。
