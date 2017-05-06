module Updates.Dialog exposing (update)

import Model exposing (Model)
import Models.Brand as Brand exposing (Brand)
import Models.Dialog as Dialog exposing (DialogView(..), Msg(..))


update : Msg -> Model -> ( Model, Cmd Model.Msg )
update msg model =
    case msg of
        BrandNameUpdate name ->
            let
                dialogView_ =
                    Dialog.mapName (always name) model.dialogView

                model_ =
                    { model | dialogView = dialogView_ }
            in
                ( model_, Cmd.none )

        BrandAdd name ->
            let
                model_ =
                    { model | dialogView = AddBrand "" }

                command_ =
                    Brand.doCommand name <|
                        Brand.createBrand name
            in
                ( model_, command_ )

        BrandAddDialog ->
            let
                model_ =
                    { model | dialogView = AddBrand "" }
            in
                ( model_, Cmd.none )

        BrandEdit brand ->
            let
                model_ =
                    { model | dialogView = AddBrand "" }

                command_ =
                    Brand.doCommand brand.name <|
                        Brand.editBrand brand
            in
                ( model_, command_ )

        BrandEditDialog brand ->
            let
                model_ =
                    { model | dialogView = EditBrand brand brand.name }
            in
                ( model_, Cmd.none )
