```julia
nameof(f::Function) -> Symbol
```

汎用 `Function` の名前をシンボルとして取得します。匿名関数の場合、これはコンパイラ生成の名前です。`Function` の明示的に宣言されたサブタイプの場合、それは関数の型の名前です。
