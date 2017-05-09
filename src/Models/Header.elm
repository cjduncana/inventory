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
    list "Brands"


marketsList : Header
marketsList =
    list "Markets"


list : String -> Header
list section =
    Header section Add


type Fab
    = Absent
    | Add
