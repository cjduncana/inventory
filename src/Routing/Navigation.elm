module Routing.Navigation exposing (gotoRoute)

import Model exposing (Model, Msg)
import Routing.Home as Home
import Routing.Brands as Brands
import Routing.Goods as Goods
import Routing.Markets as Markets
import Routing.Reports as Reports
import Routing.Routes
    exposing
        ( Route
            ( Brands
            , Goods
            , Home
            , Markets
            , NewReport
            , Reports
            )
        )


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

        Reports ->
            Reports.goto model

        NewReport _ ->
            Reports.gotoNew model
