# Usage:
# ruby http-gunzip.rb < tcp-stream-file
require 'zlib'
require 'stringio'

dat = $stdin.read.force_encoding('ASCII-8BIT')
i0 = 0

while i = dat.index(/^content-encoding: gzip\r?$/i, i0)
  print dat[i0, i - i0]

  m = dat.match(/^\r?$/, i)
  j = m.offset(0)[1] + 1

  print dat[i, j - i]

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

  puts
end
