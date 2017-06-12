module Views.Drawer exposing (view)

import Html exposing (Html)
import Material.Layout as Layout
import Material.Options as Options
import Model exposing (Msg(Mdl, NavigateTo))
import Routing.Routes as Routes exposing (Route)


view : List (Html Msg)
view =
    [ Layout.title
        [ Options.onClick <| NavigateTo Routes.Home
        , Options.onMouseUp <| Layout.toggleDrawer Mdl
        ]
        [ Html.text "Inventory" ]
    , Layout.navigation
        [ Options.onClick <| Layout.toggleDrawer Mdl ]
      <|
        List.map viewLinkItem linkItems
    ]


viewLinkItem : LinkItem -> Html Msg
viewLinkItem linkItem =
    Layout.link
        [ Options.onClick <| NavigateTo linkItem.route ]
        [ Html.text linkItem.text ]


type alias LinkItem =
    { text : String
    , route : Route
    }


linkItems : List LinkItem
linkItems =
    [ { text = "Reports"
      , route = Routes.Reports
      }
    , { text = "Goods"
      , route = Routes.Goods
      }
    , { text = "Brands"
      , route = Routes.Brands
      }
    , { text = "Markets"
      , route = Routes.Markets
      }
    ]
