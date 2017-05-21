module Views.Header exposing (view)

import Html exposing (Html)
import Material.Button as Button
import Material.Dialog as Dialog
import Material.Icon as Icon
import Material.Options as Options
import Material.Layout as Layout
import Model exposing (Model, Msg(Mdl))
import Models.Dialog
import Models.Header exposing (Fab(Absent, Add))
import Routing.Routes exposing (Route(Brands, Goods, Markets))
import Views.Utilities as ViewUtil


view : Model -> List (Html Msg)
view model =
    [ Layout.row []
        [ Layout.title [] [ Html.text model.header.title ]
        , case model.header.fab of
            Absent ->
                ViewUtil.emptyDiv

            Add ->
                fab model
        ]
    ]


fab : Model -> Html Msg
fab model =
    Button.render Mdl
        [ 0 ]
        model.mdl
        [ Button.fab
        , Button.colored
        , Button.ripple
        , Dialog.openOn "click"
        , Options.css "position" "absolute"
        , Options.css "right" "24px"
        , Options.css "top" "28px"
        , case model.route of
            Brands _ ->
                Options.onClick <|
                    Model.DialogMsg Models.Dialog.BrandAddDialog

            Goods _ ->
                Options.onClick <|
                    Model.DialogMsg Models.Dialog.GoodAddDialog

            Markets _ ->
                Options.onClick <|
                    Model.DialogMsg Models.Dialog.MarketAddDialog

            _ ->
                Options.nop
        ]
        [ Icon.i "add" ]
