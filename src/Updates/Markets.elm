module Updates.Markets exposing (delete, update)

import Model exposing (Model, Msg)
import Models.Market as Market exposing (Market, Markets)
import Models.Snackbar exposing (Payload(DeletedMarket))
import Updates.Utilities as UpdateUtils


update : Markets -> Model -> ( Model, Cmd Msg )
update markets model =
    model.storedData
        |> (\data -> { data | markets = markets })
        |> UpdateUtils.updateStoredData model


delete : Market -> Model -> ( Model, Cmd Msg )
delete market model =
    Market.deleteMarket market.uuid
        |> UpdateUtils.addSnackbar model market.name (DeletedMarket market)
