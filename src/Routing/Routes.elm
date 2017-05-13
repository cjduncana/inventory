module Routing.Routes exposing (Route(Brands, Goods, Home, Markets))

import Models.Brand as Brand
import Models.Good as Good
import Models.Market as Market


type Route
    = Home
    | Brands Brand.Brands
    | Goods Good.Goods
    | Markets Market.Markets
