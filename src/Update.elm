module Update exposing (update)

import Material
import Model
    exposing
        ( Model
        , Msg
            ( AddFileDialog
            , BrandsReceived
            , DeleteGood
            , DeleteObject
            , DialogMsg
            , ErrorReceived
            , GoodsReceived
            , ImageSaved
            , MarketsReceived
            , Mdl
            , NavigateTo
            , SnackbarMsg
            )
        )
import Routing.Navigation as Navigation
import Updates.Brands as Brands
import Updates.Dialog as Dialog
import Updates.Error as Error
import Updates.Goods as Goods
import Updates.List as List
import Updates.Markets as Markets
import Updates.Snackbar as Snackbar


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model

        SnackbarMsg msg_ ->
            Snackbar.update msg_ model

        NavigateTo route ->
            Navigation.gotoRoute route model

        ErrorReceived error ->
            Error.update error model

        DialogMsg msg_ ->
            Dialog.update msg_ model

        BrandsReceived brands ->
            Brands.update brands model

        GoodsReceived goods ->
            Goods.update goods model

        MarketsReceived markets ->
            Markets.update markets model

        DeleteGood good ->
            Goods.delete good model

        DeleteObject listType ->
            List.delete listType model

        AddFileDialog ->
            Goods.addFileDialog model

        ImageSaved filename ->
            Goods.imageSaved model filename
