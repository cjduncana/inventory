module Routing.Goods exposing (goto)

import Dropdown
import Model exposing (Model, Msg)
import Models.Brand as Brand
import Models.Dialog exposing (DialogView(AddGood))
import Models.Good as Good exposing (ImageURI(NoImage))
import Models.Header as Header
import Models.Market as Market
import Routing.Routes exposing (Route(Goods))


goto : Model -> ( Model, Cmd Msg )
goto model =
    let
        model_ =
            { model
                | route = Goods
                , header = Header.goodsList
                , dialogView =
                    AddGood
                        (Dropdown.newState "brand")
                        ""
                        NoImage
                        Nothing
                        []
            }

        commands =
            [ Brand.getBrands model.storedData.brands
            , Good.getGoods model.storedData.goods
            , Market.getMarkets model.storedData.markets
            ]
    in
        model_ ! commands
