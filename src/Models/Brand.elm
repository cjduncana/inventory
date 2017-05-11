port module Models.Brand exposing (..)

import Uuid exposing (Uuid)


type alias Brand =
    { id : Uuid
    , name : String
    }


type alias Brands =
    List Brand


type alias BrandJson =
    { id : String
    , name : String
    }


createBrand : String -> Cmd msg
createBrand =
    createBrandPort


editBrand : Brand -> Cmd msg
editBrand =
    editBrandPort << toJson


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
brandsReceived f =
    brandsReceivedPort <| f << fromJsonList


doCommand : String -> Cmd msg -> Cmd msg
doCommand name cmd =
    if String.isEmpty name then
        Cmd.none
    else
        cmd


fromJson : BrandJson -> Maybe Brand
fromJson json =
    Maybe.map (flip Brand json.name) <|
        Uuid.fromString json.id


fromJsonList : List BrandJson -> Brands
fromJsonList =
    List.filterMap fromJson


toJson : Brand -> BrandJson
toJson brand =
    BrandJson (Uuid.toString brand.id) brand.name


port createBrandPort : String -> Cmd msg


port editBrandPort : BrandJson -> Cmd msg


port getBrandsPort : () -> Cmd msg


port deleteBrandPort : String -> Cmd msg


port destroyBrandPort : String -> Cmd msg


port restoreBrandPort : String -> Cmd msg


port brandsReceivedPort : (List BrandJson -> msg) -> Sub msg
