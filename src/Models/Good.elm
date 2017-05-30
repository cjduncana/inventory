port module Models.Good
    exposing
        ( Good
        , Goods
        , ImageURI(HasImage, NoImage)
        , createGood
        , deleteGood
        , destroyGood
        , editGood
        , getFilename
        , getGoods
        , getImageURI
        , goodsReceived
        , restoreGood
        )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Decode
import Json.Encode as Encode exposing (Value)
import Models.Brand exposing (Brand)
import Models.ID as ID
import Models.Market exposing (Markets)
import Models.Utilities as ModelUtil
import Uuid exposing (Uuid)


type alias Good =
    { id : Uuid
    , name : String
    , image : ImageURI
    , brand : Maybe Brand
    , markets : Markets
    }


type alias Goods =
    List Good


type ImageURI
    = NoImage
    | HasImage String


getFilename : ImageURI -> Maybe String
getFilename uri =
    case uri of
        NoImage ->
            Nothing

        HasImage filename ->
            Just filename


getImageURI : ImageURI -> String
getImageURI uri =
    "../images/"
        ++ case uri of
            NoImage ->
                "goods_placeholder.svg"

            HasImage filename ->
                filename


goodsReceived : (Goods -> msg) -> Sub msg
goodsReceived =
    goodsReceivedPort << fromValues


createGood : String -> ImageURI -> Maybe Brand -> Markets -> Cmd msg
createGood name uri maybeBrand markets =
    toCreateValue name uri maybeBrand markets
        |> createGoodPort


editGood : Good -> Cmd msg
editGood =
    editGoodPort << toValue


getGoods : Goods -> Cmd msg
getGoods storedGoods =
    ModelUtil.commandIfEmpty (getGoodsPort ()) storedGoods


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


port createGoodPort : Value -> Cmd msg


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
        decodeMaybeBrand =
            Decode.nullable ID.fromValue

        decodeMarkets =
            Decode.list ID.fromValue

        assignImage filename =
            if String.isEmpty filename then
                NoImage
            else
                HasImage filename

        toDecoder id name filename maybeBrand markets =
            case Uuid.fromString id of
                Nothing ->
                    Decode.fail "Not a valid Uuid."

                Just uuid ->
                    Decode.succeed <|
                        Good uuid name (assignImage filename) maybeBrand markets
    in
        Decode.decode toDecoder
            |> Decode.required "id" Decode.string
            |> Decode.required "name" Decode.string
            |> Decode.optional "image" Decode.string ""
            |> Decode.optional "brand" decodeMaybeBrand Nothing
            |> Decode.required "markets" decodeMarkets
            |> Decode.resolve


toCreateValue : String -> ImageURI -> Maybe Brand -> Markets -> Value
toCreateValue name uri maybeBrand markets =
    Encode.object <|
        [ ( "name", Encode.string name ) ]
            ++ imageKeyValuePair uri
            ++ brandIdKeyValuePair maybeBrand
            ++ [ ( "markets"
                 , Encode.list <|
                    List.map ID.toValue markets
                 )
               ]


toValue : Good -> Value
toValue good =
    Encode.object <|
        [ ( "id", Encode.string <| Uuid.toString good.id )
        , ( "name", Encode.string good.name )
        ]
            ++ imageKeyValuePair good.image
            ++ brandIdKeyValuePair good.brand
            ++ [ ( "markets"
                 , Encode.list <|
                    List.map ID.toValue good.markets
                 )
               ]


brandIdKeyValuePair : Maybe Brand -> List ( String, Value )
brandIdKeyValuePair =
    maybeKeyValuePair "brandId" <|
        Uuid.toString
            << .uuid


imageKeyValuePair : ImageURI -> List ( String, Value )
imageKeyValuePair =
    maybeKeyValuePair "image" identity << getFilename


maybeKeyValuePair : String -> (a -> String) -> Maybe a -> List ( String, Value )
maybeKeyValuePair key f maybe =
    let
        value =
            Maybe.map (f >> Encode.string) maybe
                |> Maybe.withDefault Encode.null
    in
        [ ( key, value ) ]
