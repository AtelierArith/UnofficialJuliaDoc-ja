The `Downloads` module exports a function [`download`](@ref), which provides cross-platform, multi-protocol, in-process download functionality implemented with [libcurl](https://curl.haxx.se/libcurl/).   It is used for the `Base.download` function in Julia 1.6 or later.

More generally, the module exports functions and types that provide lower-level control and diagnostic information for file downloading:

  * [`download`](@ref) — download a file from a URL, erroring if it can't be downloaded
  * [`request`](@ref) — request a URL, returning a `Response` object indicating success
  * [`Response`](@ref) — a type capturing the status and other metadata about a request
  * [`RequestError`](@ref) — an error type thrown by `download` and `request` on error
  * [`Downloader`](@ref) — an object encapsulating shared resources for downloading
