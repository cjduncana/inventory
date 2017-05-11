module Utilities exposing (doCommand)


doCommand : String -> Cmd msg -> Cmd msg
doCommand name cmd =
    if String.isEmpty name then
        Cmd.none
    else
        cmd
