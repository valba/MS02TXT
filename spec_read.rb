#!/usr/bin/ruby
# Read a .MS0 file and extract data to a .sxt file.
# Argument list:
#   $1 = experimental.MS0 input spectrum file
#   $2 = experimental.sxt output spectrum file
# Output:
#   out_filename, center, minimum and maximum

ccdArray = []
wvArray = []
spectrum = []
sorted_spectrum = []
#filename = 'NEON600.MS0'
in_filename = ARGV[0]
out_filename = ARGV[1]
#in_filename = "HG405G.MS0"
#out_filename = "hg_405.txt"

line_num = 0
d = 10.00
wv = 1
negat = 1

ccdfile=File.open(in_filename).read
ccdfile.gsub!(/\r\n?/, "\n")
filtro = ccdfile.match(/"JY"(.*)"x"/m)[1]
centro = filtro.scan(/\"(.*)\"/)[5][0].to_f

ccdfile.each_line do |line|
# # print "#{line_num += 1} #{line}" if (line[/^  /])
#  print "#{line_num += 1}  #{/^  /.match(line)}"
  line_num += 1
#  print (centro - d + d * line_num / 1024) if (line[/^  /])
#  wvArray.push (centro - d + d * line_num / 1024) if (line[/^  /]) if (wv)
  if !(line[/^\"/])
      if (wv == 1)
        if (line.chomp.to_f > 0.0)
          wvArray.push line.chomp.to_f
          negat = 0
        else
          negat = 1
        end
        wv = 0
#print "#{negat} -"
      elsif (wv == 0)
#print "#{negat} \n"
        if (negat == 0)
          ccdArray.push line.chomp.to_f
        end 
        wv = 1
      end
  end
#print (centro - d + d * line_num / 1024).to_f if (line[/^  /])
#  puts (centro - d + d * line_num / 1024)"  " line if (line[/^  /])
end
#spectrum = ccdfile.lines.each_slice(2).take(2)
#print wvArray
spectrum = wvArray.zip(ccdArray)
sorted_spectrum = spectrum.sort_by{|x,y| x}
#print spectrum
#$stdout = File.open('./spectrum.txt', 'w')
f = File.open(out_filename, 'w')
for line in sorted_spectrum
    f.write(line.join(' ') + "\n")
  #print line.join(' ') + "\n" 
end
f.close()
minimo = sorted_spectrum.first
maximo = sorted_spectrum.last
print "#{out_filename} --> Centro: #{centro} cm-1   min: #{minimo}   max: #{maximo} \n"
#print ccdArray[1]
#print wvArray[1]
#print spectrum[1]
#print want.to_s
#print centro[0].to_f
