module Views.List exposing (view)

import Html exposing (Html)
import Material.Button as Button
import Material.Color as Color
import Material.Dialog as Dialog
import Material.Elevation as Elevation
import Material.Grid as Grid exposing (Cell)
import Material.Icon as Icon
import Material.Options as Options
import Model exposing (Model, Msg(Mdl))
import Models.List exposing (ListObject, ListType(..), RemoteObjects)
import Models.Dialog
import RemoteData exposing (RemoteData(..))
import Views.Utilities as ViewUtil


view : Model -> ListType -> Html Msg
view model listType =
    let
        f title possibleObjects =
            case possibleObjects of
                NotAsked ->
                    Html.text <| title ++ "s not asked yet"

                Loading ->
                    Html.text <| title ++ "s being loaded"

                Failure _ ->
                    Html.text "An error has occurred"

                Success objects ->
                    grid model listType title objects
    in
        applyToListType f listType


grid : Model -> ListType -> String -> List ListObject -> Html Msg
grid model listType title object =
    if List.isEmpty object then
        Html.text <| "No " ++ title ++ "s yet"
    else
        Grid.grid [] <|
            List.indexedMap (cell model listType) object


cell : Model -> ListType -> Int -> ListObject -> Cell Msg
cell model listType index object =
    Grid.cell [] [ card model listType index object ]


card : Model -> ListType -> Int -> ListObject -> Html Msg
card model listType index object =
    Options.div
        [ Elevation.e2
        , Options.css "padding" "1em"
        , Options.css "display" "flex"
        , Options.css "align-items" "center"
        ]
        [ Options.div (ViewUtil.noWrap 1.5) [ Html.text object.name ]
        , Options.div [ Options.css "flex-grow" "1" ] []
        , Button.render Mdl
            [ 0, index ]
            model.mdl
            [ Button.icon
            , Button.ripple
            , Dialog.openOn "click"
            , Options.onClick <|
                Model.DialogMsg <|
                    Models.Dialog.EditDialog object
            ]
            [ Icon.i "edit" ]
        , Button.render Mdl
            [ 1, index ]
            model.mdl
            [ Button.icon
            , Button.ripple
            , Color.text Color.accent
            , Options.onClick <|
                Model.DeleteObject listType object.id
            ]
            [ Icon.i "delete" ]
        ]


applyToListType : (String -> RemoteObjects -> a) -> ListType -> a
applyToListType f listType =
    case listType of
        Brands possibleBrands ->
            f "Brand" possibleBrands

        Markets possibleMarkets ->
            f "Market" possibleMarkets
