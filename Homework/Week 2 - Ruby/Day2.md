#Study Notes

Loved the rich native support of the design of the arrays to support lists and stacks.

Wow code blocks let you pass around executable code! Must be hard for the next programmer to follow no?


#Homework

##Find:

• Find out how to access files with and without code blocks.
file = File.open("tmp.txt", "w+")
file.puts "a spoonful is great but I'd rather have a bowl"
file.close

# safer, less erroro-prone, shorter, more readable
File.open("tmp.txt", "r").each { |line|
    puts line
}

What is the benefit of the code block?
> Code blocks let you pass around executable code. They allow simplification of logic and modifications to a single line.
> Ahh I missed the point - they're suggesting using a code block whenever doing file io

• How would you translate a hash to an array?

> http://www.ruby-doc.org/core-1.9.3/Hash.html#M000722
> Using h.to_a

Can you translate arrays to hashes?
> Yes eg.
> a1 = ['apple', 1, 'banana', 2]
> h1 = Hash[*a1.flatten]

• Can you iterate through a hash?
> Yes hashes have an each_key method you can use:
> hash.each_key do |key|

• You can use Ruby arrays as stacks. What other common data structures do arrays support?
> Queues, linked lists or sets

##Do:

• Print the contents of an array of sixteen numbers, four numbers at a time, using just each.
Now, do the same with each_slice in Enumerable.

```
numbers = [*(1..16)]
numbers.each do |i|
  p numbers[((i-4)...i)] if i % 4 == 0
end
```

```
numbers.each_slice(4) { |slice| p slice }
```

• The Tree class was interesting, but it did not allow you to specify a new tree with a clean user interface.
Let the initializer accept a nested structure of hashes.
You should be able to specify a tree like this:
{'grandpa' => { 'dad' => {'child 1' => {}, 'child 2' => {} }, 'uncle' => {'child 3' => {}, 'child 4' => {} } } }.

```
http://nickknowlson.com/blog/2011/12/04/seven-languages-week-1-day-2/
Uses responds_to? which returns true if the class method exists.  So when initializing the tree if name or children don't have keys it will build the structure.
```

• Write a simple grep that will print the lines of a file having any occurrences of a phrase anywhere in that line.
You will need to do a simple regular expression match and read lines from a file.
(This is surprisingly simple in Ruby.) If you want, include line numbers.

> Reviewed available answers and skipped (http://nickknowlson.com/blog/2011/12/04/seven-languages-week-1-day-2/)
