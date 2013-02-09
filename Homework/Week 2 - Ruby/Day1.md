Find:

• The Ruby API
> http://www.ruby-doc.org/core-1.9.3/
  
• ThefreeonlineversionofProgrammingRuby:ThePragmaticProgrammer’s Guide [TFH08]
> http://www.ruby-doc.org/docs/ProgrammingRuby/html/index.html

• A method that substitutes part of a string

```
  str[fixnum,fixnum] = str

  > myname = 'Andrew'
  => "Andrew"
  > myname[2,3] = 'erd'
  => "erd"
  > myname
  => "Anerdw"
```

• Information about Ruby’s regular expressions

> http://www.ruby-doc.org/core-1.9.3/Regexp.html

• Information about Ruby’s ranges

> http://www.ruby-doc.org/core-1.9.3/Range.html

Do:

• Print the string “Hello, world.”

```
> puts 'Hello, world.'
Hello, world.
```

• For the string “Hello, Ruby,” find the index of the word “Ruby.”

```
> "Hello, Ruby.".index('Ruby.')
```

• Print your name ten times.

```
> 10.times do puts 'Andrew Purcell' end
Andrew Purcell
Andrew Purcell
Andrew Purcell
Andrew Purcell
Andrew Purcell
Andrew Purcell
Andrew Purcell
Andrew Purcell
Andrew Purcell
Andrew Purcell
=> 10
```
Alternatively:
```
> 10.times {puts "Andrew Purcell"}
Andrew Purcell
Andrew Purcell
Andrew Purcell
Andrew Purcell
Andrew Purcell
Andrew Purcell
Andrew Purcell
Andrew Purcell
Andrew Purcell
Andrew Purcell
=> 10
```
Alternatively:
```
> puts "Andrew Purcell " * 10
Andrew Purcell Andrew Purcell Andrew Purcell Andrew Purcell Andrew Purcell Andrew Purcell Andrew Purcell Andrew Purcell Andrew Purcell Andrew Purcell 
```

• Print the string “This is sentence number 1,” where the number 1 changes from 1 to 10.

```
> 1.upto(10) do |i|
*   puts "This is sentence number #{i}"
> end
This is sentence number 1
This is sentence number 2
This is sentence number 3
This is sentence number 4
This is sentence number 5
This is sentence number 6
This is sentence number 7
This is sentence number 8
This is sentence number 9
This is sentence number 10
=> 1
```

• Run a Ruby program from a file.

```
$ cat puts "Hello World" > helloWorld.rb
$ ruby helloWorld.rb
Hello World
$ 
```
