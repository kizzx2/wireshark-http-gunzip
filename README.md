# wireshark-http-gunzip

See gzip'ed HTTP response body in "Follow TCP Stream" window.

This addresses a much requested by 5+ year old [feature request](https://bugs.wireshark.org/bugzilla/show_bug.cgi?id=3528).

## How To

1. _Follow TCP Stream_
2. _Save As_ to export the contents to a file
3. `ruby http-gunzip.rb < dump`
4. Profit
