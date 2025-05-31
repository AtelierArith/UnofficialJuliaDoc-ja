```
peek(stream [, n=1]; skip_newlines=false)
```

ストリーム内で `n` トークン先を覗き見し、トークンの種類を返します。コメントと改行以外の空白は自動的にスキップされます。単一の改行を含む空白は、`skip_newlines` が true でない限り、種類 `K"NewlineWs"` として返されます。
