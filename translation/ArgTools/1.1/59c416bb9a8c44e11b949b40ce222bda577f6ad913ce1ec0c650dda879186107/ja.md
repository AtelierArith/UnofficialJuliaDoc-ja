```julia
arg_writers([ type = ArgWrite ]) do path::String, arg::Function
    ## pre-test setup ##
    @arg_test arg begin
        arg :: ArgWrite
        ## test using `arg` ##
    end
    ## post-test cleanup ##
end
```

`arg_writers`関数はdoブロックを受け取り、`arg_write`が扱える各テストライター型について、そのブロックを1回ずつ呼び出します。各テストライター型には、一時的な（存在しない）`path`と、`path`に書き込むさまざまな書き込み可能な引数型に変換できる`arg`が用意されます。省略可能な`type`引数を指定すると、その型の引数を生成するライターに対してのみdoブロックが呼び出されます。

doブロックに渡される`arg`は、引数値そのものではありません。テスト引数型によっては、テストケースごとに初期化と終了処理が必要だからです。たとえば、開いたファイルハンドルを引数として使う場合、1回のテストで使用すると再利用できません。次のテストでは、いったん閉じてからファイルを開き直す必要があります。この関数`arg`は、`@arg_test arg begin ... end`を使って`ArgWrite`インスタンスに変換できます。

パス名（`arg_readers`など）を受け取る`arg_writers`メソッドもあります。

```julia
arg_writers(path::AbstractString, [ type = ArgWrite ]) do arg::Function
    ## pre-test setup ##
    @arg_test arg begin
        # here `arg :: ArgWrite`
        ## test using `arg` ##
    end
    ## post-test cleanup ##
end
```

このメソッドは、`tempname()`が生成するパス名を使わずに、`path`を指定したい場合に便利です。`path`は`arg_writers`の外部から渡されるため、この形式ではパスはdoブロックの引数になりません。
