RUBY DAY 1

puts "Hello World"

puts "Hello, Ruby".index('Ruby')

i=0
while i < 11
	puts "Richard"
	i=i+1
end

i = 1
while i < 11
  puts "This is string number " + i.to_s
  i = i + 1
end


$ ruby myprog.rb

randomNumber = rand(10) + 1
puts randomNumber 
userInput = -1
while userInput != randomNumber 
	puts "Guess a number between 1 and 10"
  userInput = gets
  userInput = userInput.to_i
  puts userInput
	if userInput == randomNumber
    puts "Correct!"
  else
    if userInput > randomNumber
      puts "Too High!"
    else
      puts "Too Low!"
    end
  end
end