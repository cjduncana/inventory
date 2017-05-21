port module Models.Good
    exposing
        ( Good
        , Goods
        , ImageURI(HasImage, NoImage)
        , addFileDialog
        , createGood
        , deleteGood
        , destroyGood
        , editGood
        , getGoods
        , getImageURI
        , goodsReceived
        , imageSaved
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


type alias Goods =
    List Good


goodsReceived : (Goods -> msg) -> Sub msg
goodsReceived =
    goodsReceivedPort << fromValues


createGood : String -> ImageURI -> Cmd msg
createGood name uri =
    toCreateValue name uri
        |> createGoodPort


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


addFileDialog : Cmd msg
addFileDialog =
    addFileDialogPort ()


port goodsReceivedPort : (Value -> msg) -> Sub msg


port createGoodPort : Value -> Cmd msg


port editGoodPort : Value -> Cmd msg


port getGoodsPort : () -> Cmd msg


port deleteGoodPort : String -> Cmd msg


port destroyGoodPort : String -> Cmd msg


port restoreGoodPort : String -> Cmd msg


port addFileDialogPort : () -> Cmd msg


port imageSaved : (String -> msg) -> Sub msg


fromValues : (Goods -> msg) -> Value -> msg
fromValues f value =
    Decode.decodeValue (Decode.list fromValue) value
        |> Result.withDefault []
        |> f


fromValue : Decoder Good
fromValue =
    let
        assignImage filename =
            if String.isEmpty filename then
                NoImage
            else
                HasImage filename

        toDecoder id name filename =
            case Uuid.fromString id of
                Nothing ->
                    Decode.fail "Not a valid Uuid."

                Just uuid ->
                    Decode.succeed <|
                        Good uuid name (assignImage filename) Nothing []
    in
        Decode.decode toDecoder
            |> Decode.required "id" Decode.string
            |> Decode.required "name" Decode.string
            |> Decode.optional "image" Decode.string ""
            |> Decode.resolve


toCreateValue : String -> ImageURI -> Value
toCreateValue name uri =
    Encode.object <|
        ( "name", Encode.string name )
            :: imageKeyValuePair uri


toValue : Good -> Value
toValue good =
    Encode.object <|
        [ ( "id", Encode.string <| Uuid.toString good.id )
        , ( "name", Encode.string good.name )
        ]
            ++ imageKeyValuePair good.image


imageKeyValuePair : ImageURI -> List ( String, Value )
imageKeyValuePair uri =
    let
        addFilename filename =
            [ ( "image", Encode.string filename ) ]
    in
        Maybe.map addFilename (getFilename uri)
            |> Maybe.withDefault []
