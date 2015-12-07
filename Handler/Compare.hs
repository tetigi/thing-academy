module Handler.Compare where

import Import

getCompareR :: Handler Html
getCompareR = do
    defaultLayout $ do
        $(widgetFile "compare")
