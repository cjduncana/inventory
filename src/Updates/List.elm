module Updates.List exposing (delete)

import Material.Snackbar as Snackbar
import Model exposing (Model, Msg)
import Models.Brand as Brand
import Models.List exposing (ListObject, ListType(Brand, Market))
import Models.Market as Market
import Models.Snackbar exposing (Payload(DeletedBrand, DeletedMarket))


delete : ListType ListObject -> Model -> ( Model, Cmd Msg )
delete listType model =
    let
        add =
            addSnackbar model
    in
        case listType of
            Brand brand ->
                add brand.name (DeletedBrand brand) <|
                    Brand.deleteBrand brand.id

            Market market ->
                add market.name (DeletedMarket market) <|
                    Market.deleteMarket market.id


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
