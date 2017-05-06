module Routing.Routes exposing (Route(..))

import Models.Brand exposing (Brand)
import Models.Error exposing (Error)
import RemoteData exposing (RemoteData)


type Route
    = Home
    | Brands (RemoteData Error (List Brand))
