function pacman_running
	if test -f /var/lib/pacman/db.lck
		echo "true"
	else
		echo "false"
	end
end


