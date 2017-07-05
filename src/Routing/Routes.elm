module Routing.Routes
    exposing
        ( Route(Brands, Goods, Home, Markets, NewReport, Reports, ViewReport)
        , hasDialog
        )

import Models.Record exposing (PotentialRecords, Records)


type Route
    = Home
    | Brands
    | Goods
    | Markets
    | Reports
    | NewReport PotentialRecords
    | ViewReport (Maybe Records)


hasDialog : Route -> Bool
hasDialog route =
    case route of
        Home ->
            False

        Brands ->
            True

        Goods ->
            True

        Markets ->
            True

        Reports ->
            False

        NewReport _ ->
            False

        ViewReport _ ->
            False
