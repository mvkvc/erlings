-module(priority).
-export([start/0,
         send_vip/2,
         send_normal/2]).
 -include_lib("eunit/include/eunit.hrl").

priority_process_msg(Msg) ->
    io:format("Processing importante msg: ~p~n",[Msg]),
    timer:sleep(500). % only for being able to produce faster than cusume (testing...)

priority_loop_vip(State) ->
    receive 
        {vip,Msg} ->
            priority_process_msg(Msg),
            priority_loop_vip(State)
    after 0 ->
            priority_loop(State)
    end.

priority_loop(State) ->
    receive 
        {normal,{Pid,exit}} ->
            Pid ! exit;
        {normal,Msg} ->
            io:format("normal msg : ~p~n",[Msg]),
            priority_loop(State);
        {vip,Msg}->
            priority_process_msg(Msg),
            priority_loop_vip(State);
        {ready,Pid} ->
            Pid ! read %end test
    end.

start() ->
    spawn(fun() -> priority_loop(state_place_holder) end).

send_vip(Pid,Msg) ->
    Pid ! {vip,Msg}.

send_normal(Pid,Msg) ->
    Pid ! {normal,Msg}.

send_test() ->
    Pid = start(),
    send_normal(Pid, "NORMAL1"),
    send_vip(Pid,"VIP2"),
    send_vip(Pid,"VIP3"),
    send_normal(Pid,"NORMAL4"),
    send_normal(Pid,"NORMAL5"),
    send_normal(Pid,"NORMAL6"),
    send_vip(Pid,"VIP7"),
    send_vip(Pid,"VIP8"),
    send_normal(Pid,{self(),exit}),
    receive
        exit -> ok
    end.