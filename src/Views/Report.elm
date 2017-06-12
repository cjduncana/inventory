module Views.Report exposing (view)

import Date.Format as Date
import Html exposing (Html)
import Material.Card as Card exposing (Block)
import Material.Elevation as Elevation
import Material.Options as Options
import Model exposing (Model, Msg)
import Models.Report exposing (Report, Reports)


view : Model -> Reports -> Html Msg
view model reports =
    if List.isEmpty reports then
        Html.text "No Reports yet"
    else
        Options.div
            [ Options.css "margin" "15px"
            , Options.css "display" "grid"
            , Options.css "grid-template-columns" "repeat(auto-fill, 330px)"
            , Options.css "grid-gap" "15px"
            , Options.css "justify-content" "space-evenly"
            ]
        <|
            List.indexedMap (card model) reports


card : Model -> Int -> Report -> Html Msg
card _ _ report =
    let
        blocks =
            [ title report

            -- , media report
            -- , actions model index report
            ]

        -- blocks_ =
        --     if List.isEmpty (Good.getMarkets report) then
        --         blocks
        --     else
        --         text (Good.getMarkets report) :: blocks
    in
        Card.view [ Elevation.e2 ] blocks


title : Report -> Block Msg
title report =
    let
        head_ =
            Card.head []
                [ report.reportedOn
                    |> Date.format "%B %d, %Y"
                    |> Html.text
                ]

        -- subhead_ =
        --     Maybe.map subhead (Report.getBrand report)
        --         |> Maybe.withDefault (Html.div [] [])
        block =
            [ head_ ]
    in
        Card.title [] block
