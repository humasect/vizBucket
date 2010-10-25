%%%-------------------------------------------------------------------
%%% @author Lyndon Tremblay <humasect@gmail.com>
%%% @copyright (C) 2010, Lyndon Tremblay
%%% @doc
%%%
%%% @end
%%% Created : 27 Sep 2010 by Lyndon Tremblay <humasect@gmail.com>
%%%-------------------------------------------------------------------
-module(nsv).
-author('humasect@gmail.com').

%% API
-export([start/0, stop/0]).
-export([web_config/1]).

%%%===================================================================
%%% API
%%%===================================================================

start() ->
    inets:start(),
    application:load(nsv),
    inets:start(httpd, ?MODULE:web_config(inets)),
    application:start(nsv).

stop() ->
    application:stop(nsv),
    Pid = proplists:get_value(httpd, inets:services()),
    inets:stop(httpd, Pid),
    inets:stop().

%%%===================================================================
%%% Internal functions
%%%===================================================================

web_config(inets) ->
    {ok,Cwd} = file:get_cwd(),
    {ok,Hostname} = inet:gethostname(),
    [{server_root, filename:join(Cwd, "log")},
     {document_root, filename:join(Cwd, "htdocs")},
     {server_name, Hostname},
     {port, nsv_appsup:get_env(web_port)},
     {bind_address, any},

     {error_log, "error.log"},
     {security_log, "security.log"},
     {transfer_log, "transfer.log"},

     {max_keep_alive_requests, 4},

     {mime_types, [{"html","text/html"},
                   {"htm","text/html"},
                   {"svg","image/svg+xml"}]},
     {directory_index, ["index.html"]},
     {server_admin, "humasect@gmail.com"},

     %% mod_ssi before mod_actions
     {modules, [mod_alias, mod_auth, mod_actions, mod_cgi,
                nsv_mod_bucket,
                mod_dir, 
                mod_get, mod_head, mod_log, mod_disk_log,
                mod_htaccess, mod_include]}
    ].
