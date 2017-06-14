module Updates.Brands exposing (delete, update)

import Model exposing (Model, Msg)
import Models.Brand as Brand exposing (Brand, Brands)
import Models.Snackbar exposing (Payload(DeletedBrand))
import Updates.Utilities as UpdateUtils


update : Brands -> Model -> ( Model, Cmd Msg )
update brands model =
    model.storedData
        |> (\data -> { data | brands = brands })
        |> UpdateUtils.updateStoredData model


delete : Brand -> Model -> ( Model, Cmd Msg )
delete brand model =
    Brand.deleteBrand brand.uuid
        |> UpdateUtils.addSnackbar model brand.name (DeletedBrand brand)
