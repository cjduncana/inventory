port module Models.Brand
    exposing
        ( Brand
        , Brands
        , createBrand
        , editBrand
        , getBrands
        , deleteBrand
        , destroyBrand
        , restoreBrand
        , brandsReceived
        )

import Json.Encode exposing (Value)
import Models.List as List
import Uuid exposing (Uuid)


type alias Brand =
    { id : Uuid
    , name : String
    }


type alias Brands =
    List Brand


createBrand : String -> Cmd msg
createBrand =
    createBrandPort


editBrand : Brand -> Cmd msg
editBrand =
    editBrandPort << List.toValue


getBrands : Cmd msg
getBrands =
    getBrandsPort ()


deleteBrand : Uuid -> Cmd msg
deleteBrand =
    deleteBrandPort << Uuid.toString


destroyBrand : Uuid -> Cmd msg
destroyBrand =
    destroyBrandPort << Uuid.toString


restoreBrand : Uuid -> Cmd msg
restoreBrand =
    restoreBrandPort << Uuid.toString


brandsReceived : (Brands -> msg) -> Sub msg
brandsReceived =
    brandsReceivedPort << List.fromValues


port createBrandPort : String -> Cmd msg


port editBrandPort : Value -> Cmd msg


port getBrandsPort : () -> Cmd msg


port deleteBrandPort : String -> Cmd msg


port destroyBrandPort : String -> Cmd msg


port restoreBrandPort : String -> Cmd msg


port brandsReceivedPort : (Value -> msg) -> Sub msg
