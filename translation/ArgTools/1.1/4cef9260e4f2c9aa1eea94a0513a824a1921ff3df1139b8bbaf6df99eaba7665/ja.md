```julia
arg_writers([ type = ArgWrite ]) do path::String, arg::Function
    ## テスト前のセットアップ ##
    @arg_test arg begin
        arg :: ArgWrite
        ## `arg`を使ったテスト ##
    end
    ## テスト後のクリーンアップ ##
end
```

`arg_writers`関数はdoブロックを受け取り、これは`arg_write`が処理できる各テストライタータイプに対して一度呼び出されます。ここで、`path`は一時的（存在しない）なものであり、`arg`は`path`に書き込むさまざまな書き込み可能な引数タイプに変換できます。オプションの`type`引数が指定されている場合、doブロックはそのタイプの引数を生成するライターに対してのみ呼び出されます。

doブロックに渡される`arg`は引数の値そのものではありません。なぜなら、いくつかのテスト引数タイプは各テストケースのために初期化および最終化する必要があるからです。オープンファイルハンドル引数を考えてみてください：一度テストに使用したら、再度使用することはできません。次のテストのためにそれを閉じて、ファイルを再度開く必要があります。この`arg`関数は、`@arg_test arg begin ... end`を使用して`ArgWrite`インスタンスに変換できます。

`arg_readers`のようにパス名を受け取る`arg_writers`メソッドもあります：

```julia
arg_writers(path::AbstractString, [ type = ArgWrite ]) do arg::Function
    ## テスト前のセットアップ ##
    @arg_test arg begin
        # ここで `arg :: ArgWrite`
        ## `arg`を使ったテスト ##
    end
    ## テスト後のクリーンアップ ##
end
```

このメソッドは、`tempname()`によって生成されたパス名を使用するのではなく、`path`を指定する必要がある場合に便利です。`path`は`arg_writers`の外部から渡されるため、この形式ではdoブロックへの引数ではありません。
