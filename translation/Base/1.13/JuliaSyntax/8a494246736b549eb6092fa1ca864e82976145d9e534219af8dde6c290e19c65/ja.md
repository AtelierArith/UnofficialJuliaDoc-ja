```julia
peek(stream::ParseStream [, n=1]; skip_newlines=false)
```

ストリーム内の`n`トークンを先読みし、トークンの種類を返します。コメントと改行を含まない空白は自動的にスキップされます。改行が1つだけ含まれる空白は、`skip_newlines`がtrueでない限り、種類`K"NewlineWs"`として返されます。
