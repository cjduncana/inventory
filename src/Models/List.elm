port module Models.List exposing (..)

import Models.Error exposing (Error)
import RemoteData exposing (RemoteData)
import Uuid exposing (Uuid)


type alias ListObject =
    { id : Uuid
    , name : String
    }


type alias RemoteObjects =
    RemoteData Error (List ListObject)


type ListType
    = Brands RemoteObjects
    | Markets RemoteObjects
