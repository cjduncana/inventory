module Subscriptions exposing (subscriptions)

import Material
import Model exposing (Model, Msg(Mdl))


subscriptions : Model -> Sub Msg
subscriptions model =
    Material.subscriptions Mdl model
