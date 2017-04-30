module Main exposing (main)

import Html
import Model exposing (Model, Msg)
import Subscriptions
import Update
import View


main : Program Never Model Msg
main =
    Html.program
        { init = Model.init
        , update = Update.update
        , subscriptions = Subscriptions.subscriptions
        , view = View.view
        }
