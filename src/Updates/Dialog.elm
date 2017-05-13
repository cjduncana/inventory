module Updates.Dialog exposing (update)

import Model exposing (Model)
import Models.Brand as Brand
import Models.Dialog as Dialog
    exposing
        ( DialogView
            ( AddBrand
            , AddGood
            , AddMarket
            , EditView
            )
        , Msg
            ( BrandAdd
            , BrandAddDialog
            , EditDialog
            , GoodAdd
            , MarketAdd
            , MarketAddDialog
            , NameUpdate
            , ObjectEdit
            )
        )
import Models.Good as Good
import Models.Market as Market
import Routing.Routes as Routes
import Utilities as Util


update : Msg -> Model -> ( Model, Cmd Model.Msg )
update msg model =
    case ( msg, model.route ) of
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

        ( GoodAdd name, _ ) ->
            let
                model_ =
                    { model | dialogView = AddGood "" "" Nothing [] }

                command_ =
                    Util.doCommand name <|
                        Good.createGood name
            in
                ( model_, command_ )

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

        ( ObjectEdit object, Routes.Brands _ ) ->
            let
                model_ =
                    { model | dialogView = AddBrand "" }

                command_ =
                    Util.doCommand object.name <|
                        Brand.editBrand object
            in
                ( model_, command_ )

        ( ObjectEdit object, Routes.Goods _ ) ->
            let
                model_ =
                    { model | dialogView = AddGood "" "" Nothing [] }

                command_ =
                    Util.doCommand object.name <|
                        Good.editGood
                            { id = object.id
                            , name = object.name
                            , image = Good.NoImage
                            , brand = Nothing
                            , markets = []
                            }
            in
                ( model_, command_ )

        ( ObjectEdit object, Routes.Markets _ ) ->
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
