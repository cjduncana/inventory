module Views.Drawer exposing (view)

import Html exposing (Html)
import Material.Layout as Layout
import Material.Options as Options
import Model exposing (Model, Msg(Mdl, NavigateTo))
import Routing.Routes exposing (Route(Brands, Goods, Home, Markets))


view : Model -> List (Html Msg)
view model =
    [ Layout.title [] [ Html.text "Inventory" ]
    , Layout.navigation
        [ Options.onClick <| Layout.toggleDrawer Mdl ]
      <|
        List.map viewLinkItem (linkItems model)
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


linkItems : Model -> List LinkItem
linkItems model =
    [ { text = "Reports"
      , route = Home
      }
    , { text = "Goods"
      , route = Goods model.storedData.goods
      }
    , { text = "Brands"
      , route = Brands model.storedData.brands
      }
    , { text = "Markets"
      , route = Markets model.storedData.markets
      }
    ]
