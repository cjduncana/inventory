module Views.Body exposing (view)

import Html exposing (Html)
import Material.Snackbar as Snackbar
import Model exposing (Model, Msg(AddEditReport, DialogMsg))
import Models.Snackbar
import Routing.Routes as Routes
import Translation.Main as T
import Views.Brand as BrandView
import Views.Cards as CardsView
import Views.Dialog as DialogView
import Views.Market as MarketView
import Views.Report as ReportView
import Views.Report.Add as AddReportView
import Views.Report.View as ViewReportView


view : Model -> List (Html Msg)
view model =
    [ bodyView model
    , DialogView.view model
        |> Html.map DialogMsg
    , snackbar model.snackbar
    ]


bodyView : Model -> Html Msg
bodyView model =
    case model.route of
        Routes.Home ->
            Html.div [] [ Html.text T.homepage ]

        Routes.Brands ->
            BrandView.view model model.storedData.brands

        Routes.Goods ->
            CardsView.view model model.storedData.goods

        Routes.Markets ->
            MarketView.view model model.storedData.markets

        Routes.Reports ->
            ReportView.view model model.storedData.reports

        Routes.NewReport data ->
            AddReportView.view model data
                |> Html.map AddEditReport

        Routes.ViewReport maybeRecords ->
            ViewReportView.view model maybeRecords


snackbar : Models.Snackbar.Model -> Html Msg
snackbar snackbarModel =
    Snackbar.view snackbarModel
        |> Html.map Model.SnackbarMsg
