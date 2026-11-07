```julia
evalpoly(x, p)
```

係数 `p[1]`, `p[2]`, ... に対して、多項式 ``\sum_k x^{k-1} p[k]`` を評価します。つまり、係数は `x` の次数の昇順で指定します。係数の個数が静的にわかる場合、すなわち `p` が `Tuple` である場合、ループはコンパイル時に展開されます。この関数は、`x` が実数の場合は Horner 法を、`x` が複素数の場合は Goertzel 法に類似したアルゴリズム [^DK62] を用いて、効率的なコードを生成します。

[^DK62]: Donald Knuth, Art of Computer Programming, Volume 2: Seminumerical Algorithms, Sec. 4.6.4.

!!! compat "Julia 1.4"
    この関数には Julia 1.4 以降が必要です。


# Examples

```jldoctest
julia> evalpoly(2, (1, 2, 3))
17
```
