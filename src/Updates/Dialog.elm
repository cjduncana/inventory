module Updates.Dialog exposing (changeImage, update)

import Dropdown
import Material
import Model exposing (Model)
import Models.Brand as Brand
import Models.Dialog as Dialog
    exposing
        ( DialogView
            ( AddBrand
            , AddGood
            , AddMarket
            , EditGood
            , EditView
            )
        , Msg
            ( AddFileDialog
            , BrandAdd
            , BrandAddDialog
            , BrandDropdownMsg
            , EditDialog
            , GoodAdd
            , GoodAddDialog
            , GoodBrandChange
            , GoodEdit
            , GoodEditDialog
            , GoodMarketAdd
            , GoodMarketRemove
            , ImageSaved
            , MarketAdd
            , MarketAddDialog
            , MarketDropdownMsg
            , Mdl
            , NameUpdate
            , NewReportPage
            , ObjectEdit
            , RemoveImage
            )
        )
import Models.Dropdown as Dropdown
import Models.Good as Good exposing (ImageURI(HasImage, NoImage))
import Models.Market as Market
import Routing.Routes as Routes
import Routing.Reports as Reports
import Utilities as Util


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.route ) of
        ( Mdl msg_, _ ) ->
            Material.update Mdl msg_ model

        ( NameUpdate name, _ ) ->
            let
                dialogView_ =
                    Dialog.mapName (always name) model.dialogView

                model_ =
                    { model | dialogView = dialogView_ }
            in
                ( model_, Cmd.none )

        ( BrandAdd name, _ ) ->
            let
                model_ =
                    { model | dialogView = AddBrand "" }

                command_ =
                    Util.doCommand name <|
                        Brand.createBrand name
            in
                ( model_, command_ )

        ( BrandAddDialog, _ ) ->
            let
                model_ =
                    { model | dialogView = AddBrand "" }
            in
                ( model_, Cmd.none )

        ( GoodAdd name data, _ ) ->
            let
                model_ =
                    { model | dialogView = Dialog.newAddGoodView }

                command_ =
                    Util.doCommand name <|
                        Good.createGood name data
            in
                ( model_, command_ )

        ( GoodAddDialog, _ ) ->
            let
                model_ =
                    { model | dialogView = Dialog.newAddGoodView }
            in
                ( model_, Cmd.none )

        ( GoodEdit good, _ ) ->
            let
                model_ =
                    { model | dialogView = Dialog.newAddGoodView }

                command_ =
                    Util.doCommand (Good.getName good) (Good.editGood good)
            in
                ( model_, command_ )

        ( GoodEditDialog good, _ ) ->
            let
                model_ =
                    { model | dialogView = Dialog.newEditGoodView good }
            in
                ( model_, Cmd.none )

        ( GoodBrandChange maybeBrand, _ ) ->
            let
                dialogView_ =
                    Dialog.setBrand maybeBrand model.dialogView

                model_ =
                    { model | dialogView = dialogView_ }
            in
                ( model_, Cmd.none )

        ( GoodMarketAdd maybeMarket, _ ) ->
            let
                dialogView_ =
                    Dialog.addMarket maybeMarket model.dialogView

                model_ =
                    { model | dialogView = dialogView_ }
            in
                ( model_, Cmd.none )

        ( GoodMarketRemove index, _ ) ->
            let
                dialogView_ =
                    Dialog.removeMarket index model.dialogView

                model_ =
                    { model | dialogView = dialogView_ }
            in
                ( model_, Cmd.none )

        ( MarketAdd name, _ ) ->
            let
                model_ =
                    { model | dialogView = AddMarket "" }

                command_ =
                    Util.doCommand name <|
                        Market.createMarket name
            in
                ( model_, command_ )

        ( MarketAddDialog, _ ) ->
            let
                model_ =
                    { model | dialogView = AddMarket "" }
            in
                ( model_, Cmd.none )

        ( EditDialog object, _ ) ->
            let
                model_ =
                    { model | dialogView = EditView object object.name }
            in
                ( model_, Cmd.none )

        ( ObjectEdit object, Routes.Brands ) ->
            let
                model_ =
                    { model | dialogView = AddBrand "" }

                command_ =
                    Util.doCommand object.name <|
                        Brand.editBrand object
            in
                ( model_, command_ )

        ( ObjectEdit object, Routes.Markets ) ->
            let
                model_ =
                    { model | dialogView = AddMarket "" }

                command_ =
                    Util.doCommand object.name <|
                        Market.editMarket object
            in
                ( model_, command_ )

        ( ObjectEdit _, _ ) ->
            ( model, Cmd.none )

        ( AddFileDialog, _ ) ->
            ( model, Dialog.addFileDialog )

        ( ImageSaved filename, _ ) ->
            changeImage model <| Just filename

        ( RemoveImage, _ ) ->
            changeImage model Nothing

        ( BrandDropdownMsg msg_, _ ) ->
            case model.dialogView of
                AddGood goodContent ->
                    let
                        ( brandDropdown_, command_ ) =
                            Dropdown.update Dropdown.brandConfig
                                msg_
                                goodContent.brandDropdown

                        dialogView_ =
                            AddGood
                                { goodContent
                                    | brandDropdown = brandDropdown_
                                }

                        model_ =
                            { model | dialogView = dialogView_ }
                    in
                        ( model_, command_ )

                EditGood good goodContent ->
                    let
                        ( brandDropdown_, command_ ) =
                            Dropdown.update Dropdown.brandConfig
                                msg_
                                goodContent.brandDropdown

                        dialogView_ =
                            EditGood good
                                { goodContent
                                    | brandDropdown = brandDropdown_
                                }

                        model_ =
                            { model | dialogView = dialogView_ }
                    in
                        ( model_, command_ )

                _ ->
                    ( model, Cmd.none )

        ( MarketDropdownMsg msg_, _ ) ->
            case model.dialogView of
                AddGood goodContent ->
                    let
                        ( marketDropdown_, command_ ) =
                            Dropdown.update Dropdown.marketConfig
                                msg_
                                goodContent.marketDropdown

                        dialogView_ =
                            AddGood
                                { goodContent
                                    | marketDropdown = marketDropdown_
                                }

                        model_ =
                            { model | dialogView = dialogView_ }
                    in
                        ( model_, command_ )

                EditGood good goodContent ->
                    let
                        ( marketDropdown_, command_ ) =
                            Dropdown.update Dropdown.marketConfig
                                msg_
                                goodContent.marketDropdown

                        dialogView_ =
                            EditGood good
                                { goodContent
                                    | marketDropdown = marketDropdown_
                                }

                        model_ =
                            { model | dialogView = dialogView_ }
                    in
                        ( model_, command_ )

                _ ->
                    ( model, Cmd.none )

        ( NewReportPage, Routes.Reports ) ->
            Reports.gotoNew model

        ( NewReportPage, _ ) ->
            ( model, Cmd.none )


changeImage : Model -> Maybe String -> ( Model, Cmd Msg )
changeImage model filename =
    let
        uri_ =
            Maybe.map HasImage filename
                |> Maybe.withDefault NoImage

        dialogView =
            Dialog.setImage uri_ model.dialogView

        model_ =
            { model | dialogView = dialogView }

        command_ =
            if Util.isEmpty filename then
                Dialog.getFilename model.dialogView
                    |> Maybe.map Dialog.removeImage
                    |> Maybe.withDefault Cmd.none
            else
                Cmd.none
    in
        ( model_, command_ )
