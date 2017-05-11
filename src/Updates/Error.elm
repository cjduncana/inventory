module Updates.Error exposing (..)

import Material.Snackbar as Snackbar
import Model exposing (Model, Msg)
import Models.Error exposing (Error(..))
import Models.Snackbar exposing (Payload(NoPayload))


update : Error -> Model -> ( Model, Cmd Msg )
update error model =
    case error of
        UnknownError error_ ->
            addSnackbar error_ model

        DuplicateError name ->
            addSnackbar name model


addSnackbar : String -> Model -> ( Model, Cmd Msg )
addSnackbar message model =
    let
        toast =
            Snackbar.toast NoPayload message

        ( snackbarModel, snackbarCommand ) =
            Snackbar.add toast model.snackbar

        model_ =
            { model | snackbar = snackbarModel }

        command_ =
            Cmd.map Model.SnackbarMsg snackbarCommand
    in
        ( model_, command_ )
