module Updates.Goods exposing (delete, update)

import Material.Snackbar as Snackbar
import Model exposing (Model, Msg)
import Models.Good as Good exposing (Good, Goods)
import Models.Snackbar exposing (Payload(DeletedGood))
import Updates.Utilities as UpdateUtils


update : Goods -> Model -> ( Model, Cmd Msg )
update goods model =
    model.storedData
        |> (\data -> { data | goods = goods })
        |> UpdateUtils.updateStoredData model


delete : Good -> Model -> ( Model, Cmd Msg )
delete good model =
    addSnackbar model (Good.getName good) (DeletedGood good) <|
        Good.deleteGood (Good.getUuid good)


addSnackbar : Model -> String -> Payload -> Cmd Msg -> ( Model, Cmd Msg )
addSnackbar model name payload command =
    let
        message =
            name ++ " has just been deleted."

        snackbar =
            Snackbar.snackbar payload message "UNDO"

        ( snackbarModel, snackbarCommand ) =
            Snackbar.add snackbar model.snackbar

        model_ =
            { model | snackbar = snackbarModel }

        command_ =
            Cmd.map Model.SnackbarMsg snackbarCommand
    in
        model_ ! [ command, command_ ]
