module Subscriptions exposing (subscriptions)

import Material
import Model
    exposing
        ( Model
        , Msg
            ( BrandsReceived
            , ErrorReceived
            , GoodsReceived
            , MarketsReceived
            , Mdl
            )
        )
import Models.Brand as Brand
import Models.Good as Good
import Models.Error as Error
import Models.Market as Market


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Material.subscriptions Mdl model
        , Brand.brandsReceived BrandsReceived
        , Good.goodsReceived GoodsReceived
        , Market.marketsReceived MarketsReceived
        , Error.errorReceived ErrorReceived
        ]
