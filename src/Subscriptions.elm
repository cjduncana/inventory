module Subscriptions exposing (subscriptions)

import Material
import Model exposing (Model, Msg(Mdl, BrandsRecieved))
import Models.Brand as Brand


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Material.subscriptions Mdl model
        , Brand.brandsRecieved BrandsRecieved
        ]
