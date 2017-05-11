module Updates.Dialog exposing (update)

import Model exposing (Model)
import Models.Brand as Brand
import Models.Dialog as Dialog exposing (DialogView(..), Msg(..))
import Models.Market as Market
import Routing.Routes as Routes
import Utilities as Util


update : Msg -> Model -> ( Model, Cmd Model.Msg )
update msg model =
    case msg of
        NameUpdate name ->
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
                    Util.doCommand name <|
                        Brand.createBrand name
            in
                ( model_, command_ )

        BrandAddDialog ->
            let
                model_ =
                    { model | dialogView = AddBrand "" }
            in
                ( model_, Cmd.none )

        MarketAdd name ->
            let
                model_ =
                    { model | dialogView = AddMarket "" }

                command_ =
                    Util.doCommand name <|
                        Market.createMarket name
            in
                ( model_, command_ )

        MarketAddDialog ->
            let
                model_ =
                    { model | dialogView = AddMarket "" }
            in
                ( model_, Cmd.none )

        EditDialog object ->
            let
                model_ =
                    { model | dialogView = EditView object object.name }
            in
                ( model_, Cmd.none )

        ObjectEdit object ->
            let
                model_ =
                    case model.route of
                        Routes.Brands _ ->
                            { model | dialogView = AddBrand "" }

                        Routes.Markets _ ->
                            { model | dialogView = AddMarket "" }

                        _ ->
                            model

                command_ =
                    case model.route of
                        Routes.Brands _ ->
                            Util.doCommand object.name <|
                                Brand.editBrand object

                        Routes.Markets _ ->
                            Util.doCommand object.name <|
                                Market.editMarket object

                        _ ->
                            Cmd.none
            in
                ( model_, command_ )
