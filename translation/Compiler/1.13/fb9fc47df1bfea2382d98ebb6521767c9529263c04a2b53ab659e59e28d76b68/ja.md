```julia
(::ComputeTryCatch{Handler})(code, [, bbs]) -> handler_info::Union{Nothing,HandlerInfo{Handler}}
const compute_trycatch = ComputeTryCatch{SimpleHandler}()
```

関数のコードを受け取り、各文における現在の try/catch ハンドラーと、例外スタックの現在のトップを計算します。この関数は次のタプルを返します。

```julia
1. `handler_info.handler_at`: A statement length vector of tuples
   `(catch_handler, exception_stack)`, which are indices into `handlers`

2. `handler_info.handlers`: A `Handler` vector of handlers
```
