```julia
LinearAlgebra.peakflops(n::Integer=4096; eltype::DataType=Float64, ntrials::Integer=3, parallel::Bool=false)
```

`peakflops`は、倍精度の[`gemm!`](@ref LinearAlgebra.BLAS.gemm!)を使って、コンピューターのピークFLOPレートを計算します。引数を指定しない場合、デフォルトではサイズ`n x n`（`n = 4096`）の2つの`Float64`行列を乗算します。基盤となるBLASが複数のスレッドを使用している場合、より高いFLOPレートが得られます。BLASのスレッド数は[`BLAS.set_num_threads(n)`](@ref)で設定できます。

キーワード引数`eltype`を指定すると、`peakflops`はピークFLOPレートの計算に、要素の型が`eltype`である行列を生成します。

デフォルトでは、`peakflops`は3回の試行のうち最も良い計測時間を使用します。キーワード引数`ntrials`を指定すると、`peakflops`はその回数だけ試行し、最も良い計測時間を選びます。

キーワード引数`parallel`を`true`に設定すると、`peakflops`はすべてのワーカープロセッサー上で並列に実行され、並列コンピューター全体のFLOPレートを返します。並列実行時に使用されるBLASスレッドは1つだけです。引数`n`は、各プロセッサーで解く問題のサイズを表します。

!!! compat "Julia 1.1"
    この関数を使用するには、Julia 1.1以降が必要です。Julia 1.0では、標準ライブラリ`InteractiveUtils`から利用できます。

