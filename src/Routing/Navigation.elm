module Routing.Navigation exposing (gotoRoute)

import Model exposing (Model, Msg)
import Routing.Home as Home
import Routing.Brands as Brands
import Routing.Goods as Goods
import Routing.Markets as Markets
import Routing.Routes exposing (Route(Brands, Goods, Home, Markets))


gotoRoute : Route -> Model -> ( Model, Cmd Msg )
gotoRoute route model =
    case route of
        Home ->
            Home.goto model

        Brands ->
            Brands.goto model

        Goods ->
            Goods.goto model

        Markets ->
            Markets.goto model
