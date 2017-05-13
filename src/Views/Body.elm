module Views.Body exposing (view)

import Html exposing (Html)
import Material.Snackbar as Snackbar
import Model exposing (Model, Msg)
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
    , snackbar model.snackbar
    ]


bodyView : Model -> Html Msg
bodyView model =
    case model.route of
        Routes.Home ->
            Html.div [] [ Html.text "This is the home page." ]

        Routes.Brands brands ->
            ListView.view model <| List.Brand brands

        Routes.Goods goods ->
            CardsView.view model goods

        Routes.Markets markets ->
            ListView.view model <| List.Market markets


snackbar : Models.Snackbar.Model -> Html Msg
snackbar snackbarModel =
    Snackbar.view snackbarModel
        |> Html.map Model.SnackbarMsg
