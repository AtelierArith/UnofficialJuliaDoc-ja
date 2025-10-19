```julia
WorkerConfig
```

Type used by [`ClusterManager`](@ref)s to control workers added to their clusters. Some fields are used by all cluster managers to access a host:

  * `io` – the connection used to access the worker (a subtype of `IO` or `Nothing`)
  * `host` – the host address (either a `String` or `Nothing`)
  * `port` – the port on the host used to connect to the worker (either an `Int` or `Nothing`)

Some are used by the cluster manager to add workers to an already-initialized host:

  * `count` – the number of workers to be launched on the host
  * `exename` – the path to the Julia executable on the host, defaults to `"$(Sys.BINDIR)/julia"` or `"$(Sys.BINDIR)/julia-debug"`
  * `exeflags` – flags to use when launching Julia remotely

The `userdata` field is used to store information for each worker by external managers.

Some fields are used by `SSHManager` and similar managers:

  * `tunnel` – `true` (use tunneling), `false` (do not use tunneling), or [`nothing`](@ref) (use default for the manager)
  * `multiplex` – `true` (use SSH multiplexing for tunneling) or `false`
  * `forward` – the forwarding option used for `-L` option of ssh
  * `bind_addr` – the address on the remote host to bind to
  * `sshflags` – flags to use in establishing the SSH connection
  * `max_parallel` – the maximum number of workers to connect to in parallel on the host

Some fields are used by both `LocalManager`s and `SSHManager`s:

  * `connect_at` – determines whether this is a worker-to-worker or driver-to-worker setup call
  * `process` – the process which will be connected (usually the manager will assign this during [`addprocs`](@ref))
  * `ospid` – the process ID according to the host OS, used to interrupt worker processes
  * `environ` – private dictionary used to store temporary information by Local/SSH managers
  * `ident` – worker as identified by the [`ClusterManager`](@ref)
  * `connect_idents` – list of worker ids the worker must connect to if using a custom topology
  * `enable_threaded_blas` – `true`, `false`, or `nothing`, whether to use threaded BLAS or not on the workers
