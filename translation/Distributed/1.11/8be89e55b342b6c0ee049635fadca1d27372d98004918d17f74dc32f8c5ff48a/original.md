```julia
addprocs(machines; tunnel=false, sshflags=``, max_parallel=10, kwargs...) -> List of process identifiers
```

Add worker processes on remote machines via SSH. Configuration is done with keyword arguments (see below). In particular, the `exename` keyword can be used to specify the path to the `julia` binary on the remote machine(s).

`machines` is a vector of "machine specifications" which are given as strings of the form `[user@]host[:port] [bind_addr[:port]]`. `user` defaults to current user and `port` to the standard SSH port. If `[bind_addr[:port]]` is specified, other workers will connect to this worker at the specified `bind_addr` and `port`.

It is possible to launch multiple processes on a remote host by using a tuple in the `machines` vector or the form `(machine_spec, count)`, where `count` is the number of workers to be launched on the specified host. Passing `:auto` as the worker count will launch as many workers as the number of CPU threads on the remote host.

**Examples**:

```julia
addprocs([
    "remote1",               # one worker on 'remote1' logging in with the current username
    "user@remote2",          # one worker on 'remote2' logging in with the 'user' username
    "user@remote3:2222",     # specifying SSH port to '2222' for 'remote3'
    ("user@remote4", 4),     # launch 4 workers on 'remote4'
    ("user@remote5", :auto), # launch as many workers as CPU threads on 'remote5'
])
```

**Keyword arguments**:

  * `tunnel`: if `true` then SSH tunneling will be used to connect to the worker from the master process. Default is `false`.
  * `multiplex`: if `true` then SSH multiplexing is used for SSH tunneling. Default is `false`.
  * `ssh`: the name or path of the SSH client executable used to start the workers. Default is `"ssh"`.
  * `sshflags`: specifies additional ssh options, e.g. ```sshflags=`-i /home/foo/bar.pem` ```
  * `max_parallel`: specifies the maximum number of workers connected to in parallel at a host. Defaults to 10.
  * `shell`: specifies the type of shell to which ssh connects on the workers.

      * `shell=:posix`: a POSIX-compatible Unix/Linux shell (sh, ksh, bash, dash, zsh, etc.). The default.
      * `shell=:csh`: a Unix C shell (csh, tcsh).
      * `shell=:wincmd`: Microsoft Windows `cmd.exe`.
  * `dir`: specifies the working directory on the workers. Defaults to the host's current directory (as found by `pwd()`)
  * `enable_threaded_blas`: if `true` then  BLAS will run on multiple threads in added processes. Default is `false`.
  * `exename`: name of the `julia` executable. Defaults to `"$(Sys.BINDIR)/julia"` or `"$(Sys.BINDIR)/julia-debug"` as the case may be. It is recommended that a common Julia version is used on all remote machines because serialization and code distribution might fail otherwise.
  * `exeflags`: additional flags passed to the worker processes. It can either be a `Cmd`, a `String` holding one flag, or a collection of strings, with one element per flag. E.g. $--threads=auto project=.$, `"--compile-trace=stderr"` or `["--threads=auto", "--compile=all"]`.
  * `topology`: Specifies how the workers connect to each other. Sending a message between unconnected workers results in an error.

      * `topology=:all_to_all`: All processes are connected to each other. The default.
      * `topology=:master_worker`: Only the driver process, i.e. `pid` 1 connects to the workers. The workers do not connect to each other.
      * `topology=:custom`: The `launch` method of the cluster manager specifies the connection topology via fields `ident` and `connect_idents` in `WorkerConfig`. A worker with a cluster manager identity `ident` will connect to all workers specified in `connect_idents`.
  * `lazy`: Applicable only with `topology=:all_to_all`. If `true`, worker-worker connections are setup lazily, i.e. they are setup at the first instance of a remote call between workers. Default is true.
  * `env`: provide an array of string pairs such as `env=["JULIA_DEPOT_PATH"=>"/depot"]` to request that environment variables are set on the remote machine. By default only the environment variable `JULIA_WORKER_TIMEOUT` is passed automatically from the local to the remote environment.
  * `cmdline_cookie`: pass the authentication cookie via the `--worker` commandline  option. The (more secure) default behaviour of passing the cookie via ssh stdio  may hang with Windows workers that use older (pre-ConPTY) Julia or Windows versions,  in which case `cmdline_cookie=true` offers a work-around.

!!! compat "Julia 1.6"
    The keyword arguments `ssh`, `shell`, `env` and `cmdline_cookie` were added in Julia 1.6.


Environment variables:

If the master process fails to establish a connection with a newly launched worker within 60.0 seconds, the worker treats it as a fatal situation and terminates. This timeout can be controlled via environment variable `JULIA_WORKER_TIMEOUT`. The value of `JULIA_WORKER_TIMEOUT` on the master process specifies the number of seconds a newly launched worker waits for connection establishment.
