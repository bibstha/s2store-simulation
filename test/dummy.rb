require 'matrix'
require 'benchmark'


GRID = Matrix.build(10, 10) { [true, false].sample }
MALICIOUS_SIDE = 0..2

is_malicious = lambda do
  MALICIOUS_SIDE.each do |r|
    MALICIOUS_SIDE.each do |c|
      if GRID[r, c]
        "HELLO"
      end
    end
  end
end

Benchmark.bm do |x|
  x.report do
    1_000_000.times do
      is_malicious.call
    end
  end
end