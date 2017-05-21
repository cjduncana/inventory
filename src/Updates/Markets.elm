module Updates.Markets exposing (get, update)

import Model exposing (Model, Msg)
import Models.Market as Market exposing (Markets)


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
        ( model_, Cmd.none )
