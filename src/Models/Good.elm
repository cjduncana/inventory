port module Models.Good
    exposing
        ( Good
        , Goods
        , ImageURI(NoImage)
        , createGood
        , editGood
        , getGoods
        , getImageURI
        , goodsReceived
        , deleteGood
        , destroyGood
        , restoreGood
        )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Decode
import Json.Encode as Encode exposing (Value)
import Models.Brand exposing (Brand)
import Models.Market exposing (Markets)
import Uuid exposing (Uuid)


type alias Good =
    { id : Uuid
    , name : String
    , image : ImageURI
    , brand : Maybe Brand
    , markets : Markets
    }


type ImageURI
    = NoImage
    | HasImage String


getImageURI : ImageURI -> String
getImageURI uri =
    "../images/"
        ++ case uri of
            NoImage ->
                "goods_placeholder.svg"

            HasImage filename ->
                filename


type alias Goods =
    List Good


goodsReceived : (Goods -> msg) -> Sub msg
goodsReceived =
    goodsReceivedPort << fromValues


createGood : String -> Cmd msg
createGood =
    createGoodPort


editGood : Good -> Cmd msg
editGood =
    editGoodPort << toValue


getGoods : Cmd msg
getGoods =
    getGoodsPort ()


deleteGood : Uuid -> Cmd msg
deleteGood =
    deleteGoodPort << Uuid.toString


destroyGood : Uuid -> Cmd msg
destroyGood =
    destroyGoodPort << Uuid.toString


restoreGood : Uuid -> Cmd msg
restoreGood =
    restoreGoodPort << Uuid.toString


port goodsReceivedPort : (Value -> msg) -> Sub msg


port createGoodPort : String -> Cmd msg


port editGoodPort : Value -> Cmd msg


port getGoodsPort : () -> Cmd msg


port deleteGoodPort : String -> Cmd msg


port destroyGoodPort : String -> Cmd msg


port restoreGoodPort : String -> Cmd msg


fromValues : (Goods -> msg) -> Value -> msg
fromValues f value =
    Decode.decodeValue (Decode.list fromValue) value
        |> Result.withDefault []
        |> f


fromValue : Decoder Good
fromValue =
    let
        toDecoder id name =
            case Uuid.fromString id of
                Nothing ->
                    Decode.fail "Not a valid Uuid."

                Just uuid ->
                    Decode.succeed <|
                        Good uuid name NoImage Nothing []
    in
        Decode.decode toDecoder
            |> Decode.required "id" Decode.string
            |> Decode.required "name" Decode.string
            |> Decode.resolve


toValue : Good -> Value
toValue good =
    Encode.object
        [ ( "id", Encode.string <| Uuid.toString good.id )
        , ( "name", Encode.string good.name )
        ]
