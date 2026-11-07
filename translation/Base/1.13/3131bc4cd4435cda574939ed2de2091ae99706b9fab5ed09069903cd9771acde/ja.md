```julia
pipeline(from, to, ...)
```

データソースから出力先へのパイプラインを作成します。ソースと出力先には、コマンド、I/Oストリーム、文字列、または他の`pipeline`呼び出しの結果を指定できます。引数のうち少なくとも1つはコマンドでなければなりません。文字列はファイル名を表します。引数を2つより多く指定すると、左から右へ順に連結されます。たとえば、`pipeline(a,b,c)`は`pipeline(pipeline(a,b),c)`と同等です。これにより、複数段階のパイプラインをより簡潔に指定できます。

**例**:

```julia
run(pipeline(`ls`, `grep xyz`))
run(pipeline(`ls`, "out.txt"))
run(pipeline("out.txt", `grep xyz`))
```
