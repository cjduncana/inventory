port module Models.Brand exposing (..)


type alias Brand =
    { id : String
    , name : String
    }


port createBrand : String -> Cmd msg


port getBrands : () -> Cmd msg


port brandsRecieved : (List Brand -> msg) -> Sub msg
