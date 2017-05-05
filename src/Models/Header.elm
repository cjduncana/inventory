module Models.Header exposing (Fab(..), Header, init)


type alias Header =
    { title : String
    , fab : Fab
    }


init : Header
init =
    Header "Inventory" Absent


type Fab
    = Absent
    | Add
