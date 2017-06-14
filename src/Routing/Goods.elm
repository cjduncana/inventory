module Routing.Goods exposing (goto)

import Model exposing (Model, Msg)
import Models.Brand as Brand
import Models.Dialog
import Models.Good as Good
import Models.Header as Header
import Models.Market as Market
import Routing.Routes exposing (Route(Goods))


goto : Model -> ( Model, Cmd Msg )
goto model =
    Cmd.batch
        [ Brand.getBrands model.storedData.brands
        , Good.getGoods model.storedData.goods
        , Market.getMarkets model.storedData.markets
        ]
        |> (,)
            { model
                | route = Goods
                , header = Header.goodsList
                , dialogView = Models.Dialog.newAddGoodView
            }
