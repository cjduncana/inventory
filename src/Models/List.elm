module Models.List
    exposing
        ( ListObject
        , ListObjects
        , ListType(Brand, Market)
        , map
        , apply
        , unpack
        , fromValues
        , fromValue
        , toValue
        )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Decode
import Json.Encode as Encode exposing (Value)
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



-- Decoders


fromValues : (ListObjects -> msg) -> Value -> msg
fromValues f value =
    Decode.decodeValue (Decode.list fromValue) value
        |> Result.withDefault []
        |> f


fromValue : Decoder ListObject
fromValue =
    let
        toDecoder id name =
            case Uuid.fromString id of
                Nothing ->
                    Decode.fail "Not a valid Uuid."

                Just uuid ->
                    Decode.succeed <|
                        ListObject uuid name
    in
        Decode.decode toDecoder
            |> Decode.required "id" Decode.string
            |> Decode.required "name" Decode.string
            |> Decode.resolve


toValue : ListObject -> Value
toValue listObject =
    Encode.object
        [ ( "id", Encode.string <| Uuid.toString listObject.id )
        , ( "name", Encode.string listObject.name )
        ]
