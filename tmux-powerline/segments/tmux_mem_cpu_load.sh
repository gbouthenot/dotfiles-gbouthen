# Print out Memory, cpu and load using https://github.com/thewtex/tmux-mem-cpu-load

run_segment() {
	type ${TMUX_POWERLINE_DIR_HOME}/tmux-mem-cpu-load >/dev/null 2>&1
	if [ "$?" -ne 0 ]; then
		return
	fi

	stats=$(${TMUX_POWERLINE_DIR_HOME}/tmux-mem-cpu-load 4 5)
	if [ -n "$stats" ]; then
		echo "$stats";
	fi
	return 0
}
