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
        , removeImage
        )

import Material
import Models.Brand exposing (Brand)
import Models.Good exposing (Good, ImageURI)
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
    | GoodBrandChange String
    | MarketAdd String
    | MarketAddDialog
    | ObjectEdit ListObject
    | EditDialog ListObject
    | AddFileDialog
    | ImageSaved String
    | RemoveImage


type DialogView
    = Default
    | AddBrand String
    | AddGood String ImageURI (Maybe Brand) Markets
    | EditGood Good String ImageURI (Maybe Brand)
    | AddMarket String
    | EditView ListObject String


getFilename : DialogView -> Maybe String
getFilename dialogView =
    case dialogView of
        AddGood _ uri _ _ ->
            Models.Good.getFilename uri

        EditGood _ _ uri _ ->
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

        AddGood name uri maybeBrand markets ->
            AddGood (f name) uri maybeBrand markets

        EditGood good name uri maybeBrand ->
            EditGood good (f name) uri maybeBrand

        AddMarket name ->
            AddMarket <| f name

        EditView object name ->
            EditView object <| f name


addFileDialog : Cmd msg
addFileDialog =
    addFileDialogPort ()


port addFileDialogPort : () -> Cmd msg


port imageSaved : (String -> msg) -> Sub msg


port removeImage : String -> Cmd msg
