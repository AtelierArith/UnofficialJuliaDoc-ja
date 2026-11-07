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

`arg_writers` 関数は do ブロックを受け取り、`arg_write` が一時的な（存在しない）`path` と、`path` に書き込むさまざまな書き込み可能な引数型に変換できる `arg` を使って処理できる、各テストライター型に対して一度ずつ呼び出します。省略可能な `type` 引数を指定すると、その型の引数を生成するライターに対してのみ do ブロックが呼び出されます。

do ブロックに渡される `arg` は、引数の値そのものではありません。テスト用の引数型の中には、テストケースごとに初期化と終了処理が必要なものがあるためです。たとえば、ファイルハンドルを引数として使う場合、あるテストで使った後は再利用できません。次のテストでは、ファイルを閉じて再度開く必要があります。この関数 `arg` は、`@arg_test arg begin ... end` を使って `ArgWrite` インスタンスに変換できます。

パス名（`arg_readers` など）を受け取る `arg_writers` メソッドもあります。

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

このメソッドは、`tempname()` が生成するパス名ではなく、`path` を指定する必要がある場合に便利です。`path` は `arg_writers` の外部から渡されるため、この形式ではパスは do ブロックの引数になりません。
