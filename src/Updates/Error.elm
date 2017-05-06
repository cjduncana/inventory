module Updates.Error exposing (..)

import Model exposing (Model, Msg)
import Models.Error exposing (Error(..))


update : Error -> Model -> ( Model, Cmd Msg )
update error model =
    let
        model_ =
            { model | error = Just error }
    in
        ( model_, Cmd.none )
