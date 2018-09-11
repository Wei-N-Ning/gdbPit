

# a production example looks like this:
# note the nasty nested if-statements
# there seems no good way to implement a "early out" mechanism using 
# gdb script


cat >/dev/null <<"EOF"
b somewhere/somefile.cc:444
commands
p this->m_name
p ...
if m_param.size() > 1
    if m_param[0] == ...
        if m_param[0].xx.xx 
            p something....
            echo label label\n
            p something....
            echo label label\n
        end
    end
end
end
EOF

