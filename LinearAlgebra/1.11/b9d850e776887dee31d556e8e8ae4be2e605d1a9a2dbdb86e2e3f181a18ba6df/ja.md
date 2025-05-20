```
QRCompactWY <: Factorization
```

コンパクトブロック形式で保存されたQR行列因子分解で、通常は[`qr`](@ref)から得られます。$A$が`m`×`n`行列であるとき、

$$
A = Q R
$$

ここで、$Q$は直交/ユニタリ行列で、$R$は上三角行列です。これは[`QR`](@ref)形式に似ていますが、直交/ユニタリ行列$Q$は*Compact WY*形式で保存されています[^Schreiber1989]。ブロックサイズ$n_b$に対して、これは`m`×`n`の下台形行列$V$と、$b = \lceil \min(m,n) / n_b \rceil$個の上三角行列$T_j$（サイズ$n_b$×$n_b$、$j = 1, ..., b-1$）から構成される行列$T = (T_1 \; T_2 \; ... \; T_{b-1} \; T_b')$として保存され、上台形の$n_b$×$\min(m,n) - (b-1) n_b$行列$T_b'$（$j=b$）の上の正方部分は$T_b$と呼ばれ、次のように満たします。

$$
Q = \prod_{i=1}^{\min(m,n)} (I - \tau_i v_i v_i^T)
= \prod_{j=1}^{b} (I - V_j T_j V_j^T)
$$

ここで、$v_i$は$V$の$i$列目、$\tau_i$は`[diag(T_1); diag(T_2); …; diag(T_b)]`の$i$要素であり、$(V_1 \; V_2 \; ... \; V_b)$は$V$の左`m`×`min(m, n)`ブロックです。[`qr`](@ref)を使用して構築されると、ブロックサイズは$n_b = \min(m, n, 36)$で与えられます。

分解を繰り返すことで、成分`Q`と`R`が生成されます。

このオブジェクトには2つのフィールドがあります：

  * `factors`は、[`QR`](@ref)型のように、`m`×`n`行列です。

      * 上三角部分には$R$の要素が含まれ、すなわち`R = triu(F.factors)`は`QR`オブジェクト`F`に対して成り立ちます。
      * 下対角部分には、パック形式で保存された反射体$v_i$が含まれ、`V = I + tril(F.factors, -1)`となります。
  * `T`は、上記のように$n_b$×$\min(m,n)$行列です。各三角行列$T_j$の下対角要素は無視されます。

!!! note
    この形式は、古い*WY*表現[^Bischof1987]と混同しないでください。


[^Bischof1987]: C Bischof and C Van Loan, "The WY representation for products of Householder matrices", SIAM J Sci Stat Comput 8 (1987), s2-s13. [doi:10.1137/0908009](https://doi.org/10.1137/0908009)

[^Schreiber1989]: R Schreiber and C Van Loan, "A storage-efficient WY representation for products of Householder transformations", SIAM J Sci Stat Comput 10 (1989), 53-57. [doi:10.1137/0910005](https://doi.org/10.1137/0910005)
