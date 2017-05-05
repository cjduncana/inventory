module Routing.Routes exposing (Route(..))

import Models.Brand exposing (Brand)
import RemoteData exposing (RemoteData)
import Routing.Error exposing (Error)


type Route
    = Home
    | Brands (RemoteData Error (List Brand))
