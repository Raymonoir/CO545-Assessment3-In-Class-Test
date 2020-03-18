-module(ict).
-compile(export_all).

%1/a
server (Token) -> 
    receive {boot,P} ->
        receive 
            skip -> server2(Token);
            {stop,P} -> P!{done,Token}
        end
    end.

server2 (Token) -> 
    receive 
        skip -> server2(Token);
        {stop,P} -> P!{done,Token} end.



%1/b
client (Server) ->
    Server!{boot,self()},
    Server!skip,
    Server!skip,
    Server!skip,
    Server!skip,
    Server!skip,
    Server!{stop,self()},
    receive {done,Y} -> io:fwrite("I got: ~w and ~w ~n",[done, Y]) end.


%1/c
runner() ->
    Server = spawn(?MODULE,server,[6]),
    Client = spawn(?MODULE,client,[Server]).


%2/a

testA (X,{F,G}) ->
    spawn(?MODULE,worker,[X,F,self(),l]),
    spawn(?MODULE,worker,[X,G,self(),r]),

    receive {Ans1,l} -> receive {Ans2,r} -> {Ans1,Ans2} end end.



worker(X,Func,Next,P) ->
    Next ! {Func(X),P}.

%2/b
test() ->
    testA(5, {fun(X) -> X+2 end, fun(Y) -> Y - 2 end}).
