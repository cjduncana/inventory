module Updates.Markets exposing (get, update)

import Model exposing (Model, Msg)
import Models.Market as Market exposing (Markets)
import Routing.Routes exposing (Route(Markets))


get : Model -> ( Model, Cmd Msg )
get model =
    ( model, Market.getMarkets )


update : Markets -> Model -> ( Model, Cmd Msg )
update markets model =
    let
        storedData =
            model.storedData

        storedData_ =
            { storedData | markets = markets }

        model_ =
            { model | storedData = storedData_ }
    in
        case model.route of
            Markets _ ->
                ( { model_ | route = Markets markets }, Cmd.none )

            _ ->
                ( model_, Cmd.none )
