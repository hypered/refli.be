-- Run with e.g.:
--
--   nix-shell --run 'runghc -isrc/ -XNoImplicitPrelude withholding-tax/scales.hs worker-scale-1'

{-# LANGUAGE OverloadedStrings #-}
import Protolude
import Refli.Data.Scales
import System.Environment (getArgs)


--------------------------------------------------------------------------------
main :: IO ()
main = do
  args <- getArgs
  case args of
    ["worker-scale-1"] -> generatePublicodes workerScale1
    ["worker-scale-2"] -> generatePublicodes workerScale2
    ["worker-scale-3"] -> generatePublicodes workerScale3
    _ -> exitFailure


--------------------------------------------------------------------------------
generatePublicodes :: [(Double, Double)] -> IO ()
generatePublicodes = mapM_ (putStrLn . generatePublicode)

generatePublicode :: (Double, Double) -> Text
generatePublicode (a, b) =
  "      - montant: " <> show b <> " EUR\n" <>
  "        plafond: " <> show a <> " EUR"
