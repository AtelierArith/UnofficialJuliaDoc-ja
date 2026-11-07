```julia
Compiler.reset_timings()
```

Empty out the previously recorded type inference timings (`Compiler._timings`), and start the ROOT() timer again. `ROOT()` measures all time spent *outside* inference.
