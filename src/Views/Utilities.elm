module Views.Utilities
    exposing
        ( empty
        , grid
        , imageSrc
        , noWrap
        , onBlur
        , showList
        , square
        )

import Html exposing (Attribute, Html)
import Html.Attributes as Attr
import Html.Events as Events
import Json.Decode as Decode
import Material.Button as Button
import Material.Color as Color
import Material.Dialog as Dialog
import Material.Elevation as Elevation
import Material.Grid as Grid exposing (Cell)
import Material.Icon as Icon
import Material.Options as Options
import Maybe.Extra as Maybe
import Model exposing (Model, Msg(Mdl))
import Models.Dialog as Dialog
import Models.Good as Good exposing (ImageURI)
import Models.ID exposing (ID)


empty : Html msg
empty =
    Html.text ""


imageSrc : ImageURI -> Attribute msg
imageSrc =
    Attr.src << Good.getImageURI


noWrap : Float -> List (Options.Property c m)
noWrap height =
    [ Options.css "height" <| toString height ++ "em"
    , Options.css "overflow-x" "hidden"
    , Options.css "white-space" "nowrap"
    , Options.css "text-overflow" "ellipsis"
    ]


onBlur : (String -> msg) -> Attribute msg
onBlur message =
    Decode.map message Events.targetValue
        |> Events.on "blur"


showList : String -> (List a -> Html msg) -> List a -> Html msg
showList emptyMessage htmlFunction =
    Just
        >> Maybe.filter (not << List.isEmpty)
        >> Maybe.map htmlFunction
        >> Maybe.withDefault (Html.text emptyMessage)


square : Int -> List (Options.Property c m)
square side =
    [ Options.css "max-height" <| toString side ++ "px"
    , Options.css "max-width" <| toString side ++ "px"
    ]


grid : Model -> (ID -> Msg) -> List ID -> Html Msg
grid model deleteMsg =
    List.indexedMap (cell model deleteMsg) >> Grid.grid []


cell : Model -> (ID -> Msg) -> Int -> ID -> Cell Msg
cell model deleteMsg index object =
    Grid.cell [] [ item model deleteMsg object index ]


item : Model -> (ID -> Msg) -> ID -> Int -> Html Msg
item model deleteMsg object index =
    Options.div
        [ Elevation.e2
        , Options.css "padding" "1em"
        , Options.css "display" "flex"
        , Options.css "align-items" "center"
        ]
        [ Options.div (noWrap 1.5) [ Html.text object.name ]
        , Options.div [ Options.css "flex-grow" "1" ] []
        , Button.render Mdl
            [ 0, index ]
            model.mdl
            [ Button.icon
            , Button.ripple
            , Dialog.openOn "click"
            , Dialog.EditDialog object
                |> Model.DialogMsg
                |> Options.onClick
            ]
            [ Icon.i "edit" ]
        , Button.render Mdl
            [ 1, index ]
            model.mdl
            [ Button.icon
            , Button.ripple
            , Color.text Color.accent
            , deleteMsg object
                |> Options.onClick
            ]
            [ Icon.i "delete" ]
        ]
