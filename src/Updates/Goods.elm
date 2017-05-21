module Updates.Goods exposing (addFileDialog, delete, get, imageSaved, update)

import Material.Snackbar as Snackbar
import Model exposing (Model, Msg)
import Models.Dialog exposing (DialogView(AddGood, EditGood))
import Models.Good as Good exposing (Good, Goods, ImageURI(HasImage))
import Models.Snackbar exposing (Payload(DeletedGood))
import Routing.Routes exposing (Route(Goods))


get : Model -> ( Model, Cmd Msg )
get model =
    ( model, Good.getGoods )


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
        case model.route of
            Goods _ ->
                ( { model_ | route = Goods goods }, Cmd.none )

            _ ->
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


imageSaved : Model -> String -> ( Model, Cmd Msg )
imageSaved model filename =
    let
        uri_ =
            HasImage filename

        dialogView =
            case model.dialogView of
                AddGood name _ maybeBrand markets ->
                    AddGood name uri_ maybeBrand markets

                EditGood good name _ ->
                    EditGood good name uri_

                _ ->
                    model.dialogView

        model_ =
            { model | dialogView = dialogView }
    in
        ( model_, Cmd.none )
