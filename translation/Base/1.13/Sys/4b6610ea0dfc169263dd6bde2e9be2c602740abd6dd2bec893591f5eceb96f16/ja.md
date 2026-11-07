```julia
Sys.CPUinfo
```

`CPUinfo` 型は、次のフィールドを持つ可変構造体です。

  * `model::String`: CPU のモデル情報。
  * `speed::Int32`: CPU の速度（MHz 単位）。
  * `cpu_times!user::UInt64`: ユーザーモードでの処理時間。CPU 状態には、ユーザー空間のプロセスが使用した CPU 時間が示されます。
  * `cpu_times!nice::UInt64`: nice モードでの処理時間。CPU 状態の「user」の一部であり、正の nice 値（つまり、ほかのタスクより優先度が低い）を持つプロセスが使用した CPU 時間が示されます。
  * `cpu_times!sys::UInt64`: システムモードでの処理時間。CPU 状態には、カーネルが使用した CPU 時間が示されます。
  * `cpu_times!idle::UInt64`: アイドルモードでの処理時間。CPU 状態には、CPU が実際に使用されていない時間が示されます。
  * `cpu_times!irq::UInt64`: 割り込み処理に費やした時間。CPU 状態には、CPU がハードウェア割り込みを処理していた時間が示されます。

時間の単位はミリ秒です。

注: `versioninfo(verbose=true)` を通じて、詳細なシステム情報に含まれます。
