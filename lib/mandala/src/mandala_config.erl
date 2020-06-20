-module(mandala_config).
-behaviour(gen_server).

-export([new/1, delete/1, get/1, get/2, put/2]).
-export([start_link/0, init/1, handle_call/3, handle_cast/2]).

-define(SERVER, ?MODULE).

-record(mandala_config_state, {}).

%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
  {ok, #mandala_config_state{}}.

handle_call(_Request, _From, State = #mandala_config_state{}) ->
  {reply, ok, State}.

handle_cast(_Request, State = #mandala_config_state{}) ->
  {noreply, State}.

%%%===================================================================
%%% Export functions
%%%===================================================================

new(Opts) ->
  Tab = ets:new(?MODULE, [named_table, public, {read_concurrency, true}]),
  true = ets:insert_new(?MODULE, Opts),
  Tab.

delete(?MODULE) ->
  ets:delete(?MODULE).

get(Key) ->
  [{_, Value}] = ets:lookup(?MODULE, Key),
  Value.

get(Key, Default) ->
  try ets:lookup(?MODULE, Key) of
    [{_, Value}] -> Value;
    [] -> Default
  catch
    _:_ -> Default
  end.

put(Key, Value) ->
  gen_server:call(?MODULE, {put, Key, Value}).

%%%===================================================================
%%% Internal functions
%%%===================================================================
