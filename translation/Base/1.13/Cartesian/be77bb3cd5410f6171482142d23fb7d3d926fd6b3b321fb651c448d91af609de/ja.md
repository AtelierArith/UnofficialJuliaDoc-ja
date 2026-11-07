```julia
@nif N conditionexpr expr
@nif N conditionexpr expr elseexpr
```

一連の `if ... elseif ... else ... end` 文を生成します。たとえば、

```julia
@nif 3 d->(i_d >= size(A,d)) d->(error("Dimension ", d, " too big")) d->println("All OK")
```

は、次のように生成します。

```julia
if i_1 > size(A, 1)
    error("Dimension ", 1, " too big")
elseif i_2 > size(A, 2)
    error("Dimension ", 2, " too big")
else
    println("All OK")
end
```
