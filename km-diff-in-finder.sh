#!/bin/zsh -f

#	Part of https://github.com/tjluoma/km-diff-dropbox-duplicates
#
# 	note: the Keyboard Maestro macro assumes this file will be stored at /usr/local/bin/km-bbdiff-in-finder.sh

NAME="$0:t"

##BEGINMSG
		# This is an optional function which uses growlnotify, if installed. You
		# can find it as part of the github repo at
		# https://github.com/tjluoma/km-diff-dropbox-duplicates
	ZMSG="${HOME}/Dropbox/etc/zsh/functions/msg.f.zsh"

	if [[ -r "$ZMSG" ]]
	then
			. "$ZMSG"
	else
			msg () { echo "$NAME: $@" }
			die () { echo "$NAME: $@" ; exit 1}
	fi
#
##ENDMSG


if [ "$#" = "0" -a "$KMVAR_filePath" != "" ]
then
			# This variable is set from the Keyboard Maestro Macro 'Finder-BBDiff-Dropbox-Duplicate-Files.kmmacros'
			# if we're being called from Keyboard Maestro then re-call the script with an arg
		exec "$0" "$KMVAR_filePath"
		exit 0
fi



	# which 'diff' command do you want to use?
## Kaleidoscope
alias diff='/usr/local/bin/ksdiff'

## If you use bbedit and want to use bbdiff, uncomment this line
# alias diff='/usr/local/bin/bbdiff'


	# if the `diff` command has an option to 'wait' (ksdiff and bbdiff both use --wait)
	# and you want to use it, include it here
DIFF_WAIT='--wait'




	# how many errors have we encountered
COUNT=0

for i in $@
do

		GROWL_ID="$i"

		if [[ -f "$i" ]]
		then
				# file exists


					# Note: this regex is as precise as I think is feasible.
					# It needs to match:
					# a space, followed by:
					# a literal (
					# some combination of words which will end with "'s conflicted copy"
					# a space
					# a date in YYYY-MM-DD format
					# [OPTIONAL BUT POSSIBLE]:
					#	1. a literal (
					#	2. followed by [0-9]
					#	3. followed by a literal )
					#
					# and then a literal )
					#
					# However, if you have a file named something like "My File (draft) (Joe's conflicted copy 2013-03-12).tld"
					# this regex will remove the "(draft)" too. I never use ( ) in my filenames so I can live with that.
					#
					# Don't forget to test your regex against conflicted copies of files which normally begin with a "." too

				ORIGINAL_FILE=$(echo "$i" | sed "s# (.*'s conflicted copy [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9].*)##g")

				if [[ -e "$ORIGINAL_FILE" ]]
				then

						# First, check whether the files are identical

						if (( cmp -s "$ORIGINAL_FILE" "$i" ))
						then

								# the files are identical, so trash the "conflicted copy"

								if (( $+commands[trash] ))
								then

										# if the `trash` command is installed, use it

										trash "$i" && msg "Files are identical, trashed duplicate."

								else
										# if the trash command isn't installed, just use `mv`

										mv -f "$i" ~/.Trash/ && msg "Files are identical, mv'd duplicate to trash"
								fi


						else
									# If we found a file with the expected filename we created with that regex
									# then run our 'diff' program against it and the original file
								diff ${DIFF_WAIT} "$ORIGINAL_FILE" "$i"

						fi



				else
							# if we did not find an "original" file… well,
							# then this isn't really a duplicate or a
							# conflict, so we should rename it to the
							# original name without the extra bits added by
							# Dropbox.

						msg sticky "No $ORIGINAL_FILE found for $i"

							# Change the ID so it doesn't overwrite the previous 'sticky' message
						GROWL_ID="$i.2"

							# rename the file and then tell the user we
							# renamed the file and then show the file in
							# the Finder
						command mv -n "$i" "$ORIGINAL_FILE" && \
							msg sticky "Renamed $i:t to $ORIGINAL_FILE:t in $i:h" && \
								open -R "$ORIGINAL_FILE"

				fi

		else
					# File does not exist
				((COUNT++))

		fi
done


if [[ "$COUNT" != "0" ]]
then

		ERROR_OR_ERRORS=errors

		[[ "$COUNT" -gt "1" ]] && 		ERROR_OR_ERRORS=errors

		msg sticky "Finished but with $COUNT "

fi

exit 0
# EOF
