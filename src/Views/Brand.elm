module Views.Brand exposing (view)

import Html exposing (Html)
import Material.Button as Button
import Material.Color as Color
import Material.Dialog as Dialog
import Material.Elevation as Elevation
import Material.Grid as Grid exposing (Cell)
import Material.Icon as Icon
import Material.Options as Options
import Model exposing (Model, Msg(Mdl))
import Models.Brand exposing (Brand)
import Models.Dialog
import RemoteData exposing (RemoteData(..))
import Routing.Error exposing (Error)
import Views.Utilities as ViewUtil


view : Model -> RemoteData Error (List Brand) -> Html Msg
view model possibleBrands =
    case possibleBrands of
        NotAsked ->
            Html.text "Brands not asked yet"

        Loading ->
            Html.text "Brands being loaded"

        Failure _ ->
            Html.text "An error has occurred"

        Success brands ->
            brandGrid model brands


brandGrid : Model -> List Brand -> Html Msg
brandGrid model brands =
    if List.isEmpty brands then
        Html.text "No brands yet"
    else
        Grid.grid [] <|
            List.indexedMap (brandCell model) brands


brandCell : Model -> Int -> Brand -> Cell Msg
brandCell model index brand =
    Grid.cell []
        [ brandCard model index brand ]


brandCard : Model -> Int -> Brand -> Html Msg
brandCard model index brand =
    Options.div
        [ Elevation.e2
        , Options.css "padding" "1em"
        , Options.css "display" "flex"
        , Options.css "align-items" "center"
        ]
        [ Options.div (ViewUtil.noWrap 1.5) [ Html.text brand.name ]
        , Options.div [ Options.css "flex-grow" "1" ] []
        , Button.render Mdl
            [ 0, index ]
            model.mdl
            [ Button.icon
            , Button.ripple
            , Dialog.openOn "click"
            , Options.onClick <|
                Model.DialogMsg <|
                    Models.Dialog.BrandEditDialog brand
            ]
            [ Icon.i "edit" ]
        , Button.render Mdl
            [ 1, index ]
            model.mdl
            [ Button.icon
            , Button.ripple
            , Color.text Color.accent
            , Options.onClick <|
                Model.DeleteBrand brand.id
            ]
            [ Icon.i "delete" ]
        ]
