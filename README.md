km-diff-dropbox-duplicates
==========================

***Summary:*** I wrote a shell script which looks at a "conflicted copy" file created by [Dropbox] and then tries to figure out what to do with it:

1. You say this is a 'conflicted copy' but is there a file with the same name (minus the 'conflicted copy' part, obviously)? If not, just rename the 'conflicted copy' file to the original filename.

2. Is the 'conflicted copy' file exactly the same as the 'original' file? If so, just put the 'conflicted copy' in the Trash.

3. If the 'conflicted copy' and the 'original' file are different, open them both in [Kaleidoscope] so I can compare them and decide which one I want to keep, or merge them.

Also, I wrote a [Keyboard Maestro] macro to let me trigger this shell script from the Finder (select one or more 'conflicted copy' files in the Finder, then press a keyboard shortcut).

**You do not _have_ to use Keyboard Maestro to use this script.** It works fine on its own from the command line. It works especially well combined with [dropbox-launchd-conflicted-copy.sh] as I'll explain below.


### Longer Explanation

[Previously], I wrote a shell script which will alert me when [Dropbox] has created a "conflicted copy" of a file.

But *finding* conflicted copies is only half of the job.

The 'hard' part is deciding what to do with them.

I realized that I was doing the same thing every time that script alerted me to conflicted copies:

1. 	Switch to Finder and run my Saved Search
2.	Select a "conflicted copy" file
3.	Right click, choose "Open Containing Folder"
4. 	Select both original and "conflicted copy" files
5.	Open them in [BBEdit] or [Kaleidoscope]

Using this script and Keyboard Maestro I can now do this:

1. 	Switch to Finder and run my Saved Search
2.	Select 'conflicted copy' and trigger macro


### BYOD (Bring Your Own Diff)

Traditionally the tool for doing this is `diff` but it's really only useful for comparing text files.  Since Dropbox can compare lots of other kinds of files, I need a better tool to compare them.

My `diff` tool of choice is [Kaleidoscope] which I invoke using its command line tool: `/usr/local/bin/ksdiff`.

There are other options. For example, if you wanted to use `bbdiff` from [BBEdit]. Just edit the line in [km-diff-in-finder.sh]

	alias diff='/usr/local/bin/ksdiff'

to

	alias diff='/usr/local/bin/bbdiff'

Just make sure that your `diff` program can handle whatever file types you're going to throw at it.

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




[Keyboard Maestro]: http://www.keyboardmaestro.com/main/




[Dropbox]: http://luo.ma/dropbox
