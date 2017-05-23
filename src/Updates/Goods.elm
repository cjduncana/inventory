module Updates.Goods exposing (addFileDialog, changeImage, delete, update)

import Material.Snackbar as Snackbar
import Model exposing (Model, Msg)
import Models.Dialog exposing (DialogView(AddGood, EditGood))
import Models.Good as Good exposing (Good, Goods, ImageURI(HasImage, NoImage))
import Models.Snackbar exposing (Payload(DeletedGood))
import Utilities as Util


update : Goods -> Model -> ( Model, Cmd Msg )
update goods model =
    let
        storedData =
            model.storedData

        storedData_ =
            { storedData | goods = goods }

        model_ =
            { model | storedData = storedData_ }
    in
        ( model_, Cmd.none )


delete : Good -> Model -> ( Model, Cmd Msg )
delete good model =
    addSnackbar model good.name (DeletedGood good) <|
        Good.deleteGood good.id


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


addFileDialog : Model -> ( Model, Cmd Msg )
addFileDialog model =
    ( model, Good.addFileDialog )


changeImage : Model -> Maybe String -> ( Model, Cmd Msg )
changeImage model filename =
    let
        uri_ =
            Maybe.map HasImage filename
                |> Maybe.withDefault NoImage

        dialogView =
            case model.dialogView of
                AddGood name _ maybeBrand markets ->
                    AddGood name uri_ maybeBrand markets

                EditGood good name _ maybeBrand ->
                    EditGood good name uri_ maybeBrand

                _ ->
                    model.dialogView

        model_ =
            { model | dialogView = dialogView }

        command_ =
            if Util.isEmpty filename then
                Models.Dialog.getFilename model.dialogView
                    |> Maybe.map Good.removeImage
                    |> Maybe.withDefault Cmd.none
            else
                Cmd.none
    in
        ( model_, command_ )
