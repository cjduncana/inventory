module Updates.Markets exposing (get, update)

import Model exposing (Model, Msg)
import Models.Market as Market exposing (Market)
import RemoteData exposing (RemoteData(Loading, Success))
import Routing.Routes exposing (Route(Markets))
import Utilities as Util


get : Model -> ( Model, Cmd Msg )
get model =
    let
        route =
            case model.route of
                Markets markets ->
                    if Util.isNotSuccess markets then
                        Markets Loading
                    else
                        model.route

                _ ->
                    model.route

        storedData =
            model.storedData

        storedData_ =
            { storedData | markets = Loading }

        model_ =
            { model
                | route = route
                , storedData = storedData_
            }
    in
        ( model_, Market.getMarkets )


update : List Market -> Model -> ( Model, Cmd Msg )
update markets model =
    let
        storedData =
            model.storedData

        storedData_ =
            { storedData | markets = Success markets }

        model_ =
            { model | storedData = storedData_ }
    in
        case model.route of
            Markets _ ->
                ( { model_ | route = Markets <| Success markets }, Cmd.none )

            _ ->
                ( model_, Cmd.none )
