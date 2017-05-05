module Views.Body exposing (view)

import Html exposing (Html)
import Model exposing (Model, Msg)
import Routing.Routes exposing (Route(..))
import Views.Brand as BrandView
import Views.Dialog as DialogView


view : Model -> List (Html Msg)
view model =
    [ bodyView model
    , DialogView.view model
    ]


bodyView : Model -> Html Msg
bodyView model =
    case model.route of
        Home ->
            Html.div [] [ Html.text "This is the home page." ]

        Brands brands ->
            BrandView.view brands
