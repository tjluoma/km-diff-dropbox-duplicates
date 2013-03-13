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

(Just remember that conflicted files can be all sorts of files, and make sure that your `diff` program can handle it if they aren't just plain text files. That's why I use [Kaleidoscope] by default.)

### It doesn't just let you compare them, it will rename the file if you want.

Say you have two files such as "foo.doc" and "foo (TJ Luoma's conflicted copy 2013-03-12).doc".

You look at them and decide that you want to use the "foo (TJ Luoma's conflicted copy 2013-03-12).doc" one. What do you do? Well, I generally delete the "foo.doc" and then rename the 'conflicted copy' so that it no longer has the 'conflicted copy' part of the filename.

The script will do that for you too.

Simply delete the original file (in this example, "foo.doc") and then call the Keyboard Maestro macro again. When the script realizes that the original file no longer exists, it will rename the 'conflicted copy' file to have the original name.

(Obviously if you decide that you want to keep the "foo.doc" file, just delete the other one.)

### Use on the command line

By using [dropbox-launchd-conflicted-copy.sh] on the command line you can automatically process all of your Dropbox duplicates at once.

***Note:*** using this feature assumes that your chose `diff` program supports the `--wait` flag or equivalent (if different, change `DIFF_WAIT=` in [km-diff-in-finder.sh]).

To use these together, simply run a loop like this in Terminal:

	dropbox-launchd-conflicted-copy.sh |\
		egrep -v '^dropbox-launchd-conflicted-copy.sh' |\
			while read line
	do

		echo "Working on: $line"

		km-diff-in-finder.sh "$line"

	done

the `egrep` command tells the loop to ignore the summary line which `dropbox-launchd-conflicted-copy.sh` prints at the top of its output.  Then each matching file will be sent to the `km-diff-in-finder.sh` command.

Compare the files, then close them, and the loop will open the next pair.


[km-diff-in-finder.sh]: https://github.com/tjluoma/km-diff-dropbox-duplicates/blob/master/km-diff-in-finder.sh

[dropbox-launchd-conflicted-copy.sh]: https://github.com/tjluoma/launchd-check-for-dropbox-conflicts/blob/master/dropbox-launchd-conflicted-copy.sh

[BBEdit]: http://www.barebones.com/bbedit

[Kaleidoscope]: http://www.kaleidoscopeapp.com

[Previously]: https://github.com/tjluoma/launchd-check-for-dropbox-conflicts
