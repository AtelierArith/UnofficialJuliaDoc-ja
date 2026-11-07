```julia
print_test_results([io::IO], ts::AbstractTestSet, depth_pad=0)
```

`AbstractTestSet`の結果を、整形された表として出力します。

`depth_pad`は、すべての出力の先頭に追加するパディングの量を指します。`io`が指定されていない場合、デフォルトは`stdout`です。

`Test.finish`内で呼び出された場合、`finish`されたテストセットが最上位のテストセットであるとき。
