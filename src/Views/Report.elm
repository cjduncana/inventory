module Views.Report exposing (view)

import Date.Format as Date
import Html exposing (Html)
import Material.Button as Button
import Material.Card as Card exposing (Block)
import Material.Elevation as Elevation
import Material.Icon as Icon
import Material.Options as Options
import Model exposing (Model, Msg(Mdl))
import Models.Record as Record
import Models.Report exposing (Report, Reports)
import Translation.Main as T
import Views.Utilities as ViewUtil


view : Model -> Reports -> Html Msg
view model =
    List.indexedMap (card model)
        >> Options.div
            [ Options.css "margin" "15px"
            , Options.css "display" "grid"
            , Options.css "grid-template-columns" "repeat(auto-fill, 330px)"
            , Options.css "grid-gap" "15px"
            , Options.css "justify-content" "space-evenly"
            ]
        |> ViewUtil.showList T.noReports


card : Model -> Int -> Report -> Html Msg
card model index report =
    Card.view [ Elevation.e2 ]
        [ title report
        , actions model index report
        ]


title : Report -> Block Msg
title report =
    Card.title []
        [ Card.head []
            [ report.reportedOn
                |> Date.format "%B %d, %Y"
                |> Html.text
            ]
        ]


actions : Model -> Int -> Report -> Block Msg
actions model index report =
    Card.actions []
        [ Button.render Mdl
            [ 0, index ]
            model.mdl
            [ Button.icon
            , Button.ripple
            , Record.ViewReport report.id
                |> Model.AddEditReport
                |> Options.onClick
            ]
            [ Icon.i "visibility" ]
        ]
