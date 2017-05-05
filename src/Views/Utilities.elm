module Views.Utilities exposing (..)

import Html exposing (Html)


defaultEmptyDiv : Maybe (Html msg) -> Html msg
defaultEmptyDiv =
    Maybe.withDefault emptyDiv


emptyDiv : Html msg
emptyDiv =
    Html.div [] []
