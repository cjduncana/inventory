module Models.Utilities exposing (commandIfEmpty)


commandIfEmpty : (() -> Cmd msg) -> List a -> Cmd msg
commandIfEmpty fetch list =
    if List.isEmpty list then
        fetch ()
    else
        Cmd.none
