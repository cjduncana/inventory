module Subscriptions exposing (subscriptions)

import Material
import Model exposing (Model, Msg(..))
import Models.Brand as Brand
import Models.Error as Error


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Material.subscriptions Mdl model
        , Brand.brandsRecieved BrandsRecieved
        , Error.errorRecieved ErrorRecieved
        ]
