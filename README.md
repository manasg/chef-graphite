Chef cookbook to install graphite based on http://obfuscurity.com/2012/08/Screencast---Installing-Graphite-from-Source

Requirements
============
Please run apt-get update before running the recipes

Tested on Ubuntu 12.04

Gotchas
=======
The python installations are not really idempotent, so they rely on node attributes. This doesn't work well when running it under chef-solo

User Accounts/Passwords
=======================
See attributes/defaults.rb. 

Server Available at https://_ip_of_the_server/ 

