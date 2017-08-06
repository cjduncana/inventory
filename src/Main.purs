module Main (main) where

import Control.Monad.Eff (Eff)
import FFI.Elm as Elm
import Prelude

main :: forall eff. Eff eff Unit
main = do
  app <- Elm.startElm
  Elm.createHandlers app
