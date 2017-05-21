module Updates.Markets exposing (update)

import Model exposing (Model, Msg)
import Models.Market exposing (Markets)


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
