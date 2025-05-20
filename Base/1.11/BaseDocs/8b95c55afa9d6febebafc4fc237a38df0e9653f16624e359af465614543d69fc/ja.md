```
devnull
```

ストリームリダイレクトで使用され、書き込まれたすべてのデータを破棄します。基本的にはUnixの`/dev/null`またはWindowsの`NUL`と同等です。使用例：

```julia
run(pipeline(`cat test.txt`, devnull))
```
