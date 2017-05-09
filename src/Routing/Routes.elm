module Routing.Routes exposing (..)

import Models.Brand exposing (RemoteBrands)
import Models.Market exposing (RemoteMarkets)


type Route
    = Home
    | Brands RemoteBrands
    | Markets RemoteMarkets


mapBrands : (RemoteBrands -> RemoteBrands) -> Route -> Route
mapBrands f route =
    case route of
        Brands brands ->
            Brands <| f brands

        _ ->
            route


mapMarkets : (RemoteMarkets -> RemoteMarkets) -> Route -> Route
mapMarkets f route =
    case route of
        Markets brands ->
            Markets <| f brands

        _ ->
            route
