module Routing.Routes exposing (Route(..), mapBrands)

import Models.Brand exposing (Brand, RemoteBrands)


type Route
    = Home
    | Brands RemoteBrands


mapBrands : (RemoteBrands -> RemoteBrands) -> Route -> Route
mapBrands f route =
    case route of
        Brands brands ->
            Brands <| f brands

        _ ->
            route
