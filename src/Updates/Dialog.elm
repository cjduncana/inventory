module Updates.Dialog exposing (update, updateBrand)

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
            ( BrandAdd
            , BrandAddDialog
            , EditDialog
            , GoodAdd
            , GoodAddDialog
            , GoodEdit
            , GoodEditDialog
            , MarketAdd
            , MarketAddDialog
            , NameUpdate
            , ObjectEdit
            )
        )
import Models.Good as Good exposing (ImageURI(NoImage))
import Models.Market as Market
import Routing.Routes as Routes
import Utilities as Util
import Uuid


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

        ( GoodAdd name uri maybeBrand, _ ) ->
            let
                model_ =
                    { model | dialogView = AddGood "" NoImage Nothing [] }

                command_ =
                    Util.doCommand name <|
                        Good.createGood name uri maybeBrand
            in
                ( model_, command_ )

        ( GoodAddDialog, _ ) ->
            let
                model_ =
                    { model | dialogView = AddGood "" NoImage Nothing [] }
            in
                ( model_, Cmd.none )

        ( GoodEdit good, _ ) ->
            let
                model_ =
                    { model | dialogView = AddGood "" NoImage Nothing [] }

                command_ =
                    Util.doCommand good.name <|
                        Good.editGood
                            { id = good.id
                            , name = good.name
                            , image = good.image
                            , brand = good.brand
                            , markets = good.markets
                            }
            in
                ( model_, command_ )

        ( GoodEditDialog good, _ ) ->
            let
                model_ =
                    { model | dialogView = EditGood good good.name good.image good.brand }
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


updateBrand : Model -> String -> ( Model, Cmd Model.Msg )
updateBrand model id =
    let
        findBrand =
            Brand.findBrand model.storedData.brands

        maybeBrand =
            Uuid.fromString id
                |> Maybe.andThen findBrand

        dialogView_ =
            case model.dialogView of
                AddGood name uri _ markets ->
                    AddGood name uri maybeBrand markets

                EditGood good name uri _ ->
                    EditGood good name uri maybeBrand

                _ ->
                    model.dialogView

        model_ =
            { model | dialogView = dialogView_ }
    in
        ( model_, Cmd.none )
