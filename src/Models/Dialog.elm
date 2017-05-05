module Models.Dialog exposing (DialogView(..), Msg(..))


type Msg
    = BrandUpdate String
    | BrandAdd String


type DialogView
    = Default
    | AddBrand String
