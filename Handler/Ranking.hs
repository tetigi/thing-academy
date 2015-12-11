module Handler.Ranking where
import Import

getRankingR :: Handler Html
getRankingR = do
    -- Get all entities from the db
    entities <- runDB $ selectList [] [Desc ComparisonElo]

    let scores = map (\(Entity _ e) -> (comparisonValue e, comparisonElo e)) entities

    -- Start laying out the webpage
    defaultLayout $ do
        -- Fill in the rest with ranking.hamlet
        $(widgetFile "ranking")
