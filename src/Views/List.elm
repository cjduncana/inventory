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
import Models.ID exposing (ID)
import Models.List exposing (ListType)
import Models.Dialog
import Views.Utilities as ViewUtil


view : Model -> ListType (List ID) -> Html Msg
view model listType =
    let
        f title objects =
            if List.isEmpty objects then
                Html.text <| "No " ++ title ++ "s yet"
            else
                Grid.grid [] <|
                    List.indexedMap (cell model listType) objects
    in
        Models.List.apply f listType


cell : Model -> ListType (List ID) -> Int -> ID -> Cell Msg
cell model listType index object =
    let
        object_ =
            Models.List.map (always object) listType
    in
        Grid.cell [] [ item model object_ index ]


item : Model -> ListType ID -> Int -> Html Msg
item model listType index =
    let
        object =
            Models.List.unpack listType
    in
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
                    Model.DeleteObject listType
                ]
                [ Icon.i "delete" ]
            ]
