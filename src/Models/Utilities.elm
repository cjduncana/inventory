module Models.Utilities exposing (commandIfEmpty)


commandIfEmpty : Cmd msg -> List a -> Cmd msg
commandIfEmpty command list =
    if List.isEmpty list then
        command
    else
        Cmd.none
