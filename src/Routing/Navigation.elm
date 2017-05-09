module Routing.Navigation exposing (gotoRoute)

import Model exposing (Model, Msg)
import Routing.Home as Home
import Routing.Brands as Brands
import Routing.Markets as Markets
import Routing.Routes exposing (Route(..))


gotoRoute : Route -> Model -> ( Model, Cmd Msg )
gotoRoute route model =
    case route of
        Home ->
            Home.goto model

        Brands _ ->
            Brands.goto model

        Markets _ ->
            Markets.goto model
