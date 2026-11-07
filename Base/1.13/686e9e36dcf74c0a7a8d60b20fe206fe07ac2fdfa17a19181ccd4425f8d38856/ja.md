```julia
Base.full_sweep_reasons()
```

各フルスイープの理由について、その発生回数を返す辞書です。

理由は次のとおりです。

  * `:FULL_SWEEP_REASON_SWEEP_ALWAYS_FULL`: GC デバッグ環境で `always_full` が設定されていたため、フルスイープが発生した
  * `:FULL_SWEEP_REASON_FORCED_FULL_SWEEP`: `GC.gc(true)` によってフルスイープが強制された
  * `:FULL_SWEEP_REASON_USER_MAX_EXCEEDED`: ヒープのソフトサイズ上限に達したため、フルスイープが強制された
  * `:FULL_SWEEP_REASON_LARGE_PROMOTION_RATE`: GC 世代間の昇格率が高かったため、フルスイープが強制された

理由の種類は、Julia のマイナーバージョン間で一定とは限りません。
