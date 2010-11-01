%%%-------------------------------------------------------------------
%%% @author Lyndon Tremblay <humasect@gmail.com>
%%% @copyright (C) 2010, Lyndon Tremblay
%%% @doc
%%%
%%% @end
%%% Created : 27 Sep 2010 by Lyndon Tremblay <humasect@gmail.com>
%%%-------------------------------------------------------------------
-module(nsv_bucketctl).
-author('humasect@gmail.com').
-behaviour(gen_server).

%% API
-export([start_link/0, get_info/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

-record(state, {python_pid, http_pid}).

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([]) ->
    %%Pid = python:start_link("python -u port.py mc_client"),
    %%python:exec("sys.path.append('~s')", [nsv_appsup:get_env(ctl_path)]),
    Pid = undefined,
    {ok, #state{python_pid = Pid}}.

handle_call({list, Server}, _From, State) ->
    %%[Host,Port] = string:tokens(Server, ":"),
    %%Result = python:exec("self.json_stats('~s', ~s)", [Host,Port]),
    Result = ok,
    {reply, Result, State}.
%handle_call(vinfo, _From, State) ->
%    {reply, get_info(), State}.

handle_info(Info, State) ->
    io:format("got info: ~p~n", Info),
    {noreply, State}.

terminate(_Reason, #state{}) ->
    %%python:stop(),
    io:format("----- nsv_bucketctl stopped~n"),
    %% gen_tcp:close(Sock),
    ok.

handle_cast(_Msg, State) -> {noreply, State}.
code_change(_OldVsn, State, _Extra) -> {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

connect() ->
    Host = nsv_appsup:get_env(ctl_host),
    Port = nsv_appsup:get_env(ctl_port),
    {ok, Sock} = gen_tcp:connect(Host, Port, 
                                 [binary, {packet, 0}]),
    Sock.

send_cmd(Sock, Cmd, Key, Value, Opaque, ExtraHeader, Cas) ->
    ok.%gen_tcp:send(Sock, ).

get_info() ->
    Host = nsv_appsup:get_env(info_host),
    Port = nsv_appsup:get_env(info_port),
    Url = io_lib:format("http://~s:~p/pools/default/buckets/default",
                        [Host, Port]),
    io:format("info..... ~p~n", [lists:flatten(Url)]),
    {ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}} =
        httpc:request(get, {lists:flatten(Url), []}, [], []),

    Body.

