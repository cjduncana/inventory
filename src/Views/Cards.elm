module Views.Cards exposing (view)

import Html exposing (Html)
import Html.Attributes
import Material.Button as Button
import Material.Card as Card exposing (Block)
import Material.Color as Color
import Material.Dialog as Dialog
import Material.Elevation as Elevation
import Material.Icon as Icon
import Material.Options as Options
import Model exposing (Model, Msg(Mdl))
import Models.Brand exposing (Brand)
import Models.Dialog
import Models.Good as Good exposing (Good, Goods)
import Models.Market exposing (Markets)


view : Model -> Goods -> Html Msg
view model goods =
    if List.isEmpty goods then
        Html.text "No Goods yet"
    else
        Options.div
            [ Options.css "margin" "15px"
            , Options.css "display" "grid"
            , Options.css "grid-template-columns" "repeat(auto-fill, 330px)"
            , Options.css "grid-gap" "15px"
            , Options.css "justify-content" "space-evenly"
            ]
        <|
            List.indexedMap (card model) goods


card : Model -> Int -> Good -> Html Msg
card model index good =
    let
        blocks =
            [ media good
            , title good
            , actions model index good
            ]

        blocks_ =
            if List.isEmpty good.markets then
                blocks
            else
                text good.markets :: blocks
    in
        Card.view [ Elevation.e2 ] blocks_


title : Good -> Block Msg
title good =
    let
        head_ =
            Card.head [] [ Html.text good.name ]

        subhead_ =
            Maybe.map subhead good.brand
                |> Maybe.withDefault (Html.div [] [])

        block =
            [ head_, subhead_ ]
    in
        Card.title [] block


subhead : Brand -> Html Msg
subhead brand =
    Card.subhead [] [ Html.text brand.name ]


text : Markets -> Block Msg
text markets =
    Card.text []
        [ List.map .name markets
            |> String.join ", "
            |> Html.text
        ]


media : Good -> Block Msg
media good =
    Card.media []
        [ Options.img []
            [ Html.Attributes.src <| Good.getImageURI good.image ]
        ]


actions : Model -> Int -> Good -> Block Msg
actions model index good =
    Card.actions []
        [ Button.render Mdl
            [ 0, index ]
            model.mdl
            [ Button.icon
            , Button.ripple
            , Dialog.openOn "click"
            , Options.onClick <|
                Model.DialogMsg <|
                    Models.Dialog.EditDialog { id = good.id, name = good.name }
            ]
            [ Icon.i "edit" ]
        , Button.render Mdl
            [ 1, index ]
            model.mdl
            [ Button.icon
            , Button.ripple
            , Color.text Color.accent
            , Options.onClick <|
                Model.DeleteGood good
            ]
            [ Icon.i "delete" ]
        ]
