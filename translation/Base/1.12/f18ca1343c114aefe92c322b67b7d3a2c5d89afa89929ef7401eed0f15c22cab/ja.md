```julia
pipeline(command; stdin, stdout, stderr, append=false)
```

指定された `command` へのまたはからの I/O をリダイレクトします。キーワード引数は、リダイレクトすべきコマンドのストリームを指定します。`append` はファイル出力がファイルに追加されるかどうかを制御します。これは、2引数の `pipeline` 関数のより一般的なバージョンです。`pipeline(from, to)` は、`from` がコマンドの場合は `pipeline(from, stdout=to)` と同等であり、`from` が別の種類のデータソースの場合は `pipeline(to, stdin=from)` と同等です。

**例**:

```julia
run(pipeline(`dothings`, stdout="out.txt", stderr="errs.txt"))
run(pipeline(`update`, stdout="log.txt", append=true))
```
