module Views.Drawer exposing (view)

import Html exposing (Html)
import Material.Layout as Layout
import Material.Options as Options
import Model exposing (Msg(Mdl, NavigateTo))
import Routing.Routes exposing (Route(Brands, Goods, Markets, Reports))


view : List (Html Msg)
view =
    [ Layout.title [] [ Html.text "Inventory" ]
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
      , route = Reports
      }
    , { text = "Goods"
      , route = Goods
      }
    , { text = "Brands"
      , route = Brands
      }
    , { text = "Markets"
      , route = Markets
      }
    ]
