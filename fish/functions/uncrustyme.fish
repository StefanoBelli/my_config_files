function uncrustyme
	set UCM_CFG $HOME/.uncrustyme.cfg
	set cnt 1
	set total 0
	set rc (ls | grep "\.$UCM_EXT\$")

	if test -f $UCM_CFG 
		printf " \033[32m==>\033[0m Found configuration file: $UCM_CFG\n"
	else
		printf " \033[31m==>\033[0m Cannot find configuration file: $UCM_CFG\n"
		return 1
	end

	printf " \033[34m==>\033[0m Counting objects..."
	for i in $rc
		set total (math $total + 1)
	end

	echo

	if math "$total == 0" >/dev/null
		printf "  \033[31m==>\033[0m Cannot find any match with \".$UCM_EXT\" \n"
		return 2
	end

	for i in $rc
		printf " \033[33m==>\033[0m [$cnt/$total] Doing work on $i\n"
		uncrustify -c $UCM_CFG -f $i -o $i.$UCM_EXT 2>/dev/null >/dev/null ;and printf "  \033[32m==>\033[0m OK!\n" ;or printf "  \033[31m==>\033[0m FAILED!\n"
		mv $i.$UCM_EXT $i
		set cnt (math $cnt + 1)
	end
end