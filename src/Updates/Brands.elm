module Updates.Brands exposing (update)

import Model exposing (Model, Msg)
import Models.Brand exposing (Brands)


update : Brands -> Model -> ( Model, Cmd Msg )
update brands model =
    let
        storedData =
            model.storedData

        storedData_ =
            { storedData | brands = brands }

        model_ =
            { model | storedData = storedData_ }
    in
        ( model_, Cmd.none )
