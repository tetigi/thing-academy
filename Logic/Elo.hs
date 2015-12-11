module Logic.Elo (
    Outcome (..),
    PlayerElo,
    getNewEloPair
) where

import Import

type PlayerElo = Int

data ExpectedScores = ExpectedScores Double Double
    deriving Show

data Outcome = PlayerOneWin | PlayerTwoWin
    deriving Show

-- | Calculate the expected outcome of a game
getExpectedScores :: PlayerElo -> PlayerElo -> ExpectedScores
getExpectedScores p1 p2 =
    ExpectedScores (1 / (1 + 10**((p2f - p1f)/400))) (1 / (1 + 10**((p1f - p2f)/400)))
    where   p1f = fromIntegral p1
            p2f = fromIntegral p2

-- | Given an ELO pair and an outcome, calculates the resulting ELO pair
getNewEloPair :: PlayerElo -> PlayerElo -> Outcome -> (PlayerElo, PlayerElo)
getNewEloPair p1e p2e PlayerOneWin = (floor $ p1f + 32*(1 - p1), floor $ p2f - 32*p2)
    where   p1f = fromIntegral p1e
            p2f = fromIntegral p2e
            ExpectedScores p1 p2 = getExpectedScores p1e p2e
getNewEloPair p1e p2e PlayerTwoWin = (floor $ p1f - 32*p1, floor $ p2f + 32*(1 - p2))
    where   p1f = fromIntegral p1e
            p2f = fromIntegral p2e
            ExpectedScores p1 p2 = getExpectedScores p1e p2e
