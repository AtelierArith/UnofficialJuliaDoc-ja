```julia
as
```

`as`は、`import`または`using`によってスコープに取り込まれた識別子の名前を変更するキーワードです。名前の衝突を回避したり、名前を短くしたりする目的で使用します。（`import`または`using`文の外では、`as`はキーワードではなく、通常の識別子として使用できます。）

`import LinearAlgebra as LA`を使うと、インポートされた標準ライブラリ`LinearAlgebra`が`LA`としてスコープに取り込まれます。

`import LinearAlgebra: eigen as eig, cholesky as chol`を使うと、`LinearAlgebra`のメソッド`eigen`と`cholesky`が、それぞれ`eig`と`chol`としてスコープに取り込まれます。

`as`が`using`と併用できるのは、個々の識別子をスコープに取り込む場合に限られます。たとえば、`using LinearAlgebra: eigen as eig`や`using LinearAlgebra: eigen as eig, cholesky as chol`は使用できますが、`using LinearAlgebra as LA`は構文として無効です。`LinearAlgebra`がエクスポートするすべての名前を`LA`に変更するのは意味をなさないためです。
