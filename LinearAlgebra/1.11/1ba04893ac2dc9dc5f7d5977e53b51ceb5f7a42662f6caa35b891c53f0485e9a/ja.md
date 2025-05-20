```
LinearAlgebra.peakflops(n::Integer=4096; eltype::DataType=Float64, ntrials::Integer=3, parallel::Bool=false)
```

`peakflops`は、倍精度[`gemm!`](@ref LinearAlgebra.BLAS.gemm!)を使用してコンピュータのピークフロップレートを計算します。デフォルトでは、引数が指定されていない場合、サイズ`n x n`の2つの`Float64`行列を掛け算します。ここで、`n = 4096`です。基盤となるBLASが複数のスレッドを使用している場合、より高いフロップレートが実現されます。BLASスレッドの数は[`BLAS.set_num_threads(n)`](@ref)で設定できます。

キーワード引数`eltype`が指定されている場合、`peakflops`はピークフロップレートを計算するために`eltype`型の要素を持つ行列を構築します。

デフォルトでは、`peakflops`は3回の試行から最良のタイミングを使用します。`ntrials`キーワード引数が指定されている場合、`peakflops`はその数の試行を使用して最良のタイミングを選択します。

キーワード引数`parallel`が`true`に設定されている場合、`peakflops`はすべてのワーカープロセッサで並列に実行されます。全体の並列コンピュータのフロップレートが返されます。並列で実行する際は、1つのBLASスレッドのみが使用されます。引数`n`は、各プロセッサで解決される問題のサイズを指します。

!!! compat "Julia 1.1"
    この関数は少なくともJulia 1.1が必要です。Julia 1.0では、標準ライブラリ`InteractiveUtils`から利用可能です。

