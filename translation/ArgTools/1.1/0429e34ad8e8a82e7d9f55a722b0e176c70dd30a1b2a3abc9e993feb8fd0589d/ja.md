```julia
arg_readers(arg :: AbstractString, [ type = ArgRead ]) do arg::Function
    ## pre-test setup ##
    @arg_test arg begin
        arg :: ArgRead
        ## test using `arg` ##
    end
    ## post-test cleanup ##
end
```

`arg_readers` 関数は、読み取るパスと単一引数の do ブロックを受け取り、`arg_read` が処理できる各テストリーダータイプごとに一度呼び出されます。オプションの `type` 引数が指定されている場合、do ブロックはそのタイプの引数を生成するリーダーに対してのみ呼び出されます。

do ブロックに渡される `arg` は、引数の値自体ではありません。なぜなら、いくつかのテスト引数タイプは、各テストケースのために初期化および最終化する必要があるからです。オープンファイルハンドル引数を考えてみてください：一度テストに使用したら、再度使用することはできません。次のテストのためにそれを閉じて、ファイルを再度開く必要があります。この関数 `arg` は、`@arg_test arg begin ... end` を使用して `ArgRead` インスタンスに変換できます。
