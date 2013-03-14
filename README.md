km-diff-dropbox-duplicates
==========================

A Keyboard Maestro macro (and shell script) to compare a Dropbox "Conflicted Copy" file with its original

[Previously], I showed how I find Dropbox duplicates (or "conflicted copies") using launchd and a saved Spotlight search.

But that's only getting us part of the way to where we need to go.

When I find a "conflicted copy", there are several things I want to know:

**Q:	Does the non-"conflicted copy" version still exist?**

**If yes:** Are they identical? *Yes?* Put the 'conflicted copy' in the trash. *No?* Show me a comparison between them.

**If no conflicted copy exists:** rename the 'conflicted copy' to the original filename without the extra parts.

### BYOD (Bring Your Own Diff)

Assuming that two files exist (one a "conflicted copy" and one 'original'), I want to compare them.

Traditionally the tool for doing this is `diff` but it's really only useful for comparing text files.  Since Dropbox can compare lots of other kinds of files, I need a better tool to compare them.

My `diff` tool of choice is [Kaleidoscope] which I invoke using its command line tool: `/usr/local/bin/ksdiff`.

There are other options. For example, if you wanted to use `bbdiff` from [BBEdit]. Just edit the line in [km-diff-in-finder.sh]

	alias diff='/usr/local/bin/ksdiff'

to

	alias diff='/usr/local/bin/bbdiff'


### After you have compared them, the macro can help you rename the file, if needed

Say you have two files such as "foo.doc" and "foo (TJ Luoma's conflicted copy 2013-03-12).doc".

You look at them and decide that you want to use the "foo (TJ Luoma's conflicted copy 2013-03-12).doc" one. What do you do next? Well, I generally delete the "foo.doc" and then rename the 'conflicted copy' so that it no longer has the 'conflicted copy' part of the filename.

The script will do that for you too.

Simply delete the original file (in this example, "foo.doc") and then call the Keyboard Maestro macro again. When the script realizes that the original file no longer exists, it will rename the 'conflicted copy' file to have the original name.

(Obviously if you decide that you want to keep the "foo.doc" file, just delete the other one.)

### You don't *have* to use Keyboard Maestro for this.

[km-diff-in-finder.sh] can be called directly from the command line. Just give it the filename (or full path) of a 'conflicted copy' file, and it will work on that file.

Or, combine [km-diff-in-finder.sh] with my previous script [dropbox-launchd-conflicted-copy.sh] and you can automatically process all of your Dropbox duplicates at once.

**Note:** using this feature assumes that your chose `diff` program supports the `--wait` flag or equivalent (if different, change `DIFF_WAIT=` in [km-diff-in-finder.sh]).

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
