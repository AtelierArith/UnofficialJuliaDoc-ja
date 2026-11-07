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

`arg_readers` 関数は、読み込むパスと、引数を1つ取る do ブロックを受け取ります。この do ブロックは、`arg_read` が処理できる各テストリーダー型に対して1回ずつ呼び出されます。省略可能な `type` 引数を指定すると、その型の引数を生成するリーダーに対してのみ do ブロックが呼び出されます。

do ブロックに渡される `arg` は、引数値そのものではありません。テスト引数型によっては、テストケースごとに初期化と終了処理が必要だからです。たとえば、開いたファイルハンドルを引数にする場合、1回のテストで使用した後は再利用できません。次のテストでは、ファイルを閉じてから再度開く必要があります。この関数 `arg` は、`@arg_test arg begin ... end` を使って `ArgRead` インスタンスに変換できます。
