module Routing.Home exposing (goto)

import Model exposing (Model, Msg)
import Models.Dialog exposing (DialogView(Default))
import Models.Header as Header
import Routing.Routes exposing (Route(Home))


goto : Model -> ( Model, Cmd Msg )
goto model =
    let
        model_ =
            { model
                | route = Home
                , header = Header.init
                , dialogView = Default
            }
    in
        ( model_, Cmd.none )
