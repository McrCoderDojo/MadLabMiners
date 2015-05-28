MadLab Miners
=============

This repository is for planning and code related to the Minecraft/Minetest group at MadLab.

Next Meeting:  14th June 2015 -- The Manchester Day Parade
===========================

Outline Plan
------------

We have the Manchester Day Parade coming up on Sunday 14th June.  We have space in the Manchester Library on the day.  The CoderDojo on the 10th of May is the last one before the parade.  The plan for 10th May is to try out some of the things that we will do on the parade day.

### Probably Achievable Things
* Build a float to go into the parade
* Capture the float in some way that it can be added to the server which is displaying all the floats (e.g. https://github.com/Uberi/Minetest-WorldEdit )
* Implement a server that shows all the floats in the parade -- project up on to the wall

To-do List
----------

1. Set up build infrastructure for working with the client -- Vagrant + Linux Mint
2. Implement the client world/code that will have a defined area in which to build your float, have a button to save your float out some how, finally reset the world so that the next person can build a float
3. Implement the server to display all the floats and some how animate them going past
4. Implement the code to add the saved floats into the parade
5. Implement some code to handle what happens when you get too many floats in the parade


Done List
----------
1. Add the WorldEdit mod to the CoderDojo game pack



Float Creation Client
---------------------

The float creation client is a stand-alone PC running Minetest with the parade game pack installed.  The PC is expected to be running Linux (probably Mint).  The cycle for the usage of the float creating client is as follows:

1. New user arrives as the PC and is presented with a well defined cuboid (30W x 15D x 30H) within which they have to create their float
2. The user builds their float in Minetest within the bounds of the defined area
3. When they are happy with their creation they press a button to say they want to add their float to the parade
4. The button triggers Minetest lua code to save out their float the a well-known folder using WorldEdit.  There needs to be a unique naming scheme to avoid float files overwriting on the server
5. The building area cuboid is reset to empty ready for the next user
6. (The client does NOT have the responsibility for getting the float added to the server.  A separate monitor process will be watching the well-known folder and will add the new float to the parade world.)


Parade Display Server
---------------------

The server should expect to read a well known folder which will contain the WorldEdit schem files which describe the floats to display.

1. The floats should be put in a line along 'Deansgate'.  Deansgate is simply a long straight line of cobble stone with a float one after the other with a suitable space in between
2. If a file is added to the folder then the server should notice the new file and add it on to the end of the row
3. If a file is removed from the folder then the server should notice and remove the float from the parade (perhaps redrawing the whole line if this is the easiest way of updating)
4. The server world should contain a single player who is standing to the side of Deansgate.  The server should automatically update the single player's location so that they move along Deansgate viewing each of the floats at a time.  At the end of the line of float the single player should teleport back to the start
5. Management of removing unwanted/old floats from the server is done manually by moving the specific files out of the well known folder

Float Transfer from Client to Server
------------------------------------

There needs to be a system to transferring client float files from the clients to the server.  The suggested initial design is that this is done by simple NFS or equivalent.  


How to help with the development
--------------------------------

1. Install Vagrant
2. Install VirtualBox
3. git clone https://github.com/McrCoderDojo/MadLabMiners.git
4. cd ManchesterDayParade
5. cd FloatClient
6. vagrant up



Lua Tutorial
------------

Sources of Lua information:

* [Lua Tutorial on GitHub](https://github.com/Jeija/minetest-modding-tutorial)
* [Lua Tutorial on Minetest dev wiki](http://dev.minetest.net/Intro)
