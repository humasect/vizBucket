%% -*- erlang -*-

{application, nsv,
 [{description, "NorthScale vbucketclt Proxy"},
  {vsn, "1.0"},

  {modules, [nsv_appsup,
             %%nsv_app, nsv_sup,
             nsv_bucketctl]},
  {registered, [nsv_bucketctl]},
  {mod, {nsv_appsup, []}},

  {env, [{web_port, 8081},
         {ctl_path, "/opt/membase/bin/ep_engine/management/"},
         
         {ctl_host, "localhost"},
         {ctl_port, 11210},

         {info_host, "localhost"},
         {info_port, 8091}
        ]},

  {applications, [kernel, stdlib, sasl, inets]}
 ]}.

