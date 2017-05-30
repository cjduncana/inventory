port module Models.Brand
    exposing
        ( Brand
        , Brands
        , createBrand
        , editBrand
        , findBrand
        , getBrands
        , deleteBrand
        , destroyBrand
        , restoreBrand
        , brandsReceived
        )

import Json.Encode exposing (Value)
import Models.ID as ID exposing (ID)
import Models.Utilities as ModelUtil
import Uuid exposing (Uuid)


type alias Brand =
    ID


type alias Brands =
    List Brand


findBrand : Brands -> Uuid -> Maybe Brand
findBrand brands uuid =
    List.filter (sameBrand uuid) brands
        |> List.head


sameBrand : Uuid -> Brand -> Bool
sameBrand uuid =
    .uuid >> (==) uuid


createBrand : String -> Cmd msg
createBrand =
    createBrandPort


editBrand : Brand -> Cmd msg
editBrand =
    editBrandPort << ID.toValue


getBrands : Brands -> Cmd msg
getBrands storedBrands =
    ModelUtil.commandIfEmpty (getBrandsPort ()) storedBrands


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
    brandsReceivedPort << ID.fromValues


port createBrandPort : String -> Cmd msg


port editBrandPort : Value -> Cmd msg


port getBrandsPort : () -> Cmd msg


port deleteBrandPort : String -> Cmd msg


port destroyBrandPort : String -> Cmd msg


port restoreBrandPort : String -> Cmd msg


port brandsReceivedPort : (Value -> msg) -> Sub msg
