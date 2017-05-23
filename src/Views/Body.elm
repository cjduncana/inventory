module Views.Body exposing (view)

import Html exposing (Html)
import Material.Snackbar as Snackbar
import Model exposing (Model, Msg(DialogMsg))
import Models.List as List
import Models.Snackbar
import Routing.Routes as Routes
import Views.Cards as CardsView
import Views.Dialog as DialogView
import Views.List as ListView


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
            Html.div [] [ Html.text "This is the home page." ]

        Routes.Brands ->
            ListView.view model <| List.Brand model.storedData.brands

        Routes.Goods ->
            CardsView.view model model.storedData.goods

        Routes.Markets ->
            ListView.view model <| List.Market model.storedData.markets


snackbar : Models.Snackbar.Model -> Html Msg
snackbar snackbarModel =
    Snackbar.view snackbarModel
        |> Html.map Model.SnackbarMsg
