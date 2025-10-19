```julia
print_test_results(ts::AbstractTestSet, depth_pad=0)
```

`AbstractTestSet`の結果をフォーマットされたテーブルとして出力します。

`depth_pad`は、すべての出力の前に追加されるパディングの量を指します。

`Test.finish`の内部で呼び出され、`finish`されたテストセットが最上位のテストセットである場合。
