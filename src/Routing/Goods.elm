module Routing.Goods exposing (goto)

import Model exposing (Model, Msg)
import Models.Dialog exposing (DialogView(AddGood))
import Models.Good exposing (ImageURI(NoImage))
import Models.Header as Header
import Routing.Routes exposing (Route(Goods))
import Updates.Goods as Goods


goto : Model -> ( Model, Cmd Msg )
goto model =
    let
        model_ =
            { model
                | route = Goods model.storedData.goods
                , header = Header.goodsList
                , dialogView = AddGood "" NoImage Nothing []
            }
    in
        if List.isEmpty model.storedData.goods then
            Goods.get model_
        else
            ( model_, Cmd.none )
