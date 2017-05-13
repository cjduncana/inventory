module Models.Header
    exposing
        ( Fab(Absent, Add)
        , Header
        , init
        , brandsList
        , goodsList
        , marketsList
        )


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


goodsList : Header
goodsList =
    list "Goods"


marketsList : Header
marketsList =
    list "Markets"


list : String -> Header
list section =
    Header section Add


type Fab
    = Absent
    | Add
