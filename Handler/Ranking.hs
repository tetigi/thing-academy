module Handler.Ranking where
import Import

import Data.Text (toTitle)
import Data.Text.Read (decimal)

getRankingR :: Handler Html
getRankingR = do
    conf <- liftIO $ getAppSettings
    let noun    = appNoun conf

    -- Look for explicit amount of ranks to show - default is 10
    limitStr <- lookupGetParam "limit"
    let limit = case limitStr of
            Just s  -> case decimal s of
                Right (x, _)    -> x
                Left _          -> 10
            Nothing -> 10

    -- Look for a page num - default is 1
    pageNumStr <- lookupGetParam "page"
    let pageNum = case pageNumStr of
            Just s  -> case decimal s of
                Right (x, _)    -> x
                Left _          -> 1
            Nothing -> 1

    -- Get all entities from the db
    entities <- runDB $ selectList [] [Desc ComparisonElo]

    let pages = [1.. ((limit - 1) + length entities) `div` limit]
    let scores =
            drop ((pageNum - 1) * limit) $
            map (\(Entity _ e) -> (comparisonValue e, comparisonElo e)) $
            take (limit * pageNum) entities

    -- Start laying out the webpage
    defaultLayout $ do
        -- Fill in the rest with ranking.hamlet
        $(widgetFile "ranking")
