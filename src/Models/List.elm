port module Models.List exposing (..)

import Uuid exposing (Uuid)


type alias ListObject =
    { id : Uuid
    , name : String
    }


type alias ListObjects =
    List ListObject


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


unpack : ListType a -> a
unpack listType =
    case listType of
        Brand a ->
            a

        Market a ->
            a
