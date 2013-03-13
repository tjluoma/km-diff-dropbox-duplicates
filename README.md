km-diff-dropbox-duplicates
==========================

A Keyboard Maestro macro (and shell script) to compare a Dropbox "Conflicted Copy" file with its original

[Previously], I showed how I find Dropbox duplicates (or "conflicted copies") using launchd and a saved Spotlight search.

But then once I have found the file that I want to compare, I use [Kaleidoscope] to compare them. This is done by way of the command line tool `/usr/local/bin/ksdiff`.

You could use use `bbdiff` from [BBEdit]. Just look for the line

	alias diff='/usr/local/bin/ksdiff'

and change it to

	alias diff='/usr/local/bin/bbdiff'

or any other program which will accept two file paths.

### It doesn't just let you compare them, it will rename the file if you want.

Say you have two files such as "foo.doc" and "foo (TJ Luoma's conflicted copy 2013-03-12).doc".

You look at them and decide that you want to use the "foo (TJ Luoma's conflicted copy 2013-03-12).doc" one. What do you do? Well, I generally delete the "foo.doc" and then rename the 'conflicted copy' so that it no longer has the 'conflicted copy' part of the filename.

The script will do that for you too.

Simply delete the original file (in this example, "foo.doc") and then call the Keyboard Maestro macro again. When the script realizes that the original file no longer exists, it will rename the 'conflicted copy' file to have the original name.

(Obviously if you decide that you want to keep the "foo.doc" file, just delete the other one.)


[BBEdit]: http://www.barebones.com/bbedit

[Kaleidoscope]: http://www.kaleidoscopeapp.com

[Previously]: https://github.com/tjluoma/launchd-check-for-dropbox-conflicts
