```
BundledLazyLibraryPath
```

Helper type for lazily constructed library paths that are stored within the bundled Julia distribution, primarily for use by Base modules.

```
libfoo = LazyLibrary(BundledLazyLibraryPath("lib/libfoo.so.1.2.3"))
```
