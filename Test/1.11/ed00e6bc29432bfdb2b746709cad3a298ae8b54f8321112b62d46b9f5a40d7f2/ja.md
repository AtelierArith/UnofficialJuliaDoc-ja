```julia
print_test_errors([io::IO], ts::AbstractTestSet)
```

`AbstractTestSet`が`finish`された後に記録されたエラーを出力します。`io`が指定されていない場合は、`stdout`がデフォルトで使用されます。
