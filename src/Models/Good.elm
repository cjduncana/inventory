port module Models.Good
    exposing
        ( Good
        , GoodData
        , Goods
        , ImageURI(HasImage, NoImage)
        , createGood
        , deleteGood
        , destroyGood
        , editGood
        , getBrand
        , getFilename
        , getGoods
        , getImage
        , getImageURI
        , getMarkets
        , getName
        , getUuid
        , goodsReceived
        , restoreGood
        )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Decode
import Json.Encode as Encode exposing (Value)
import Maybe.Extra as Maybe
import Models.Brand exposing (Brand)
import Models.ID as ID exposing (ID)
import Models.Market exposing (Markets)
import Models.Utilities as ModelUtil
import Uuid exposing (Uuid)


type alias GoodData =
    { image : ImageURI
    , brand : Maybe Brand
    , markets : Markets
    }


type alias Good =
    ( ID, GoodData )


type alias Goods =
    List Good


type ImageURI
    = NoImage
    | HasImage String


getUuid : Good -> Uuid
getUuid =
    Tuple.first >> .uuid


getName : Good -> String
getName =
    Tuple.first >> .name


getImage : Good -> ImageURI
getImage =
    Tuple.second >> .image


getBrand : Good -> Maybe Brand
getBrand =
    Tuple.second >> .brand


getMarkets : Good -> Markets
getMarkets =
    Tuple.second >> .markets


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


createGood : String -> GoodData -> Cmd msg
createGood name data =
    toCreateValue name data
        |> createGoodPort


editGood : Good -> Cmd msg
editGood =
    editGoodPort << toValue


getGoods : Goods -> Cmd msg
getGoods =
    ModelUtil.commandIfEmpty getGoodsPort


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

        imageUriDecoder =
            Decode.string
                |> Decode.andThen
                    (Just
                        >> Maybe.filter (not << String.isEmpty)
                        >> Maybe.map HasImage
                        >> Maybe.withDefault NoImage
                        >> Decode.succeed
                    )

        toDecoder uuid name imageUri maybeBrand markets =
            ( ID uuid name
            , GoodData imageUri maybeBrand markets
            )
                |> Decode.succeed
    in
        Decode.decode toDecoder
            |> Decode.required "id" Uuid.decoder
            |> Decode.required "name" Decode.string
            |> Decode.optional "image" imageUriDecoder NoImage
            |> Decode.optional "brand" decodeMaybeBrand Nothing
            |> Decode.required "markets" decodeMarkets
            |> Decode.resolve


toCreateValue : String -> GoodData -> Value
toCreateValue name data =
    Encode.object <|
        [ ( "name", Encode.string name ) ]
            ++ imageKeyValuePair data.image
            ++ brandIdKeyValuePair data.brand
            ++ [ ( "markets"
                 , Encode.list <|
                    List.map ID.toValue data.markets
                 )
               ]


toValue : Good -> Value
toValue good =
    Encode.object <|
        [ ( "id", Uuid.encode <| getUuid good )
        , ( "name", Encode.string <| getName good )
        ]
            ++ imageKeyValuePair (getImage good)
            ++ brandIdKeyValuePair (getBrand good)
            ++ [ ( "markets"
                 , Encode.list <|
                    List.map ID.toValue <|
                        getMarkets good
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
