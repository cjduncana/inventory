module Updates.Utilities exposing (addSnackbar, updateStoredData)

import Material.Snackbar as Snackbar
import Model exposing (Model, Msg, StoredData)
import Models.Snackbar exposing (Payload)
import Translation.Main as T


addSnackbar : Model -> String -> Payload -> Cmd Msg -> ( Model, Cmd Msg )
addSnackbar model name payload command =
    T.deletedName name
        |> flip (Snackbar.snackbar payload) T.undoButton
        |> flip Snackbar.add model.snackbar
        |> Tuple.mapFirst (\snackbar -> { model | snackbar = snackbar })
        |> Tuple.mapSecond
            (Cmd.map Model.SnackbarMsg
                >> flip (::) [ command ]
                >> Cmd.batch
            )


updateStoredData : Model -> StoredData -> ( Model, Cmd msg )
updateStoredData model storedData =
    ( { model | storedData = storedData }, Cmd.none )
