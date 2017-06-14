module Routing.Markets exposing (goto)

import Model exposing (Model, Msg)
import Models.Dialog exposing (DialogView(AddMarket))
import Models.Header as Header
import Models.Market as Market
import Routing.Routes exposing (Route(Markets))


goto : Model -> ( Model, Cmd Msg )
goto model =
    Market.getMarkets model.storedData.markets
        |> (,)
            { model
                | route = Markets
                , header = Header.marketsList
                , dialogView = AddMarket ""
            }
