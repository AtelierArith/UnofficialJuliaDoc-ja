```julia
Base.Experimental.make_io_thread()
```

Create a new thread that will run the Julia IO loop. This can potentially reduce the latency of some IO operations as they no longer depend on the main thread to run it. This does mean that code that uses this as implicit synchronization needs to be checked for correctness.
