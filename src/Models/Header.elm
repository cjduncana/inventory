module Models.Header
    exposing
        ( Fab(Absent, Add)
        , Header
        , init
        , brandsList
        , goodsList
        , marketsList
        , newReport
        , reportsList
        )

import Translation.Main as T


type alias Header =
    { title : String
    , fab : Fab
    }


init : Header
init =
    Header T.inventory Absent


brandsList : Header
brandsList =
    list T.brands


goodsList : Header
goodsList =
    list T.goods


marketsList : Header
marketsList =
    list T.markets


reportsList : Header
reportsList =
    list T.reports


newReport : Header
newReport =
    Header T.newReport Absent


list : String -> Header
list section =
    Header section Add


type Fab
    = Absent
    | Add
