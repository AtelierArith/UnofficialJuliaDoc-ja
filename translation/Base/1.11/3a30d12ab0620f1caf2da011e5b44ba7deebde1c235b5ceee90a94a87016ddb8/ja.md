```
invmod(n::Integer, T) where {T <: Base.BitInteger}
invmod(n::T) where {T <: Base.BitInteger}
```

整数環の型 `T` における `n` の剰余逆数を計算します。すなわち、`2^N` で割った剰余であり、ここで `N = 8*sizeof(T)`（例えば、`Int32` の場合は `N = 32`）です。言い換えれば、これらのメソッドは次の等式を満たします：

```
n * invmod(n) == 1
(n * invmod(n, T)) % T == 1
(n % T) * invmod(n, T) == 1
```

ここでの `*` は整数環 `T` における剰余乗算です。

整数型によって暗黙的に示される剰余を明示的な値として指定することは、剰余が定義上その型で表現できるには大きすぎるため、しばしば不便です。

剰余逆数は、https://arxiv.org/pdf/2204.04342.pdf で説明されているアルゴリズムを使用して、一般的なケースよりもはるかに効率的に計算されます。

!!! compat "Julia 1.11"
    `invmod(n)` および `invmod(n, T)` メソッドは、Julia 1.11 以降が必要です。

