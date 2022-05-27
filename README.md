# Introduction

This is a simple wireframe renderer I made in OCaml, I did not follow 
many instructions for this, just doing what seems logically right to 
me, so it may not be the mot effecient.

Much of the code in status.ml, and installation instruction in this 
README, is borrowed from what Seth Norman wrote in our 
3110-Gravity-Final project. 



# Installation instructions for 3D Renderer 

These instructions assume that WSL and OCaml were installed using the 
instructions provided in the CS3110 textbook. These can be found at

https://cs3110.github.io/textbook/chapters/preface/install.html

Along with the above installation, we will need to install some extra libraries
and applications to run graphics through WSL. 



## Install X-server (VcXsrv)

In Windows, you will need to install an X-server for WSL to communicate with
and show graphics through, as there is not a native way to show graphics through
WSL alone.

We will use VcXsrv as our X-server. Visit 

https://sourceforge.net/projects/vcxsrv/ 

and click the green "Download" button. After a couple seconds, the installer 
for VcXsrv should begin to download. 

Open the installer. Windows should ask if the installer can make changes to your
device. Say yes, and then proceed through the default installation of VcXsrv.
(It should just be selecting "Next" and then "Install").

After VcXsrv has been installed, you should see a new desktop icon called
XLaunch. 



## Run X-server (XLaunch)

When you want to run the X-server (you have to have the server running before
you open WSL), open XLaunch.

The first screen should have "Multiple windows" selected, and "Display number"
set to -1. Select "Next".

The next screen should have "Start no client" selected. Select "Next".

On the third screen, make sure all checkboxes are checked, and select "Next".

From the final screen, you can save the configuration we just made, and run it
instead of repeating this process, but from this screen, press "Finish" to start
the X-server.

You should see an X-server icon appear in the System Tray (lower left on the
default Windows taskbar). To stop the X-server, right click the icon, and select
"Exit...". After exiting, you would need to repeat these steps or run the saved
configuration to re-run the X-server.



## Connecting WSL to X-server

Whenever you open a new WSL terminal (the X-server must be running), you will
need to set the DISPLAY variable in WSL to use the X-server.

Run the following command to set the DISPLAY variable in WSL

>`export DISPLAY=$(echo $(grep nameserver /etc/resolv.conf | sed 's/nameserver //'):0.0)`



## Package Installation in WSL

The main package needed to be installed is the OCaml graphics library.

#### Step 1: install pkg-config

>`sudo apt-get update -y`
>
>`sudo apt-get install -y pkg-config`

Run the above commands in WSL to install pkg-config.

#### Step 2: install graphics library

You can install the library in an opam switch of your choice, as long as the
switch is setup as instructed in the CS3110 Ocaml installation instructions 
mentioned previously.

>`opam update`
>
>`opam upgrade`
>
>`opam install graphics`

Run the above commands in WSL to install the graphics library.



## RUNNING THE CODE

>`make build`: builds and compiles the program
>
>`make run`: executes the main program (run `make build` first)

After typing `make run`, the program will prompt you to enter a file name. 
The files found in the data subfolder (except `system_schema.json`) are the
files you can run. Currently there is only two:

>`test_line`
>
>`cube`

When you run a file, a window will pop up with the models in the file being rendered.
To close the render, simply use the X at the top of the window. The prompt will
again ask you to run a file, so you can run another if you choose to, or you
can exit the program by typing `Q`.

Once the file is running the following buttons have these effects:

`w` : Move in the +y direction
`s` : move in the -y direction
`d` : Move in the +x direction
`a` : move in the -x direction
space bar : Move in the +z direction
`z` : move in the -z direction

`i` : rotate in the +x direction
`k` : rotate in the -x direction
`j` : rotate in the +z direction
`l` : rotate in the -z direction
`o` : rotate in the +y direction
`u` : rotate in the -y direction

`g` : rotate any models in the +z direction