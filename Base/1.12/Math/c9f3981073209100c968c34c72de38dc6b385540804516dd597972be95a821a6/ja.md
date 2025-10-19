```julia
evalpoly(x, p)
```

多項式 $\sum_k x^{k-1} p[k]$ を評価します。係数 `p[1]`, `p[2]`, ... が与えられます。つまり、係数は `x` の冪の昇順で与えられます。係数の数が静的に知られている場合、すなわち `p` が `Tuple` の場合、ループはコンパイル時に展開されます。この関数は、`x` が実数の場合はホーナー法を使用して効率的なコードを生成し、`x` が複素数の場合はゴーツェルのような [^DK62] アルゴリズムを使用します。

[^DK62]: Donald Knuth, Art of Computer Programming, Volume 2: Seminumerical Algorithms, Sec. 4.6.4.

!!! compat "Julia 1.4"
    この関数は Julia 1.4 以降が必要です。


# 例

```jldoctest
julia> evalpoly(2, (1, 2, 3))
17
```
