module Updates.List exposing (delete)

import Model exposing (Action(..), ActionType(..), Model, Msg)
import Models.Brand as Brand
import Models.List exposing (ListObject, ListType(..))
import Models.Market as Market


delete : ListType ListObject -> Model -> ( Model, Cmd Msg )
delete listType model =
    case listType of
        Brand brand ->
            let
                model_ =
                    { model | lastAction = BrandAction Delete }
            in
                ( model_, Brand.deleteBrand brand.id )

        Market market ->
            let
                model_ =
                    { model | lastAction = MarketAction Delete }
            in
                ( model_, Market.deleteMarket market.id )
