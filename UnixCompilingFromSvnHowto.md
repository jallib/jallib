# Using the SVN repository as library for JALV2 #

You have checked out your repository and now you have a lot of directories in `/Users/me/jalv2/jallib`. How do you use them?

Like this:

```
jalv2 -s `find /Users/me/jalv2/jallib  -type d | grep -v \.svn  | tr '\n' \;` prog.jal
```
Where `/Users/me/jalv2/jallib` points to your repository. If your directory is different, modify this part. prog.jal is the jal program you are trying to compile. This command works in every directory. Mind the backward quotes, please. Don't mind the color: GoogleWiki turns green with envy when seeing backward quotes.


## PATH ##

Take care that the jalv2 compiler is somewhere on your PATH. If you are on a Mac, you probably installed a lot of stuff in `/opt/local/bin` if you used Macports. This is a fine location to store a copy of the compiler executable. On other nixes you might want to add it to `/user/local/bin`.

`sudo cp jalv2 /opt/local/bin`

## compiling shell script ##

Now if you are tired of typing above command to invoke the compiler, make a shell script named "j2" which contains:
```
jalv2 -s `find /Users/me/jalv2/jallib  -type d | grep -v \.svn  | tr '\n' \;` $*
```
the last addition makes sure it feeds all your command line arguments to the compiler. Again, modify the directory. It is custom to have your shell scripts in your own `~/bin` directory, add this to your PATH in your `.profile` file.

Dont forget to make the shell scripts executable:

`chmod +x j2`


## programming shell script ##


The command to program the hex file can also be put in a shell script, for instance named xw:

`python ~/freebsd/python/xwisp.py port /dev/tty.usbserial $*`

Here too, point to the directory that houses the `xwisp.py` file. Put the `serialposix.py` file in that directory too. Oh, and use the serial port name your el-cheapo USB-serial converter generates. Make sure it exists in `/dev`

This script should be executable as well:

`chmod +x xw`

Now you can compile with:

`j2  jal_prog.jal`

and program with:

`xw go jal_prog.hex`

Neat, huh?