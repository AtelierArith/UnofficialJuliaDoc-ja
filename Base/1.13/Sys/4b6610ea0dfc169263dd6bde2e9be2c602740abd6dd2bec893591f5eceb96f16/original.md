```julia
Sys.CPUinfo
```

The `CPUinfo` type is a mutable struct with the following fields:

  * `model::String`: CPU model information.
  * `speed::Int32`: CPU speed (in MHz).
  * `cpu_times!user::UInt64`: Time spent in user mode. CPU state shows CPU time used by user space processes.
  * `cpu_times!nice::UInt64`: Time spent in nice mode. CPU state is a subset of the "user" state and shows the CPU time used by processes that have a positive niceness, meaning a lower priority than other tasks.
  * `cpu_times!sys::UInt64`: Time spent in system mode. CPU state shows the amount of CPU time used by the kernel.
  * `cpu_times!idle::UInt64`: Time spent in idle mode. CPU state shows the CPU time that's not actively being used.
  * `cpu_times!irq::UInt64`: Time spent handling interrupts. CPU state shows the amount of time the CPU has been servicing hardware interrupts.

The times are in units of milliseconds.

Note: Included in the detailed system information via `versioninfo(verbose=true)`.
