function fish_prompt
  if get_status == 0
	  set_color green
		printf "[ :) ]"
	else
	  set_color red
		printf "[ :( ]"
	end

	set_color yellow
	printf $USER
	set_color red
	printf "@"
	set_color yellow
	printf (cat /etc/hostname)
	set_color red
	printf ':'
	set_color green
	echo (prompt_pwd)
	set_color blue
	echo '> '
end
