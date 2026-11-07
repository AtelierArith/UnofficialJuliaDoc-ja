```julia
AbsIntStackUnwind(sv::AbsIntState)
```

抽象解釈スタック内で、指定された `AbsIntState` のすべての呼び出し元（指定された `AbsIntState` 自身を含む）を、子から親へ（つまり、指定された `AbsIntState` からツリーを上にたどりながら）順に反復します。循環については、どの順序で訪問してもかまいません。
