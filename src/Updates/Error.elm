module Updates.Error exposing (..)

import Model exposing (Action(..), ActionType(..), Model, Msg)
import Models.Brand as Brand
import Models.Error exposing (Error(..))
import Models.Market as Market
import RemoteData
import Routing.Routes as Routes


update : Error -> Model -> ( Model, Cmd Msg )
update error model =
    let
        model_ =
            { model | error = Just error }
    in
        case model.lastAction of
            None ->
                ( model_, Cmd.none )

            BrandAction action ->
                case action of
                    List ->
                        let
                            brandError _ =
                                RemoteData.Failure error

                            route =
                                Routes.mapBrands brandError model.route

                            model__ =
                                { model_
                                    | route = route
                                    , lastAction = None
                                }
                        in
                            ( model__, Cmd.none )

                    _ ->
                        ( model_, Cmd.none )

            MarketAction action ->
                case action of
                    List ->
                        let
                            marketError _ =
                                RemoteData.Failure error

                            route =
                                Routes.mapMarkets marketError model.route

                            model__ =
                                { model_
                                    | route = route
                                    , lastAction = None
                                }
                        in
                            ( model__, Cmd.none )

                    _ ->
                        ( model_, Cmd.none )
