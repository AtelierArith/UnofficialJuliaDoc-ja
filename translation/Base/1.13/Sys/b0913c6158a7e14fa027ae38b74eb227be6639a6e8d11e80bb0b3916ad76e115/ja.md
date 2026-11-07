```julia
Sys.SC_CLK_TCK::Clong
```

POSIXシステムでは`sysconf(_SC_CLK_TCK)`に相当する、1秒あたりのシステム「クロックティック」数。不明な場合は`0`。
