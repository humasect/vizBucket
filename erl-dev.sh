#/bin/sh -x

/opt/bin/erl -pa $PWD/ebin $PWD/*/ebin \
    -sname nsv-dev \
    -setcookie aoeuaoeu \
    -boot start_sasl -config erl.config \
    -eval 'code:load_abs("ebin/user_default").'


#    -eval 'nsv:start().'
