```julia
Sys.cpu_summary(io::IO=stdout, cpu::AbstractVector{CPUinfo}=cpu_info())
```

同じモデルのCPUごとに集計した情報を整理して表示し、CPU情報の概要を`io`ストリーム（デフォルトは[`stdout`](@ref)）に出力します。対象となるCPUの集合を記述した`CPUinfo`データ構造の配列を指定します（デフォルトは[`Sys.cpu_info`](@ref)関数の戻り値です）。

概要には、CPUモデルごとの集計情報が含まれます。同じモデルのすべてのコアについて、平均CPU速度や、各モード（user、nice、sys、idle、irq）での合計時間などが表示されます。

注：`versioninfo(verbose=true)`を通じて、詳細なシステム情報に含まれます。
