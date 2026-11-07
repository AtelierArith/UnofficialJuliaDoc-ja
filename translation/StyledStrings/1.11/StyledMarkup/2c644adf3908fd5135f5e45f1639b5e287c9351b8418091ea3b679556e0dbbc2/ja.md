```julia
run_state_machine!(state::State)
```

`state.s`を走査し、構文のトップレベルに対する解析規則を適用しながら、該当する専用関数を呼び出します。

処理が完了すると、`state.s`はすべて消費され、`state.parts`（および`state.errors`）にはすべての情報が格納されます。
