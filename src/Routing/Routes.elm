module Routing.Routes exposing (Route(..))

import Models.Brand exposing (Brand)


type Route
    = Home
    | Brands (Maybe (List Brand))
