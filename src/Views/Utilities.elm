module Views.Utilities exposing (emptyDiv, imageSrc, noWrap, onBlur, square)

import Html exposing (Attribute, Html)
import Html.Attributes as Attr
import Html.Events as Events
import Json.Decode as Decode
import Material.Options as Options
import Models.Good as Good exposing (ImageURI)


emptyDiv : Html msg
emptyDiv =
    Html.div [] []


imageSrc : ImageURI -> Attribute msg
imageSrc =
    Attr.src << Good.getImageURI


noWrap : Float -> List (Options.Property c m)
noWrap height =
    [ Options.css "height" <| toString height ++ "em"
    , Options.css "overflow-x" "hidden"
    , Options.css "white-space" "nowrap"
    , Options.css "text-overflow" "ellipsis"
    ]


onBlur : (String -> msg) -> Attribute msg
onBlur message =
    Decode.map message Events.targetValue
        |> Events.on "blur"


square : Int -> List (Options.Property c m)
square side =
    [ Options.css "max-height" <| toString side ++ "px"
    , Options.css "max-width" <| toString side ++ "px"
    ]
