module Routing.Routes
    exposing
        ( Route(Brands, Goods, Home, Markets, NewReport, Reports)
        , hasDialog
        )

import Models.Record exposing (PotentialRecords)


type Route
    = Home
    | Brands
    | Goods
    | Markets
    | Reports
    | NewReport PotentialRecords


hasDialog : Route -> Bool
hasDialog route =
    case route of
        Reports ->
            False

        NewReport _ ->
            False

        _ ->
            True
