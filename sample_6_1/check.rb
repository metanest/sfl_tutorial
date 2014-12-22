#!/usr/local/bin/ruby21

DAT = <<EOD
 0 7e
 1 30
 2 6d
 3 79
 4 33
 5 5b
 6 5f
 7 70
 8 7f
 9 7b
10 77
11 1f
12 4e
13 3d
14 4f
15 47
EOD

def main
   DAT.each_line {|line|
      line.chomp!
      led = (line.split)[1].to_i(16)
      print7seg led
   }
end

TEMPLATE = <<EOS
 aaaaaa
f      b
f      b
f      b
 gggggg
e      c
e      c
e      c
 dddddd
EOS

def print7seg led
    buf = TEMPLATE.dup
    (0..6).each {|i|
        seg = "abcdefg"[i, 1]
        chr = if led[6-i] == 1 then "*" else " " end
        buf.gsub!(seg){chr}
    }
    puts
    print buf
    puts
end

main
