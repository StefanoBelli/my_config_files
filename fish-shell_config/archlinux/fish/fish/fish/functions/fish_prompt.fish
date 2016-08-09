function fish_prompt

	if get_status == 0
		set_color green
		printf " :) "
	else
		set_color red
		printf " :( " 
	end

	set_color yellow
	printf $USER
	set_color red
	printf ':'
	set_color green
	printf (prompt_pwd)
	set_color blue
	printf '%s' (__fish_git_prompt)

	printf '\n'
	printf ' →  '
end
