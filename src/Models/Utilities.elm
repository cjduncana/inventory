module Models.Utilities exposing (commandIfEmpty)

import Maybe.Extra as Maybe


commandIfEmpty : (() -> Cmd msg) -> List a -> Cmd msg
commandIfEmpty fetch =
    Just
        >> Maybe.filter List.isEmpty
        >> Maybe.map (always (fetch ()))
        >> Maybe.withDefault Cmd.none
