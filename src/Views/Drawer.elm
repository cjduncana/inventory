module Views.Drawer exposing (view)

import Html exposing (Html)
import Material.Layout as Layout
import Material.Options as Options
import Model exposing (Msg(Mdl, NavigateTo))
import Routing.Routes as Routes exposing (Route)
import Translation.Main as T


view : List (Html Msg)
view =
    [ Layout.title
        [ Options.onClick <| NavigateTo Routes.Home
        , Options.onMouseUp <| Layout.toggleDrawer Mdl
        ]
        [ Html.text T.inventory ]
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
    [ { text = T.reports
      , route = Routes.Reports
      }
    , { text = T.goods
      , route = Routes.Goods
      }
    , { text = T.brands
      , route = Routes.Brands
      }
    , { text = T.markets
      , route = Routes.Markets
      }
    ]
