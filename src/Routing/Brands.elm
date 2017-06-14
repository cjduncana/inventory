module Routing.Brands exposing (goto)

import Model exposing (Model, Msg)
import Models.Brand as Brand
import Models.Dialog exposing (DialogView(AddBrand))
import Models.Header as Header
import Routing.Routes exposing (Route(Brands))


goto : Model -> ( Model, Cmd Msg )
goto model =
    Brand.getBrands model.storedData.brands
        |> (,)
            { model
                | route = Brands
                , header = Header.brandsList
                , dialogView = AddBrand ""
            }
