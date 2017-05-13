module Models.Snackbar
    exposing
        ( Model
        , Msg
        , Payload
            ( NoPayload
            , DeletedBrand
            , DeletedGood
            , DeletedMarket
            )
        , init
        )

import Material.Snackbar as Snackbar
import Models.Brand exposing (Brand)
import Models.Good exposing (Good)
import Models.Market exposing (Market)


type Payload
    = NoPayload
    | DeletedBrand Brand
    | DeletedGood Good
    | DeletedMarket Market


type alias Msg =
    Snackbar.Msg Payload


type alias Model =
    Snackbar.Model Payload


init : Model
init =
    Snackbar.model
