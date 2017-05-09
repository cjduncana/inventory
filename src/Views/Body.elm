module Views.Body exposing (view)

import Html exposing (Html)
import Model exposing (Model, Msg)
import Models.List as List
import Routing.Routes as Routes
import Views.Dialog as DialogView
import Views.List as ListView


view : Model -> List (Html Msg)
view model =
    [ bodyView model
    , DialogView.view model
    ]


bodyView : Model -> Html Msg
bodyView model =
    case model.route of
        Routes.Home ->
            Html.div [] [ Html.text "This is the home page." ]

        Routes.Brands brands ->
            ListView.view model <| List.Brands brands

        Routes.Markets markets ->
            ListView.view model <| List.Markets markets
