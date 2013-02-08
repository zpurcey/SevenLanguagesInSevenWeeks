___    ____________________________________   _________
__ |  / /__    |_  ____/__  __ \__    |__  | / /__  __/
__ | / /__  /| |  / __ __  /_/ /_  /| |_   |/ /__  /   
__ |/ / _  ___ / /_/ / _  _, _/_  ___ |  /|  / _  /    
_____/  /_/  |_\____/  /_/ |_| /_/  |_/_/ |_/  /_/     
                                                       
____________________________  _________ 
__  ___/__  ____/__  __/_  / / /__  __ \
_____ \__  __/  __  /  _  / / /__  /_/ /
____/ /_  /___  _  /   / /_/ / _  ____/ 
/____/ /_____/  /_/    \____/  /_/      
                                        
_____________  __________________________
__  ____/_  / / /___  _/__  __ \__  ____/
_  / __ _  / / / __  / __  / / /_  __/   
/ /_/ / / /_/ / __/ /  _  /_/ /_  /___   
\____/  \____/  /___/  /_____/ /_____/  


This readme shows how to set up an Ubuntu VM for use with the 7LI7W book using Vagrant.  It runs on Windows, OS X and various Linux flavours.

LINUX & OS X

 - Install Oracle Virtual Box (http://virtualbox.org)
 - Install Vagrant (http://vagrantup.com)
 - Create a folder for your VM and cd to it
 - Copy the Vagrantfile and the provision.sh file into the folder
 - $ vagrant box add precise32 http://files.vagrantup.com/precise32.box
 - $ vagrant up


It will take a while the first time you run this command as it will first download the VM image (about 1Gb) and then the provision script will install all the languages needed for the book and associated dev environments.  I have tried to stick as much as possible to the versions of the languages in the book (eg: Ruby 1.8 instead of 1.9) to make it easier to follow the book, but it may not be 100% the same in all cases - caveat emptor!  Once this completes, connect to the VM using

- $ vagrant ssh

WINDOWS

There is currently a bug in Vagrant that means that the provisioning script won't work on Windows - it should be fixed in the next Vagrant release.  The below steps show you how to install from a fully pre-baked box, it will actually be quicker to install than the provisioned install which will go and download everything from the net first time around.

 - Install Oracle Virtual Box (http://virtualbox.org)
 - Install Vagrant (http://vagrantup.com)
 - On Windows you will also need to install PuTTY - check the Vagrant site for details of how to connect to the VM.  
 - Create a folder for your VM and cd to it
 - Copy the 7lang.box file (from scratch or USB) to your VM folder
 - $ vagrant init 7lang 7lang.box
 - $ vagrant up
 
 Now you can use PuTTY to connect to your new VM - username/password is vagrant/vagrant
 
