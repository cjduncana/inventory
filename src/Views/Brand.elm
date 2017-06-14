module Views.Brand exposing (view)

import Html exposing (Html)
import Model exposing (Model, Msg)
import Models.Brand exposing (Brands)
import Views.Utilities as ViewUtil


view : Model -> Brands -> Html Msg
view model =
    ViewUtil.grid model Model.DeleteBrand
        |> ViewUtil.showList "No Brands yet"
