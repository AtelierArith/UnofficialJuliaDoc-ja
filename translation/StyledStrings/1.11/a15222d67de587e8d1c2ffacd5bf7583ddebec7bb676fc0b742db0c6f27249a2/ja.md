```julia
merge(initial::StyledStrings.Face, others::StyledStrings.Face...)
```

`initial` フェイスと `others` のプロパティをマージし、後のフェイスが優先されます。

これは、複数のフェイスのスタイルを組み合わせ、継承を解決するために使用されます。
