# Ruby is already installed for 1.8.7 

echo "Check for Vim and install if needed"
if [ ! -f /usr/bin/vim ] 

then 
	apt-get install vim -y
else
	echo "Vim is installed"
fi

# io setup

echo "Checking and installing Io and dependencies"
if [ ! -d /usr/local/lib/io/addons/Zlib/_build/ ]
then
	echo "Installing cmake, g++, rpm, io"
	apt-get update -y
	apt-get install make -y
	apt-get install cmake -y
	apt-get install g++ -y
	apt-get install rpm -y
	apt-get install unzip -y
	wget --no-check-certificate http://github.com/stevedekorte/io/zipball/master -O io-lang.zip
	unzip io-lang.zip
	#cd stevedekorte-io-8956a60
	cd stevedekorte-io-???????
	echo "Building Io"
	./build.sh
	./build.sh install
	cd ..
	rm io-lang.zip
	rm -r stevedekorte-io-???????
else
	echo "IO appears to be installed"
fi

# prolog setup

echo "Checking and installing GNU Prolog and dependencies"
if [ ! -f /usr/bin/gprolog ]
then
	apt-get install -y gprolog gprolog-doc
	
else
	echo "Prolog appears to be installed"
fi

# scala setup

echo "Checking and installing Scala and dependencies"
if [ ! -f /usr/bin/scala ]
then
        apt-get install -y scala

else
        echo "Scala appears to be installed"
fi

# erlang setup

echo "Checking and installing Erlang and dependencies"
if [ ! -f /usr/bin/erl ]
then
        apt-get install -y erlang erlang-doc

else
        echo "Erlang appears to be installed"
fi


# clojure setup

echo "Checking and installing Clojure (Leiningen) and dependencies"
if [ ! -f /usr/bin/lein ]
then
        apt-get install -y leiningen

else
	echo "Clojure (Leiningen) appears to be installed"
fi

# haskell setup

echo "Checking and installing Haskell and dependencies"
if [ ! -f /usr/bin/ghc ]
then
        apt-get install -y ghc6 ghc6-prof ghc-doc

else
        echo "Haskell appears to be installed"
fi

