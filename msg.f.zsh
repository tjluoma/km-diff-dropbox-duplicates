
msg () {

	if [ "$1" = "sticky" ]
	then
			shift
			STICKY="yes"
			EXIT='0'
			[[ "$NAME" == "" ]] && NAME='[msg]'

	elif [ "$1" = "die" ]
	then
			shift
			STICKY='yes'
			EXIT='1'
			[[ "$NAME" == "" ]] && NAME='[die]'

	else
			# if NOT sticky and not die
			STICKY="no"
			EXIT='0'
			[[ "$NAME" == "" ]] && NAME='[msg]'

	fi

	if [[ "$#" == "0" ]]
	then
				# set MESSAGE to stdin
			MESSAGE=`cat -`
	else
				# set MESSAGE to arguments
			MESSAGE="`echo $@`"
	fi

		# if the LOGS variable isn't set, use the Desktop
	[[ "$LOGS" == "" ]] && LOGS="$HOME/Desktop"

		# if `timestamp` isn't defined, use `date`
	which timestamp >/dev/null || timestamp () { date '+%F--%H.%M.%S' }

		# send MESSAGE to stdout
	echo "${NAME}@${HOST}: ${MESSAGE} [Time: `timestamp`] " | tee -a "$LOGS/msg.txt"

	if (( $+commands[growlnotify] )) 	# if 'growlnotify' is in $PATH then
	then

		if [[ "$STICKY" == "yes" ]] 	# if sticky then
		then							# set growlnotify to sticky

				GN_STICKY='--sticky'
		else
				GN_STICKY=''
				GN_IMAGE=''
		fi

			# note that I can define "$GROWL_APP" in scripts to choose a different app icon
			# similarly I can use $GROWL_ID if I wan to specify a specific ID for the Growl alert
			# which is handy if you are using 'sticky' to keep an alert around for awhile and then
			# replace it with another message when a process completes.
		growlnotify \
			--appIcon "${GROWL_APP-Growl}" \
			$GN_STICKY \
			--identifier "${GROWL_ID-EPOCHSECONDS}" \
			--message "$MESSAGE" \
			"$NAME"
##
		if [ "$EXIT" = "1" ]
		then

			tput bel 2>/dev/null	# sound terminal beep

			exit 1
		fi
##

	fi # if growlnotify is installed
}

alias die='msg die'

# @todo - check on zsh list for way to use SHLVL to use return vs exit

# END msg/sticky

#DBURL  =
