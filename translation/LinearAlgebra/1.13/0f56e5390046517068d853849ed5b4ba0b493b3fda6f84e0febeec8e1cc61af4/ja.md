```julia
LinearAlgebra.uplo(S::Bidiagonal)::Symbol
```

上側（`:U`）または下側（`:L`）の非対角帯のどちらが格納されているかに応じて、対応する `Symbol` を返します。
