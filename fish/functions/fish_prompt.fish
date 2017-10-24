function fish_prompt
  if get_status == 0
	set_color green
	printf " :) "
  else
	set_color red
	printf " :( "
  end

  printf '%s' (__fish_git_prompt)
  set_color green
  echo -n (prompt_pwd)
  echo '> '
end
