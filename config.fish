if status is-interactive
    # Commands to run in interactive sessions can go here

    set fish_color_error red --bold
    set fish_color_command green --bold
    set fish_color_quote yellow
    
    
    #fish_logo 
    function fish_greeting
        fish_logo yellow blue #magenta
    end 

    #setting the title of the terminal
    function set_title
        set -l title $argv[1]
        function fish_title --inherit-variable title
        echo "$title"
        end 
    end 

    # name: sashimi
    function fish_prompt
    set -l last_status $status

    set -l cyan (set_color -o fffbb6) #middle ~ 
    set -l green (set_color -o fdfffd) #outer 
    set -g normal (set_color 3366ff) #first inner 
    
    #3 arrows green version
    #set -l cyan (set_color -o b0f89b) #middle ~ green
    #set -l green (set_color -o fdfffd) #outer 
    #set -g normal (set_color 6be41b) #first inner 

    # set -l green (set_color -o ef8af0) #middle 
    # set -l yellow (set_color -o ee1122) #outer 
    # set -g cyan (set_color magenta) #first 

    #pink red version
    # set -l cyan (set_color -o ef8af0) #middle 
    # set -l green (set_color -o ee1122) #outer - red 
    # set -g normal (set_color magenta) #first 

    set -l yellow (set_color -o yellow) #color of x 
    set -g red (set_color -o bee51a) #github branch color
    set -g blue (set_color -o fff900) #github "main" color

    set -l ahead (_git_ahead)
    set -g whitespace ' '

    if test $last_status = 0
        set initial_indicator "$green◆"
        set status_indicator "$normal❯$cyan❯$green❯"
    else
        set initial_indicator "$red✖ $last_status"
        set status_indicator "$red❯$red❯$red❯"
    end
    set -l cwd $cyan(basename (prompt_pwd))

    if [ (_git_branch_name) ]

        if test (_git_branch_name) = 'master'
        set -l git_branch (_git_branch_name)
        set git_info "$normal git:($red$git_branch$normal)"
        else
        set -l git_branch (_git_branch_name)
        set git_info "$normal git:($blue$git_branch$normal)"
        end

        if [ (_is_git_dirty) ]
        set -l dirty "$yellow ✗"
        set git_info "$git_info$dirty"
        end
    end

    # Notify if a command took more than 5 minutes
    if [ "$CMD_DURATION" -gt 300000 ]
        echo The last command took (math "$CMD_DURATION/1000") seconds.
    end

    echo -n -s $initial_indicator $whitespace $cwd $git_info $whitespace $ahead $status_indicator $whitespace
    end

    function _git_ahead
    set -l commits (command git rev-list --left-right '@{upstream}...HEAD' 2>/dev/null)
    if [ $status != 0 ]
        return
    end
    set -l behind (count (for arg in $commits; echo $arg; end | grep '^<'))
    set -l ahead  (count (for arg in $commits; echo $arg; end | grep -v '^<'))
    switch "$ahead $behind"
        case ''     # no upstream
        case '0 0'  # equal to upstream
        return
        case '* 0'  # ahead of upstream
        echo "$blue↑$normal_c$ahead$whitespace"
        case '0 *'  # behind upstream
        echo "$red↓$normal_c$behind$whitespace"
        case '*'    # diverged from upstream
        echo "$blue↑$normal$ahead $red↓$normal_c$behind$whitespace"
    end
    end

    function _git_branch_name
    echo (command git symbolic-ref HEAD 2>/dev/null | sed -e 's|^refs/heads/||')
    end

    function _is_git_dirty
    echo (command git status -s --ignore-submodules=dirty 2>/dev/null)
    end
    # End Sashimi Script 

end
