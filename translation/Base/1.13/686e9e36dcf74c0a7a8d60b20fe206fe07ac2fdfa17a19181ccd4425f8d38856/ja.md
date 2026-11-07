```julia
Base.full_sweep_reasons()
```

各フルスイープの理由が発生した回数を返す辞書です。

理由は次のとおりです。

  * `:FULL_SWEEP_REASON_SWEEP_ALWAYS_FULL`: GC デバッグ環境で `always_full` が設定されていたため、フルスイープが発生しました
  * `:FULL_SWEEP_REASON_FORCED_FULL_SWEEP`: `GC.gc(true)` によってフルスイープが強制されました
  * `:FULL_SWEEP_REASON_USER_MAX_EXCEEDED`: システムがヒープのソフトサイズ上限に達したため、フルスイープが強制されました
  * `:FULL_SWEEP_REASON_LARGE_PROMOTION_RATE`: GC 世代間での昇格率が高かったため、フルスイープが強制されました

理由の種類は、Julia のマイナーバージョン間で一定とは限らないことに注意してください。
