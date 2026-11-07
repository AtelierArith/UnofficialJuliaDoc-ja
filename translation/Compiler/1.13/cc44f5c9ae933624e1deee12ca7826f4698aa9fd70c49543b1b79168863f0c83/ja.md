```julia
callers_in_cycle(sv::AbsIntState)
```

抽象解釈スタック内で、指定された `AbsIntState` の呼び出し元をすべてたどります（指定された `AbsIntState` 自体を含む）。ただし、複数のフレームからなるサイクルの一部である場合に限ります。
