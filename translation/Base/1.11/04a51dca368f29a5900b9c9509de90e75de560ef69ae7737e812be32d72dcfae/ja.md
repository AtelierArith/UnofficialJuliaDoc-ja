```
open(command, stdio=devnull; write::Bool = false, read::Bool = !write)
```

`command`を非同期に実行し、`process::IO`オブジェクトを返します。`read`がtrueの場合、プロセスからの読み取りはプロセスの標準出力から行われ、`stdio`はオプションでプロセスの標準入力ストリームを指定します。`write`がtrueの場合、書き込みはプロセスの標準入力に送られ、`stdio`はオプションでプロセスの標準出力ストリームを指定します。プロセスの標準エラーストリームは現在のグローバル`stderr`に接続されています。
