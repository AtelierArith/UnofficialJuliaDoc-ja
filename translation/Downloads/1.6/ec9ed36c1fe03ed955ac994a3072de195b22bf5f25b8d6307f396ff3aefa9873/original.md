```
request(url;
    [ input = <none>, ]
    [ output = <none>, ]
    [ method = input ? "PUT" : output ? "GET" : "HEAD", ]
    [ headers = <none>, ]
    [ timeout = <none>, ]
    [ progress = <none>, ]
    [ verbose = false, ]
    [ debug = <none>, ]
    [ throw = true, ]
    [ downloader = <default>, ]
    [ interrupt = <none>, ]
) -> Union{Response, RequestError}

    url        :: AbstractString
    input      :: Union{AbstractString, AbstractCmd, IO}
    output     :: Union{AbstractString, AbstractCmd, IO}
    method     :: AbstractString
    headers    :: Union{AbstractVector, AbstractDict}
    timeout    :: Real
    progress   :: (dl_total, dl_now, ul_total, ul_now) --> Any
    verbose    :: Bool
    debug      :: (type, message) --> Any
    throw      :: Bool
    downloader :: Downloader
    interrupt  :: Base.Event
```

Make a request to the given url, returning a `Response` object capturing the status, headers and other information about the response. The body of the response is written to `output` if specified and discarded otherwise. For HTTP/S requests, if an `input` stream is given, a `PUT` request is made; otherwise if an `output` stream is given, a `GET` request is made; if neither is given a `HEAD` request is made. For other protocols, appropriate default methods are used based on what combination of input and output are requested. The following options differ from the `download` function:

  * `input` allows providing a request body; if provided default to `PUT` request
  * `progress` is a callback taking four integers for upload and download progress
  * `throw` controls whether to throw or return a `RequestError` on request error

Note that unlike `download` which throws an error if the requested URL could not be downloaded (indicated by non-2xx status code), `request` returns a `Response` object no matter what the status code of the response is. If there is an error with getting a response at all, then a `RequestError` is thrown or returned.

If the `interrupt` keyword argument is provided, it must be a `Base.Event` object. If the event is triggered while the request is in progress, the request will be cancelled and an error will be thrown. This can be used to interrupt a long running request, for example if the user wants to cancel a download.
