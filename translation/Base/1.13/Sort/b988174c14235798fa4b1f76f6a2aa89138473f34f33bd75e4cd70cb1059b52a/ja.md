```julia
struct DefaultStable <: Algorithm end
```

`DefaultStable`は、高速で汎用的なソートアルゴリズムを使うことを示しますが、具体的にどのアルゴリズムを使うかは指定しません。

現在、短いNTupleをソートする場合は展開済みマージソートを使い、それ以外の場合は[`InitialOptimizations`](@ref)と、基数ソート、挿入ソート、計数ソート、クイックソートを組み合わせたハイブリッド方式で構成されています。

まずMissingOptimizationを適用します。これは、発動しなければ実行時コストがなく、後続の最適化を可能にする場合があるためです。たとえば、BoolOptimizationは`AbstractVector{Union{Missing, Bool}}`には適用できませんが、[`MissingOptimization`](@ref)を適用すると、その入力は`AbstractVector{Bool}`に変換されます。

次に[`BoolOptimization`](@ref)を適用します。これも、発動しなければ実行時コストがなく、発動した場合は非常に効率的なアルゴリズムだからです（`Bool`のソートはかなり簡単です）。

続いて、`length <= 10`を持つ入力には[`InsertionSort`](@ref)を適用します。このディスパッチを[`IEEEFloatOptimization`](@ref)のパスより先に行うのは、入力が非常に小さい場合、[`IEEEFloatOptimization`](@ref)が有効ではないためです。

[`InitialOptimizations`](@ref)を完了するため、[`IEEEFloatOptimization`](@ref)を適用します。

これらの最適化の後、入力ベクトルと順序に対して基数ソートなどの関連アルゴリズムを適用できるかどうかで処理を分岐します。`UIntMappable(v, order) !== nothing`かどうかを調べて分岐します。つまり、`eltype(v)`から`UInt`への、順序`order`を保つ可逆な写像が既知かどうかを確認します。この確認を初期最適化の後に行うのは、初期最適化によって入力ベクトルの型や順序が変わり、`UIntMappable`になる場合があるためです。

入力が[`UIntMappable`](@ref)でない場合は、事前ソート済みかどうかを確認してから[`ScratchQuickSort`](@ref)にディスパッチします。

そうでない場合は、`length <= 40`を持つ入力に[`InsertionSort`](@ref)を適用し、その後、事前ソート済みかどうかを確認します（[`CheckSorted`](@ref)）。

小さな入力では確認のオーバーヘッドを避けるため、事前ソート済みかどうかの確認より先に、入力が短いかどうかを調べます。代替のディスパッチ先である[`InsertionSort`](@ref)は、事前ソート済みの入力に対して効率的な`O(n)`実行時性能を持つため、小さな入力ではこの確認は不要です。

長いベクトル（要素数が500を超えるもの）については、逆順にソート済みかどうかを確認します。入力がほぼ完全に逆順でない限り、この確認のコストは実質的にかからないためです。

入力が[`UIntMappable`](@ref)だと判定された時点で、その順序は入力上の[total order](wikipedia.org/wiki/Total_order)を形成すると分かります。そのため、2つの要素が比較上等しくなるのは実際に等しい場合に限られ、その場合は入れ替えても検出できないので、不安定ソートを行うことは不可能です。この性質を利用して、より積極的な逆順チェックを行い、ベクトルを`[3, 2, 2, 1]`します。

これらの高速パスを試しても適用できなかった場合は、入力の[`ComputeExtrema`](@ref)を行います。この計算の`O(n)`実行時性能はかなり高速ですが、必要になるまで実行を遅らせます。

次に、[`ConsiderCountingSort`](@ref)を行います。入力の範囲が長さに比べて小さい場合は、[`CountingSort`](@ref)を適用します。

続いて、[`ConsiderRadixSort`](@ref)を行います。これは計数ソートへのディスパッチと似ていますが、範囲そのものではなく、範囲を表す*ビット数*を考慮します。そのため、この段階に到達した入力のうち、十分に長いものには[`RadixSort`](@ref)を適用します。

最後に、入力の長さが80未満なら[`InsertionSort`](@ref)にディスパッチし、それ以外なら[`ScratchQuickSort`](@ref)にディスパッチします。
