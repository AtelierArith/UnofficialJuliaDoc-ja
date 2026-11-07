```julia
QRCompactWY <: Factorization
```

通常は[`qr`](@ref)から得られる、コンパクトなブロック形式で格納されたQR行列分解です。``A``が`m`×`n`行列の場合、

```math
A = Q R
```

ここで、``Q``は直交／ユニタリ行列、``R``は上三角行列です。これは[`QR`](@ref)形式に似ていますが、直交／ユニタリ行列``Q``が*Compact WY*形式[^Schreiber1989]で格納される点が異なります。ブロックサイズ``n_b``の場合、`m`×`n`の下台形行列``V``と、サイズ``n_b``×``n_b``の上三角行列``T_j``を``b = \lceil \min(m,n) / n_b \rceil``個含む行列``T = (T_1 \; T_2 \; ... \; T_{b-1} \; T_b')``（``j = 1, ..., b-1``）、および``n_b``×``\min(m,n) - (b-1) n_b``の上台形行列``T_b'``（``j=b``）として格納されます。この行列の上側の正方部分を``T_b``と表し、次を満たします。

```math
Q = \prod_{i=1}^{\min(m,n)} (I - \tau_i v_i v_i^T)
= \prod_{j=1}^{b} (I - V_j T_j V_j^T)
```

ここで、``v_i``は``V``の``i``列、``\tau_i``は`[diag(T_1); diag(T_2); …; diag(T_b)]`の``i``番目の要素、``(V_1 \; V_2 \; ... \; V_b)``は``V``の左側の`m`×`min(m, n)`ブロックです。[`qr`](@ref)を使って構築した場合、ブロックサイズは``n_b = \min(m, n, 36)``で与えられます。

分解を反復すると、成分`Q`と`R`が得られます。

このオブジェクトには2つのフィールドがあります。

  * `factors`は、[`QR`](@ref)型と同様に、`m`×`n`行列です。

      * 上三角部分には``R``の要素が格納されます。つまり、`QR`オブジェクト`F`では`R = triu(F.factors)`です。
      * 対角線より下の部分には、`V = I + tril(F.factors, -1)`となるよう、反射子``v_i``がパック形式で格納されます。
  * `T`は、上記の説明にある``n_b``-by-``\min(m,n)``行列です。各三角行列``T_j``の対角線より下の要素は無視されます。

!!! note
    この形式を、旧式の*WY*表現[^Bischof1987]と混同しないでください。


[^Bischof1987]: C Bischof and C Van Loan, "The WY representation for products of Householder matrices", SIAM J Sci Stat Comput 8 (1987), s2-s13. [doi:10.1137/0908009](https://doi.org/10.1137/0908009)

[^Schreiber1989]: R Schreiber and C Van Loan, "A storage-efficient WY representation for products of Householder transformations", SIAM J Sci Stat Comput 10 (1989), 53-57. [doi:10.1137/0910005](https://doi.org/10.1137/0910005)
