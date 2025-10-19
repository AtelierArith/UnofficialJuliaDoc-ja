```julia
devnull
```

ストリームリダイレクトで使用され、書き込まれたすべてのデータを破棄します。基本的にはUnixの`/dev/null`またはWindowsの`NUL`に相当します。使用例：

```julia
run(pipeline(`cat test.txt`, devnull))
```
