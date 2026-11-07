```julia
print_test_errors([io::IO], ts::AbstractTestSet)
```

`AbstractTestSet` に記録されたエラーを、`finish` された後に出力します。`io` が指定されていない場合は、`stdout` がデフォルトで使用されます。
