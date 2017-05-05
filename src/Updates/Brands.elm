module Updates.Brands exposing (get, update)

import Model exposing (Model, Msg)
import Models.Brand as Brand exposing (Brand)
import Routing.Routes exposing (Route(Brands))


get : Model -> ( Model, Cmd Msg )
get model =
    ( model, Brand.getBrands () )


update : List Brand -> Model -> ( Model, Cmd Msg )
update brands model =
    let
        storedData =
            model.storedData

        storedData_ =
            { storedData | brands = Just brands }

        model_ =
            { model | storedData = storedData_ }
    in
        case model.route of
            Brands _ ->
                ( { model_ | route = Brands (Just brands) }, Cmd.none )

            _ ->
                ( model_, Cmd.none )
