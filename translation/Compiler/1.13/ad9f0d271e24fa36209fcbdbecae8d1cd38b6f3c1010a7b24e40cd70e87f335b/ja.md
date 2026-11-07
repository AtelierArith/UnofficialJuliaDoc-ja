```julia
AbsIntStackUnwind(sv::AbsIntState)
```

抽象解釈スタック内で、指定された `AbsIntState` のすべての呼び出し元（指定された `AbsIntState` 自身を含む）を、子から親へ（つまり、指定された `AbsIntState` からツリーを上にたどる順に）反復処理します。循環については、任意の順序で訪問される場合があります。
