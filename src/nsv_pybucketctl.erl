%%%-------------------------------------------------------------------
%%% @author Lyndon Tremblay <humasect@gmail.com>
%%% @copyright (C) 2010, Lyndon Tremblay
%%% @doc
%%%
%%% @end
%%% Created : 27 Sep 2010 by Lyndon Tremblay <humasect@gmail.com>
%%%-------------------------------------------------------------------
-module(nsv_pybucketctl).
-author('humasect@gmail.com').
-behaviour(gen_server).

%% API
-export([start_link/0, get_info/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

-include("vizbucket.hrl").

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
    Pid = python:start_link(
            io_lib:format("python -u ~s mc_client",
                          [filename:join(code:get_priv(nsv))])
           ),
    python:exec("sys.path.append('~s')", [nsv_appsup:get_env(ctl_path)]),
    %%Host = nsv_appsup:get_env(ctl_host),
    %%Port = nsv_appsup:get_env(ctl_port),
    %%python:exec("self.connect('~s', ~p)", [Host,Port]),
    {ok, #state{python_pid = Pid}}.

handle_call({list, Server}, _From, State) ->
    [Host,Port] = string:tokens(Server, ":"),
    Result = python:exec("self.json_stats('~s', ~s)", [Host,Port]),
    {reply, Result, State}
        ;
handle_call(vinfo, _From, State) ->
    {reply, get_info(), State}.

handle_info(Info, State) ->
    io:format("got info: ~p~n", Info),
    {noreply, State}.

terminate(_Reason, #state{}) ->
    io:format("----- nsv_bucketctl stopped~n"),
    python:stop(),
    %% gen_tcp:close(Sock),
    ok.

handle_cast(_Msg, State) -> {noreply, State}.
code_change(_OldVsn, State, _Extra) -> {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

-ifdef(socket_test).
get_info() ->
    Host = nsv_appsup:get_env(info_host),
    Port = nsv_appsup:get_env(info_port),
    {ok,Socket} = gen_tcp:connect(Host, Port, [binary,
                                               %%{packet,raw},
                                               {active,false}]),
    Url = "/pools/default/bucketsStreaming/default HTTP/1.1\r\n",
    Req = io_lib:format("GET ~s HTTP/1.1\r\n"
                        "User-Agent: vbucketctl\r\n"
                        "Host: ~s:~p\r\n"
                        "Accept: */*\r\n\r\n",
                        [Url, Host, Port]),
    gen_tcp:send(Socket, Req),
    Result = receive
                 {tcp, Socket, Data} -> Data;
                 Else -> io:format("get_info socket: ~p~n", [Else])
             after
                 3000 ->
                     io:format("get_info timeout. ~n")
             end,
    
    %% Result = case gen_tcp:recv(Socket, 0, 1000) of
    %%              {ok, Data} -> Data;
    %%              {error, Reason} ->
    %%                  io:format("get_info socket: ~p~n", [Reason])
    %%          end,
    gen_tcp:close(Socket),
    Result.
-endif.

get_info() ->
    Host = nsv_appsup:get_env(info_host),
    Port = nsv_appsup:get_env(info_port),
    Url = io_lib:format("http://~s:~p/pools/default/buckets/default",
                        [Host, Port]),
    io:format("info..... ~p~n", [lists:flatten(Url)]),
    {ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}} =
        http:request(get, {lists:flatten(Url), []}, [], []),
    %% Body = receive
    %%            {http, {_RequestId, {_Version,_Header,Result}}} -> Result
    %%        after
    %%            5000 -> "{}"
    %%        end,
    
    Body.
