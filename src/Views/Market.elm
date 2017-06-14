module Views.Market exposing (view)

import Html exposing (Html)
import Model exposing (Model, Msg)
import Models.Market exposing (Markets)
import Translation.Main as T
import Views.Utilities as ViewUtil


view : Model -> Markets -> Html Msg
view model =
    ViewUtil.grid model Model.DeleteMarket
        |> ViewUtil.showList T.noMarkets
