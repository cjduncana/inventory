module Updates.List exposing (delete)

import Model exposing (Model, Msg)
import Models.Brand as Brand
import Models.List exposing (ListObject, ListType(..))
import Models.Market as Market


delete : ListType ListObject -> Model -> ( Model, Cmd Msg )
delete listType model =
    case listType of
        Brand brand ->
            ( model, Brand.deleteBrand brand.id )

        Market market ->
            ( model, Market.deleteMarket market.id )
