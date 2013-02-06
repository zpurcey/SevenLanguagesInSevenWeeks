FIND

1/ 

File.open("foo.txt","w") { |f| f << "This is sexy" }   

instead of forcing us to write this:

file = File.open("foo.txt","w")   
file << "This is tedious"   
file.close

2/ 

a1 = ['apple', 1, 'banana', 2]
h1 = Hash[*a1.flatten]
puts "h1: #{h1.inspect}"

a2 = [['apple', 1], ['banana', 2]]
h2 = Hash[*a2.flatten]
puts "h2: #{h2.inspect}"

3/

h = {"peter" => ["apple", "orange", "mango"], "sandra" => ["flowers", "bike"]}
h.flat_map { |k, vs| [k].product(vs) }

4/ queues, stacks, sets, arrays and lists

DO


1/

a = (1..16).to_a
i = 0
a.each do |item|
  p a[i, 4] if(i % 4 == 0)
  i +=1
end   

a.each_slice(4){|x| p x}

2/ 

class Tree
  attr_accessor :children, :node_name

  def initialize(data)
      data.each do |k, v|
        @node_name = k
        @children = v.map {|(k, v)| Tree.new(k => v)}
      end
  end

  def visit_all(&block)
    visit &block
    children.each {|c| c.visit_all &block}
  end

  def visit(&block)
    block.call self
  end
end


ruby_tree = Tree.new( 
  {'grandpa' => { 'dad' => {'child 1' => {}, 'child 2' => {}}, 
                  'uncle' => {'child 3' => {}, 'child 4' => {}}
                }
  }
)
puts "Visiting a node"
ruby_tree.visit {|node| puts node.node_name}
puts
puts "visiting entire tree"
ruby_tree.visit_all {|node| puts node.node_name}

3/

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
