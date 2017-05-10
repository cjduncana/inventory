module Subscriptions exposing (subscriptions)

import Material
import Model exposing (Model, Msg(..))
import Models.Brand as Brand
import Models.Error as Error
import Models.Market as Market


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Material.subscriptions Mdl model
        , Brand.brandsReceived BrandsReceived
        , Market.marketsReceived MarketsReceived
        , Error.errorReceived ErrorReceived
        ]
