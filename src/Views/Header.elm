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
import Routing.Routes as Route
    exposing
        ( Route
            ( Brands
            , Goods
            , Markets
            , Reports
            )
        )
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
            |> Options.when (Route.hasDialog model.route)
        , Options.css "position" "absolute"
        , Options.css "right" "24px"
        , Options.css "top" "28px"
        , case model.route of
            Brands ->
                Options.onClick <|
                    Model.DialogMsg Models.Dialog.BrandAddDialog

            Goods ->
                Options.onClick <|
                    Model.DialogMsg Models.Dialog.GoodAddDialog

            Markets ->
                Options.onClick <|
                    Model.DialogMsg Models.Dialog.MarketAddDialog

            Reports ->
                Options.onClick <|
                    Model.DialogMsg Models.Dialog.NewReportPage

            _ ->
                Options.nop
        ]
        [ Icon.i "add" ]
