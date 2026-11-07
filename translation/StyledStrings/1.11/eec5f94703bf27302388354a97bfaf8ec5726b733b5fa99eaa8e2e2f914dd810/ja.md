```julia
merge(initial::StyledStrings.Face, others::StyledStrings.Face...)
```

`initial`フェイスと`others`フェイスのプロパティをマージします。後に指定されたフェイスのプロパティが優先されます。

これは、複数のフェイスのスタイルを組み合わせたり、継承を解決したりするために使用されます。
