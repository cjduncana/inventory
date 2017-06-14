module Routing.Navigation exposing (gotoRoute)

import Model exposing (Model, Msg)
import Routing.Home as Home
import Routing.Brands as Brands
import Routing.Goods as Goods
import Routing.Markets as Markets
import Routing.Reports as Reports
import Routing.Routes as Routes exposing (Route)


gotoRoute : Route -> Model -> ( Model, Cmd Msg )
gotoRoute route model =
    case route of
        Routes.Home ->
            Home.goto model

        Routes.Brands ->
            Brands.goto model

        Routes.Goods ->
            Goods.goto model

        Routes.Markets ->
            Markets.goto model

        Routes.Reports ->
            Reports.goto model

        Routes.NewReport _ ->
            Reports.gotoNew model
