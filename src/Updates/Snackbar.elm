module Updates.Snackbar exposing (update)

import Material.Snackbar as Snackbar
import Model exposing (Model, Msg, SnackbarPayload)


update : Snackbar.Msg SnackbarPayload -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( snackbarModel, snackbarCommand ) =
            Snackbar.update msg model.snackbar

        model_ =
            { model | snackbar = snackbarModel }

        command_ =
            Cmd.map Model.SnackbarMsg snackbarCommand
    in
        ( model_, command_ )
