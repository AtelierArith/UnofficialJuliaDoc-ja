```julia
@nif N conditionexpr expr
@nif N conditionexpr expr elseexpr
```

`if ... elseif ... else ... end` ステートメントのシーケンスを生成します。例えば：

```julia
@nif 3 d->(i_d >= size(A,d)) d->(error("Dimension ", d, " too big")) d->println("All OK")
```

は次のように生成されます：

```julia
if i_1 > size(A, 1)
    error("Dimension ", 1, " too big")
elseif i_2 > size(A, 2)
    error("Dimension ", 2, " too big")
else
    println("All OK")
end
```
