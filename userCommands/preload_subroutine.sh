
# source: wkou
# search: Gem #119 GDB Scripting

createGDBScript() {
    cat >/tmp/command.txt << "EOF"
define inspectall
    print "//// process:"
    print id().value()
    print "#### evaluator:"
    set $eval = evaluator().get()
    if $eval != 0
        print $eval->key()
        set $graph = $eval->graph()
        print "@@@@ graph:"
        if $graph != 0
            print $graph->name()
        else
            print "____"
        end
    else
        print "____"
    end
end
EOF
}

preload_script() {
    :
    
    # gdb `x_srcdir...` -command=/tmp/command.txt pid
}

