module Routing.Routes exposing (Route(..))

import Models.Brand as Brand
import Models.Market as Market


type Route
    = Home
    | Brands Brand.Brands
    | Markets Market.Markets
