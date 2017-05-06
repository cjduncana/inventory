module Update exposing (update)

import Material
import Model exposing (Model, Msg(..))
import Routing.Navigation as Navigation
import Updates.Brands as Brands
import Updates.Dialog as Dialog


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model

        NavigateTo route ->
            Navigation.gotoRoute route model

        DialogMsg msg_ ->
            Dialog.update msg_ model

        BrandsRecieved brands ->
            Brands.update brands model

        DeleteBrand brandId ->
            Brands.delete brandId model
