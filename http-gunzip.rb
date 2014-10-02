# wireshark-http-gunzip.rb
# 0.1.1
#
# Usage:
# ruby http-gunzip.rb < tcp-stream-file
require 'zlib'
require 'stringio'

dat = $stdin.read.force_encoding('ASCII-8BIT')
i0 = 0

while i = dat.index(%r(^HTTP/1\.[01] \d+ [a-zA-Z ]+\r?$), i0)
  print dat[i0, i - i0]

  m = dat.match(/^\r?$/, i)
  j = m.offset(0)[1] + 1

  headers = dat[i, j - i]
  print headers

  gzip_encoding = headers.lines.grep(/^content-encoding: gzip/i).first
  if gzip_encoding.nil?
    i0 = j
    next
  end

  content_length = headers.lines.grep(/^content-length: \d+\r?$/i).first
  content_length = content_length.split.last.to_i if content_length

  if content_length
    profit = Zlib::GzipReader.new(StringIO.new(dat[j, content_length])).read
    print profit
    i0 = j + content_length
  else # Assume chunked encoding
    loop do
      m = dat.match(/^([0123456789abcdef]+)?\r?$/, j)
      l = m[1].to_i(16)

      if l == 0
        i0 = m.offset(0)[1] + 1
        break
      end

      z = dat[m.offset(0)[1] + 1, l]

      profit = Zlib::GzipReader.new(StringIO.new(z)).read
      print profit

      j = m.offset(0)[1] + l + 2
    end
  end

  puts
end
