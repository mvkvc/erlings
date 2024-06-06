-module(hello_pattern).

-export([hello/1]).

% - `{morning, Name}`, ignores the name and returns `morning`.
% - `{evening, Name}`, returns a tuple `{good, evening, Name}`.
% - `{night, Name}`, ignores the name and return `night`.
% - `{math_class, Number, Name}`. If the number is lower than zero, return
%   `none`, in any other case return `{math_class, Name}`.

hello({morning, Name}) ->
  morning;
hello({evening, Name}) ->
  {good, evening, Name};
hello({night, Name}) ->
  night;
hello({math_class, Number, Name}) when Number < 0 ->
  none;
hello({math_class, Number, Name}) ->
  {math_class, Name}.
