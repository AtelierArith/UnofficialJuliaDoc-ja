```
Printf.format(f::Printf.Format, args...) => String
Printf.format(io::IO, f::Printf.Format, args...)
```

提供された `args` に printf フォーマットオブジェクト `f` を適用し、フォーマットされた文字列を返します（1 番目のメソッド）。または、`io` オブジェクトに直接印刷します（2 番目のメソッド）。C `printf` サポートの詳細については [`@printf`](@ref) を参照してください。
