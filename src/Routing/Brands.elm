module Routing.Brands exposing (goto)

import Model exposing (Model, Msg)
import Models.Dialog exposing (DialogView(AddBrand))
import Models.Header exposing (Header, Fab(Add))
import Routing.Routes exposing (Route(Brands))
import Updates.Brands as Brands
import Utilities as Util


goto : Model -> ( Model, Cmd Msg )
goto model =
    let
        model_ =
            { model
                | route = Brands model.storedData.brands
                , header = Header "Brands List" Add
                , dialogView = AddBrand ""
            }
    in
        if Util.isNotSuccess model.storedData.brands then
            Brands.get model_
        else
            ( model_, Cmd.none )
