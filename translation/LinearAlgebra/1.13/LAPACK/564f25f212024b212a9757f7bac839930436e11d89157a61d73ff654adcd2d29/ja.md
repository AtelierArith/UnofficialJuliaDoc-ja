```julia
orglq!(A, tau, k = length(tau))
```

`A` に対して `gelqf!` を呼び出した後、`LQ` 分解の行列 `Q` を明示的に取得します。`gelqf!` の出力を使用します。`A` は `Q` によって上書きされます。
