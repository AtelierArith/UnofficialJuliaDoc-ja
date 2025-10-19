```julia
orgql!(A, tau, k = length(tau))
```

`geqlf!`を`A`に対して呼び出した後に、`QL`因子分解の行列`Q`を明示的に求めます。`geqlf!`の出力を使用します。`A`は`Q`で上書きされます。
