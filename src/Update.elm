module Update exposing (update)

import Material
import Model exposing (Model, Msg(..))
import Routing.Navigation as Navigation
import Updates.Brands as Brands
import Updates.Dialog as Dialog
import Updates.Error as Error
import Updates.List as List
import Updates.Markets as Markets


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model

        NavigateTo route ->
            Navigation.gotoRoute route model

        ErrorReceived error ->
            Error.update error model

        DialogMsg msg_ ->
            Dialog.update msg_ model

        BrandsReceived brands ->
            Brands.update brands model

        MarketsReceived markets ->
            Markets.update markets model

        DeleteObject listType uuid ->
            List.delete listType uuid model
