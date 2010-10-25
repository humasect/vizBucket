%%%-------------------------------------------------------------------
%%% @author Lyndon Tremblay <humasect@gmail.com>
%%% @copyright (C) 2010, Lyndon Tremblay
%%% @doc
%%%
%%% @end
%%% Created : 27 Sep 2010 by Lyndon Tremblay <humasect@gmail.com>
%%%-------------------------------------------------------------------
-module(nsv_mod_bucket).
-author('humasect@gmail.com').

%% inets module callbacks
-export([do/1, load/2, remove/1]).

-include("httpd.hrl").

%%%===================================================================
%%% inets module callbacks
%%%===================================================================

do(ModData = #mod{request_uri=Uri}) ->
    Path = filename:split(Uri),
    case Path of
        ["/","bucket","vinfo"] ->
            {break, [{response, {200,nsv_bucketctl:get_info()}}]};
        ["/","bucket",Method,Server] ->
            Result = gen_server:call(nsv_bucketctl,
                                     {list_to_atom(Method), Server}),
            %% io:format("bucket: ~p~n", [Method]),
            %% {ok,Hostname} = inet:gethostname(),
            %% Cmd = io_lib:format("~s ~s:11210 ~s",
            %%                 [nsv_app:get_env(ctl_cmd), Hostname, Method]),
            %% Result = os:cmd(Cmd),
            {break, [{response, {200,Result}}]};
        _Else ->
            {proceed, ModData#mod.data}
    end.

load(_Line, _AccIn) -> ok.
remove(_ConfigDB) -> ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================
