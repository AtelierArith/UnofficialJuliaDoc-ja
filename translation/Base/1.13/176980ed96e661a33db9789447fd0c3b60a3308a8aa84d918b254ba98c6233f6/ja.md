```julia
pipeline(command; stdin, stdout, stderr, append=false)
```

指定した`command`との間でI/Oをリダイレクトします。キーワード引数で、コマンドのどのストリームをリダイレクトするかを指定します。`append`は、ファイルへの出力を追記するかどうかを制御します。これは、2引数の`pipeline`関数をより一般化したものです。`pipeline(from, to)`は、`from`がコマンドの場合は`pipeline(from, stdout=to)`と同等で、`from`が別の種類のデータソースの場合は`pipeline(to, stdin=from)`と同等です。

**例**:

```julia
run(pipeline(`dothings`, stdout="out.txt", stderr="errs.txt"))
run(pipeline(`update`, stdout="log.txt", append=true))
```
