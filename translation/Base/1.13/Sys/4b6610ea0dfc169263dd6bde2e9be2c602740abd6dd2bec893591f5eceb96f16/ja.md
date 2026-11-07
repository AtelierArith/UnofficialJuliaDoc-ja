```julia
Sys.CPUinfo
```

`CPUinfo` 型は、次のフィールドを持つ可変構造体です。

  * `model::String`: CPU モデル情報。
  * `speed::Int32`: CPU の速度（MHz 単位）。
  * `cpu_times!user::UInt64`: ユーザーモードでの実行時間。CPU 状態は、ユーザー空間のプロセスが使用した CPU 時間を示します。
  * `cpu_times!nice::UInt64`: nice モードでの実行時間。CPU 状態のうち「user」状態に含まれる一部で、正の nice 値（他のタスクより優先度が低いことを意味します）を持つプロセスが使用した CPU 時間を示します。
  * `cpu_times!sys::UInt64`: システムモードでの実行時間。CPU 状態は、カーネルが使用した CPU 時間を示します。
  * `cpu_times!idle::UInt64`: アイドルモードでの時間。CPU 状態は、CPU が実際に使用されていない時間を示します。
  * `cpu_times!irq::UInt64`: 割り込み処理に費やした時間。CPU 状態は、CPU がハードウェア割り込みを処理していた時間を示します。

時間の単位はミリ秒です。

注: 詳細なシステム情報に `versioninfo(verbose=true)` を介して含まれます。
