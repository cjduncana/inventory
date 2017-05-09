module Updates.Brands exposing (get, update)

import Model exposing (Action(..), ActionType(..), Model, Msg)
import Models.Brand as Brand exposing (Brand)
import RemoteData exposing (RemoteData(Loading, Success))
import Routing.Routes exposing (Route(Brands))
import Utilities as Util


get : Model -> ( Model, Cmd Msg )
get model =
    let
        route =
            case model.route of
                Brands brands ->
                    if Util.isNotSuccess brands then
                        Brands Loading
                    else
                        model.route

                _ ->
                    model.route

        storedData =
            model.storedData

        storedData_ =
            { storedData | brands = Loading }

        model_ =
            { model
                | route = route
                , storedData = storedData_
                , lastAction = BrandAction List
            }
    in
        ( model_, Brand.getBrands )


update : List Brand -> Model -> ( Model, Cmd Msg )
update brands model =
    let
        storedData =
            model.storedData

        storedData_ =
            { storedData | brands = Success brands }

        model_ =
            { model
                | storedData = storedData_
                , lastAction = None
            }
    in
        case model.route of
            Brands _ ->
                ( { model_ | route = Brands <| Success brands }, Cmd.none )

            _ ->
                ( model_, Cmd.none )
