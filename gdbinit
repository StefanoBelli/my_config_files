layout reg
set tui active-border-mode bold
set tui border-kind ascii
tui disable
set confirm off
set verbose off
set follow-fork-mode child
set print array on
set history filename ~/.gdbhistory
set history save
set data-directory ~/.gdb_data
set editing
set width 0
set height 0
set print asm-demangle
set print null-stop
set print inferior-event
set print type nested-type-limit unlimited
set print pretty on

# thanks to CocoaBean (github.com/CocoaBean)
define flags
# OF (overflow) flag
    if (($eflags >> 0xB) & 1)
        printf "O "
        set $_of_flag = 1
    else
        printf "o "
        set $_of_flag = 0
    end
    if (($eflags >> 0xA) & 1)
        printf "D "
    else
        printf "d "
    end
    if (($eflags >> 9) & 1)
        printf "I "
    else
        printf "i "
    end
    if (($eflags >> 8) & 1)
        printf "T "
    else
        printf "t "
    end
# SF (sign) flag
    if (($eflags >> 7) & 1)
        printf "S "
        set $_sf_flag = 1
    else
        printf "s "
        set $_sf_flag = 0
    end
# ZF (zero) flag
    if (($eflags >> 6) & 1)
        printf "Z "
	set $_zf_flag = 1
    else
        printf "z "
	set $_zf_flag = 0
    end
    if (($eflags >> 4) & 1)
        printf "A "
    else
        printf "a "
    end
# PF (parity) flag
    if (($eflags >> 2) & 1)
        printf "P "
	set $_pf_flag = 1
    else
        printf "p "
	set $_pf_flag = 0
    end
# CF (carry) flag
    if ($eflags & 1)
        printf "C "
	set $_cf_flag = 1
    else
        printf "c "
	set $_cf_flag = 0
    end
    printf "\n"
end
document flags
Print flags register.
end

#python code
python

def hook_prompt(_):
    full_string = "\n"
    active_inferiors = gdb.inferiors()
    if active_inferiors[0].pid != 0:
        full_string += "\033[31m("
        if active_inferiors[0].was_attached:
            full_string += "A:"
        full_string += "{})".format(active_inferiors[0].pid)

    chosen_thread = gdb.selected_thread()
    if chosen_thread:
        full_string += "\033[34m[{}]".format(chosen_thread.num)

    try:
        current_frame = gdb.selected_frame()
        frame_name = current_frame.name()
        if not frame_name:
            frame_name = "??"
        full_string += "\033[33m|{}@\033[35m{}\033[33m|\n".format(frame_name, hex(current_frame.pc()))
    except gdb.error:
        pass

    
    full_string += "\033[1;32m>>> \033[0m"
    return full_string

def program_exits(event):
    try:
        if event.exit_code == 0:
            print("\033[1;32mProgram exited successfully\033[0m")
        else:
            print("\033[1;33mProgram exited with code: {}\033[0m".format(event.exit_code))
    except:
        pass

def breakpoint_event(event):
    breakps = gdb.breakpoints()

    try:
        reachedBreakp = event.breakpoint
        for i, breakp in enumerate(breakps):
            if reachedBreakp == breakp:
                if breakps[i+1].is_valid() and breakps[i+1].enabled and breakps[i+1].location:
                    print("\033[1;31mNext breakpoint\033[0m")
                    print("\033[31mN\033[0m:{} \033[31mL\033[0m:{}".format(breakps[i+1].number, breakps[i+1].location))
                    break
    except:
        pass

gdb.events.stop.connect(breakpoint_event)
gdb.events.exited.connect(program_exits)
gdb.prompt_hook = hook_prompt

end
