port module Models.Brand exposing (..)

import Uuid exposing (Uuid)


type alias Brand =
    { id : Uuid
    , name : String
    }


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


brandsRecieved : (List Brand -> msg) -> Sub msg
brandsRecieved f =
    brandsRecievedPort <| f << fromJsonList


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


fromJsonList : List BrandJson -> List Brand
fromJsonList =
    List.filterMap fromJson


toJson : Brand -> BrandJson
toJson brand =
    BrandJson (Uuid.toString brand.id) brand.name


port createBrandPort : String -> Cmd msg


port editBrandPort : BrandJson -> Cmd msg


port getBrandsPort : () -> Cmd msg


port deleteBrandPort : String -> Cmd msg


port brandsRecievedPort : (List BrandJson -> msg) -> Sub msg
