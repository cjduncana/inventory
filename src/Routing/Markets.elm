module Routing.Markets exposing (goto)

import Model exposing (Model, Msg)
import Models.Dialog exposing (DialogView(AddMarket))
import Models.Header as Header
import Routing.Routes exposing (Route(Markets))
import Updates.Markets as Markets
import Utilities as Util


goto : Model -> ( Model, Cmd Msg )
goto model =
    let
        model_ =
            { model
                | route = Markets model.storedData.markets
                , header = Header.marketsList
                , dialogView = AddMarket ""
            }
    in
        if Util.isNotSuccess model.storedData.markets then
            Markets.get model_
        else
            ( model_, Cmd.none )
