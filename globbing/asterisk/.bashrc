function check_cd {
	[ "${#FUNCNAME[@]}" -gt 1 ] && return # only trigger on direct user input
	CMD="${BASH_COMMAND// *}"
	ARG="${BASH_COMMAND//* }"
	if [ "$CMD" != "cd" ] && [ "$CMD" != "pushd" ]
	then
		if [ ! -f "/tmp/.good_cd" ]
		then
			cd
			fold -s <<< "This challenge resets your working directory to /home/hacker unless you change directory properly..."
		fi
		return 0
	fi

	if [ "${#ARG}" -gt 4 ]
	then
		fold -s <<< "You specified the path to '$CMD' to in more than 4 characters. Disallowed!"
		return 1
	fi

	GARG=$(compgen -G "$ARG")
	[[ $GARG == *challenge* ]] && touch /tmp/.good_cd
	return 0
}

shopt -s extdebug
set -T
trap 'check_cd' debug
