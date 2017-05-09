module Updates.List exposing (delete)

import Model exposing (Action(..), ActionType(..), Model, Msg)
import Models.Brand as Brand
import Models.List exposing (ListType(Brands, Markets))
import Models.Market as Market
import Uuid exposing (Uuid)


delete : ListType -> Uuid -> Model -> ( Model, Cmd Msg )
delete listType uuid model =
    case listType of
        Brands _ ->
            let
                model_ =
                    { model | lastAction = BrandAction Delete }
            in
                ( model_, Brand.deleteBrand uuid )

        Markets _ ->
            let
                model_ =
                    { model | lastAction = MarketAction Delete }
            in
                ( model_, Market.deleteMarket uuid )
