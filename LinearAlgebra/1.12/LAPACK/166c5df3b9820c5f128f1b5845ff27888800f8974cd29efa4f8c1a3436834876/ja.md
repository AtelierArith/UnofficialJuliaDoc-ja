```julia
orgrq!(A, tau, k = length(tau))
```

明示的に、`gerqf!`を`A`に対して呼び出した後の`RQ`因子分解の行列`Q`を見つけます。`gerqf!`の出力を使用します。`A`は`Q`で上書きされます。
