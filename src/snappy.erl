%% Copyright 2011,  Filipe David Manana  <fdmanana@apache.org>
%% Web:  http://github.com/fdmanana/snappy-erlang-nif
%%
%% Licensed under the Apache License, Version 2.0 (the "License"); you may not
%% use this file except in compliance with the License. You may obtain a copy of
%% the License at
%%
%%  http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
%% WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
%% License for the specific language governing permissions and limitations under
%% the License.

-module(snappy).

-export([compress/1, decompress/1]).
-export([uncompressed_length/1, is_valid/1]).

-on_load(init/0).


init() ->
    SoName = case code:priv_dir(?MODULE) of
    {error, bad_name} ->
        case filelib:is_dir(filename:join(["..", "priv"])) of
        true ->
            filename:join(["..", "priv", "snappy_nif"]);
        false ->
            filename:join(["priv", "snappy_nif"])
        end;
    Dir ->
        filename:join(Dir, "snappy_nif")
    end,
    (catch erlang:load_nif(SoName, 0)),
    case erlang:system_info(otp_release) of
    "R13B03" -> true;
    _ -> ok
    end.

%%--------------------------------------------------------------------
%% @doc
%% Compresses an iolist or binary using the snappy algorithm.
%%
%% When provided with an empty binary or iolist this will return
%% {ok, <<>>} wich is a bit of a edge case, we adopt all other
%% functions to work around this.
%% @end
%%--------------------------------------------------------------------
-spec compress(iolist() | binary()) ->
                      {ok, binary()} |
                      {error, insufficient_memory | unknown}.
compress(_IoList) ->
    erlang:nif_error(snappy_nif_not_loaded).


%%--------------------------------------------------------------------
%% @doc
%% Decompresses an iolist or binary using the snappy algorithm.
%%
%% We handle the special case of an empty binary as true since
%% {@link compress/1} can return an empty binary when fed with an
%% empty binary.
%% @end
%%--------------------------------------------------------------------
-spec decompress(iolist() | binary()) ->
                        {ok, binary()} |
                        {error, data_not_compressed |
                         insufficient_memory |
                         corrupted_data |
                         unknown}.
decompress(<<>>) ->
    <<>>;
decompress(_IoList) ->
    erlang:nif_error(snappy_nif_not_loaded).


%%--------------------------------------------------------------------
%% @doc
%% Calculates the length after decompression for a compressed binary
%% or iolist.
%%
%% We handle the special case of an empty binary as true since
%% {@link compress/1} can return an empty binary when fed with an
%% empty binary.
%% @end
%%--------------------------------------------------------------------
-spec uncompressed_length(iolist()| binary()) ->
                                 pos_integer() |
                                 {error, data_not_compressed |
                                  unknown}.
uncompressed_length(<<>>) ->
    0;
uncompressed_length(_IoList) ->
    erlang:nif_error(snappy_nif_not_loaded).


%%--------------------------------------------------------------------
%% @doc
%% Checks weather a binary or iolist is valid snappy compressed
%% data.
%%
%% We handle the special case of an empty binary as true since
%% {@link compress/1} can return an empty binary when fed with an
%% empty binary.
%% @end
%%--------------------------------------------------------------------
-spec is_valid(iolist() | binary()) ->
                      boolean() |
                      {error, unknown}.
is_valid(<<>>) ->
    true;
is_valid(_IoList) ->
    erlang:nif_error(snappy_nif_not_loaded).
