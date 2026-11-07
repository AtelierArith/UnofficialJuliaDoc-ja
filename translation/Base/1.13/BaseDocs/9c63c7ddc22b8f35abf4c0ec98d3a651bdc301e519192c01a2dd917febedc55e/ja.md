```julia
devnull
```

ストリームのリダイレクト先として使用し、書き込まれたデータをすべて破棄します。Unix の `/dev/null`、または Windows の `NUL` とほぼ同等です。使用例:

```julia
run(pipeline(`cat test.txt`, devnull))
```
