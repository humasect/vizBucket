%%%-------------------------------------------------------------------
%%% @author Lyndon Tremblay <humasect@gmail.com>
%%% @copyright (C) 2010, Lyndon Tremblay
%%% @doc
%%%
%%% @end
%%% Created : 22 Nov 2010 by Lyndon Tremblay <humasect@gmail.com>
%%%-------------------------------------------------------------------

-define(METHOD, ?PYTHOD_METHOD).

%%%------------------------
%%% methods
%%%------------------------

%% regular erlang method (ported from python)
-define(NATIVE_METHOD, nsv_bucketctl).

%% python method
-define(PYTHON_METHOD, nsv_bucketctl_py).

%%%------------------------
%%% protocol
%%%------------------------

-define(CMD_STAT, 16#10).
-define(REQ_PKT_FMT, <<">BBHBBHIIQ">>).
-define(REQ_MAGIC_BYTE, <<16#80>>).


