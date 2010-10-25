%%%-------------------------------------------------------------------
%%% @author Lyndon Tremblay <humasect@gmail.com>
%%% @copyright (C) 2010, Lyndon Tremblay
%%% @doc
%%%
%%% @end
%%% Created : 16 Aug 2010 by Lyndon Tremblay <humasect@gmail.com>
%%%-------------------------------------------------------------------
-module(user_default).
-author('humasect@gmail.com').
-used_by([{visionire, vre_server},
          {hoovy, val}]).

-export([help/0, rel/0, ll/0, mm/0, relcfg/0, backup/0, mkdoc/1]).
-export([scall/2, scast/2]).

backup_filename() ->
    {{Year,Month,Day},_Clock} = erlang:localtime(),
    lists:flatten(io_lib:format("~s/backup/erl-dev-~p-~p-~p.tar.gz",
                                [os:getenv("HOME"), Year, Month, Day])).

help() ->
    shell_default:help(),
    BackupStr = io_lib:format("backup()   -- create ~p~n",
                              [backup_filename()]),
    lists:foreach(fun io:format/1,
                  ["** Huma commands **~n",
                   "ll()       -- run make, and reload all modified code~n",
                   "mm()       -- list all modified modules~n",
                   "gst()      -- (run 'git status')~n",
                   "mkrel()    -- (build a release file)~n",
                   "relcfg()   -- reload application configuration~n",
                   "scall(S,V) -- gen_server:call(S, V)~n",
                   "scast(S,V) -- gen_server:cast(S, V)~n",
                   BackupStr,
                   "mkdoc(App) -- generate edoc to: ./htdocs/dev/App/edoc/~n"
                  ]).

mkdoc(AppName) ->
    {ok,Cwd} = file:get_cwd(),
    Dir = filename:join([Cwd, "htdocs", "dev", AppName, "edoc"]),
    edoc:application(AppName,
                     [{preprocess,true},
                      {dir, Dir},
                      {includes,
                       ["/opt/lib/erlang/lib/inets-5.5/src/http_server"]}]).

scall(Server, Var) ->
    gen_server:call(Server, Var).

scast(Server, Var) ->
    gen_server:cast(Server, Var).

ll() ->
    make:all(),
    lm().

rel() ->
    throw({error,not_used_or_tested}),
    Dir = "/Users/humasect/Hoovy/code/erl-dev",
    Path = Dir ++ "/ebin",
    Var = ["MYAPPS", Dir],
    systools:make_script("example", [{path,Path}, {variables,[Var]}]).

backup() ->
    Filename = backup_filename(),
    io:format("== create backup ~p ==", [Filename]),
    {ok,Cwd} = file:get_cwd(),
    erl_tar:create(Filename, [Cwd], [compressed,verbose]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The following is from
% http://www.erlang.org/pipermail/erlang-questions/2006-July/021543.html
%

relcfg() ->
     case init:get_argument(config) of
     {ok, [ Files ]} ->
         ConfFiles = [begin
                          S = filename:basename(F,".config"),
                          filename:join(filename:dirname(F),
                                        S ++ ".config")
                      end || F <- Files],
         % Move sys.config to the head of the list
         Config = lists:sort(fun("sys.config", _) -> true;
                                (_, _) -> false end, ConfFiles),

         OldEnv = application_controller:prep_config_change(),

         Apps = [{application, A, make_appl(A)}
                 || {A,_,_} <- application:which_applications()],
         application_controller:change_application_data(Apps, Config),
         application_controller:config_change(OldEnv);
     _ ->
         {ok, []}
     end.

make_appl(App) when is_atom(App) ->
     AppList  = element(2, application:get_all_key(App)),
     FullName = code:where_is_file(atom_to_list(App) ++ ".app"),
     case file:consult(FullName) of
     {ok, [{application, _, Opts}]} ->
         Env = proplists:get_value(env, Opts, []),
         lists:keyreplace(env, 1, AppList, {env, Env});
     {error, _Reason} ->
         lists:keyreplace(env, 1, AppList, {env, []})
     end.


%
% The following are from http://www.trapexit.org/forum/viewtopic.php?p=19673
%
lm() ->
    [c:l(M) || M <- mm()].

mm() ->
    modified_modules().

modified_modules() ->
    [M || {M,_} <- code:all_loaded(), module_modified(M) == true].

module_modified(Module) ->
    case code:is_loaded(Module) of
        {file,preloaded} ->
            false;
        {file,Path} ->
            CompOpts = proplists:get_value(compile, Module:module_info()),
            CompTime = proplists:get_value(time, CompOpts),
            Src = proplists:get_value(source, CompOpts),
            module_modified(Path, CompTime, Src);
        _ -> false
    end.

module_modified(Path, PrevCompTime, PrevSrc) ->
    case find_module_file(Path) of
        false ->
            false;
        ModPath -> case beam_lib:chunks(ModPath, ["CInf"]) of
                       {ok, {_, [{_, CB}]}} ->
                           CompOpts = binary_to_term(CB),
                           CompTime = proplists:get_value(time, CompOpts),
                           Src = proplists:get_value(source, CompOpts),
                           not (CompTime == PrevCompTime) and (Src == PrevSrc);
                       _ -> false
                   end
    end.

find_module_file(Path) ->
    case file:read_file_info(Path) of
        {ok,_} ->
            Path;
        _ -> % それともパスが変更した
            case code:where_is_file(filename:basename(Path)) of
                non_existing ->
                    false;
                NewPath -> NewPath
            end
    end.
