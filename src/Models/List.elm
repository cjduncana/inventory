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


type ListType a
    = Brand a
    | Market a


map : (a -> b) -> ListType a -> ListType b
map f listType =
    case listType of
        Brand a ->
            Brand <| f a

        Market a ->
            Market <| f a


apply : (String -> a -> b) -> ListType a -> b
apply f listType =
    case listType of
        Brand a ->
            f "Brand" a

        Market a ->
            f "Market" a
