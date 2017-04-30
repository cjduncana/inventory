module Views.Drawer exposing (view)

import Html exposing (Html)
import Material.Layout as Layout
import Model exposing (Msg)


view : List (Html Msg)
view =
    [ Layout.title [] [ Html.text "Inventory" ]
    , Layout.navigation [] <| List.map viewLinkItem linkItems
    ]


viewLinkItem : LinkItem -> Html Msg
viewLinkItem linkItem =
    Layout.link [] [ Html.text linkItem.text ]


type alias LinkItem =
    { text : String }


linkItems : List LinkItem
linkItems =
    [ { text = "Reports" }
    , { text = "Goods" }
    , { text = "Brands" }
    , { text = "Markets" }
    ]
