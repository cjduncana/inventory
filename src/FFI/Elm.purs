module FFI.Elm (App, createHandlers, startElm) where

import Control.Monad.Eff (Eff)
import Prelude (Unit)

foreign import data App :: Type

foreign import startElm :: forall eff. Eff eff App

foreign import createHandlers :: forall eff. App -> Eff eff Unit
