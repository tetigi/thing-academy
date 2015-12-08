module Handler.Compare where

import Import

data This = This
    deriving Show

getCompareR :: Handler Html
getCompareR = do
    thisValue <- lookupGetParam "this"
    thatValue <- lookupGetParam "that"
    defaultLayout $ do
        setTitle $ case (thisValue, thatValue) of
            (Just this, Just that)  -> "OH GOD"
            _                       -> "Welcome to X-compare"
        thisButton <- newIdent
        $(widgetFile "compare")
