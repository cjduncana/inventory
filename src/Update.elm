module Update exposing (update)

import Material
import Model exposing (Model, Msg)
import Routing.Navigation as Navigation
import Updates.Brands as Brands
import Updates.Dialog as Dialog
import Updates.Error as Error
import Updates.Goods as Goods
import Updates.List as List
import Updates.Markets as Markets
import Updates.Reports as Reports
import Updates.Snackbar as Snackbar


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Model.Mdl msg_ ->
            Material.update Model.Mdl msg_ model

        Model.SnackbarMsg msg_ ->
            Snackbar.update msg_ model

        Model.NavigateTo route ->
            Navigation.gotoRoute route model

        Model.ErrorReceived error ->
            Error.update error model

        Model.DialogMsg msg_ ->
            let
                ( model_, command_ ) =
                    Dialog.update msg_ model
            in
                ( model_, Cmd.map Model.DialogMsg command_ )

        Model.BrandsReceived brands ->
            Brands.update brands model

        Model.GoodsReceived goods ->
            Goods.update goods model

        Model.MarketsReceived markets ->
            Markets.update markets model

        Model.ReportsReceived reports ->
            Reports.updateReports reports model

        Model.DeleteGood good ->
            Goods.delete good model

        Model.DeleteObject listType ->
            List.delete listType model

        Model.AddEditReport msg_ ->
            let
                ( model_, command_ ) =
                    Reports.update msg_ model
            in
                ( model_, Cmd.map Model.AddEditReport command_ )
