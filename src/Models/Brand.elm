port module Models.Brand exposing (..)


type alias Brand =
    { id : String
    , name : String
    }


port createBrand : String -> Cmd msg


port editBrand : Brand -> Cmd msg


port getBrands : () -> Cmd msg


port brandsRecieved : (List Brand -> msg) -> Sub msg


doCommand : String -> Cmd msg -> Cmd msg
doCommand name cmd =
    if String.isEmpty name then
        Cmd.none
    else
        cmd
