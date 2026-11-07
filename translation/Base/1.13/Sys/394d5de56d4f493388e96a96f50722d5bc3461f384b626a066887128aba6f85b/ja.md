```julia
Sys.cpu_summary(io::IO=stdout, cpu::AbstractVector{CPUinfo}=cpu_info())
```

同じモデルのCPUをまとめて情報を整理・表示し、CPU情報の概要を`io`ストリーム（デフォルトは[`stdout`](@ref)）に出力します。対象となるCPUの集合を記述した`CPUinfo`構造体の配列を指定できます（デフォルトは[`Sys.cpu_info`](@ref)関数の戻り値です）。

概要には、CPUモデルごとの集計情報が含まれます。同じモデルのすべてのコアについて、CPU速度の平均や、各モード（user、nice、sys、idle、irq）での合計時間などが表示されます。

注：詳細なシステム情報には`versioninfo(verbose=true)`を通じて含まれます。
