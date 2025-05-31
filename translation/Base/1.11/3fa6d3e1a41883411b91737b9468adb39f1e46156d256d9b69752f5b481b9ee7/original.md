```
AbstractPipe
```

`AbstractPipe` is an abstract supertype that exists for the convenience of creating pass-through wrappers for other IO objects, so that you only need to implement the additional methods relevant to your type. A subtype only needs to implement one or both of these methods:

```
struct P <: AbstractPipe; ...; end
pipe_reader(io::P) = io.out
pipe_writer(io::P) = io.in
```

If `pipe isa AbstractPipe`, it must obey the following interface:

  * `pipe.in` or `pipe.in_stream`, if present, must be of type `IO` and be used to provide input to the pipe
  * `pipe.out` or `pipe.out_stream`, if present, must be of type `IO` and be used for output from the pipe
  * `pipe.err` or `pipe.err_stream`, if present, must be of type `IO` and be used for writing errors from the pipe
