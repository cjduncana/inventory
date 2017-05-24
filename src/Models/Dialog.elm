port module Models.Dialog
    exposing
        ( DialogView
            ( AddBrand
            , AddGood
            , AddMarket
            , Default
            , EditGood
            , EditView
            )
        , Msg
            ( AddFileDialog
            , BrandAdd
            , BrandAddDialog
            , DropdownMsg
            , EditDialog
            , GoodAdd
            , GoodAddDialog
            , GoodBrandChange
            , GoodEdit
            , GoodEditDialog
            , ImageSaved
            , MarketAdd
            , MarketAddDialog
            , Mdl
            , NameUpdate
            , ObjectEdit
            , RemoveImage
            )
        , addFileDialog
        , getFilename
        , imageSaved
        , mapName
        , newAddGoodView
        , newEditGoodView
        , setBrand
        , setImage
        , removeImage
        )

import Dropdown
import Material
import Models.Brand exposing (Brand)
import Models.Good exposing (Good, ImageURI(NoImage))
import Models.List exposing (ListObject)
import Models.Market exposing (Markets)


type Msg
    = Mdl (Material.Msg Msg)
    | NameUpdate String
    | BrandAdd String
    | BrandAddDialog
    | GoodAdd String ImageURI (Maybe Brand)
    | GoodAddDialog
    | GoodEdit Good
    | GoodEditDialog Good
    | MarketAdd String
    | MarketAddDialog
    | ObjectEdit ListObject
    | EditDialog ListObject
    | AddFileDialog
    | ImageSaved String
    | RemoveImage
    | DropdownMsg (Dropdown.Msg Brand)
    | GoodBrandChange (Maybe Brand)


type DialogView
    = Default
    | AddBrand String
    | AddGood Dropdown.State String ImageURI (Maybe Brand) Markets
    | EditGood Dropdown.State Good String ImageURI (Maybe Brand)
    | AddMarket String
    | EditView ListObject String


newAddGoodView : DialogView
newAddGoodView =
    AddGood (Dropdown.newState "brand") "" NoImage Nothing []


newEditGoodView : Good -> DialogView
newEditGoodView good =
    EditGood (Dropdown.newState "brand") good good.name good.image good.brand


getFilename : DialogView -> Maybe String
getFilename dialogView =
    case dialogView of
        AddGood _ _ uri _ _ ->
            Models.Good.getFilename uri

        EditGood _ _ _ uri _ ->
            Models.Good.getFilename uri

        _ ->
            Nothing


mapName : (String -> String) -> DialogView -> DialogView
mapName f dialogView =
    case dialogView of
        Default ->
            Default

        AddBrand name ->
            AddBrand <| f name

        AddGood dropdownState name uri maybeBrand markets ->
            AddGood dropdownState (f name) uri maybeBrand markets

        EditGood dropdownState good name uri maybeBrand ->
            EditGood dropdownState good (f name) uri maybeBrand

        AddMarket name ->
            AddMarket <| f name

        EditView object name ->
            EditView object <| f name


setBrand : Maybe Brand -> DialogView -> DialogView
setBrand maybeBrand dialogView =
    case dialogView of
        AddGood dropdownState name uri _ markets ->
            AddGood dropdownState name uri maybeBrand markets

        EditGood dropdownState good name uri _ ->
            EditGood dropdownState good name uri maybeBrand

        _ ->
            dialogView


setImage : ImageURI -> DialogView -> DialogView
setImage uri dialogView =
    case dialogView of
        AddGood dropdownState name _ maybeBrand markets ->
            AddGood dropdownState name uri maybeBrand markets

        EditGood dropdownState good name _ maybeBrand ->
            EditGood dropdownState good name uri maybeBrand

        _ ->
            dialogView


addFileDialog : Cmd msg
addFileDialog =
    addFileDialogPort ()


port addFileDialogPort : () -> Cmd msg


port imageSaved : (String -> msg) -> Sub msg


port removeImage : String -> Cmd msg
