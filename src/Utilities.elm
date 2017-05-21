module Utilities exposing (doCommand, isEmpty)


doCommand : String -> Cmd msg -> Cmd msg
doCommand name cmd =
    if String.isEmpty name then
        Cmd.none
    else
        cmd


isEmpty : Maybe a -> Bool
isEmpty maybe =
    case maybe of
        Just _ ->
            False

        Nothing ->
            True
