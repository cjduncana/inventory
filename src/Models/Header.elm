module Models.Header exposing (..)


type alias Header =
    { title : String
    , fab : Fab
    }


init : Header
init =
    Header "Inventory" Absent


brandsList : Header
brandsList =
    Header "Brands List" Add


type Fab
    = Absent
    | Add
