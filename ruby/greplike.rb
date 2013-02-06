def usage
   puts "USAGE: greplike.rb file searchString"
end

if ARGV.length != 2
   usage
else
   File.open(ARGV[0], "r") do |mFile|
      mFile.each_line do |line| 
          if line =~ Regexp.new(ARGV[1]) 
             puts "Term found in #{line.dump} on line #{mFile.lineno}" 
          end
      end
   end
end