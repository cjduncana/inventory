module Model exposing (..)

import Material


type alias Model =
    { mdl : Material.Model
    }


initialModel : Model
initialModel =
    { mdl = Material.model
    }


init : ( Model, Cmd Msg )
init =
    (initialModel) ! [ Material.init Mdl ]


type Msg
    = Mdl (Material.Msg Msg)
