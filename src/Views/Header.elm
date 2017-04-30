module Views.Header exposing (view)

import Html exposing (Html)
import Material.Layout as Layout
import Model exposing (Msg)


view : List (Html Msg)
view =
    [ Layout.row [] [ Layout.title [] [ Html.text "Inventory" ] ] ]
