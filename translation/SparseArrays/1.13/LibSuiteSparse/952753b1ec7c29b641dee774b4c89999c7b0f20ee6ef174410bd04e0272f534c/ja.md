```julia
LibSuiteSparse.init_suitesparse
```

SuiteSparseライブラリを正しいメモリ管理関数で初期化するために使用される内部関数です。以下のSuiteSparseライブラリのいずれかを直接ラップするパッケージは、そのライブラリを使用する前に、この関数が呼び出されるようにしなければなりません：AMD、CAMD、COLAMD、CCOLAMD、UMFPACK、CXSparse、CHOLMOD、KLU、BTF、LDL、RBio、SPQR、SPEX、ParU

# Notes:

  * 現在、この関数が設定するのはSuiteSparse_configのメモリ管理関数だけですが、`printf`、`hypot`、`divcomplex`にもオーバーライド関数があります。
  * SuiteSparse_configとこの初期化関数は、CSparse、GraphBLAS、LAGraphの依存関係ではありません。
