-- This is a set of example inputs together with their results.
-- They are collected by manually using some online simulations.

{-# LANGUAGE RecordWildCards #-}


--------------------------------------------------------------------------------
main :: IO ()
main = do
  putStrLn "FGTB examples"
  mapM_ (putStrLn . showFgtb) fgtbExamples
  putStrLn ""
  putStrLn "SD Worx examples"
  mapM_ (putStrLn . showSd) sdExamples


--------------------------------------------------------------------------------
-- FGTB: https://www.fgtb.be/calcul-salaire-brut-net
-- The computation is done for a specific month of a specific year, but in
-- practice it seems to only work with 2021.

data FgtbInput = FgtbInput
  { fgtbInputMonth :: String
  , fgtbStatus :: FgtbStatus
  , fgtbWorkingRegime :: FgtbWorkingRegime
  , fgtbMaritalStatus :: FgtbMaritalStatus
  , fgtbWorkerIsDisabled :: Bool
  , fgtbDependantChildren :: Int
    -- ^ include the disabled children below
  , fgtbDisabledChildren :: Int
  , fgtbGrossIncome :: Int
    -- ^ monthly gross income, in EUR
  }

data FgtbStatus = FgtbLaborer | FgtbEmployee

data FgtbWorkingRegime =
    FgtbFullTime
  | FgtbFullTimeIncomplete Int Int
    -- ^ paid days, working days in the month
  | FgtbPartTime Int Int
    -- ^ paid hours, hours of a full-time

data FgtbMaritalStatus = FgtbSingle | FgtbMariedOneIncome | FgtbMariedTwoIncome

data FgtbOutput = FgtbOutput
  { fgtbPersonnalSocialContribution :: Int
    -- ^ in eurocents
  , fgtbWorkBonus :: Int
    -- ^ employment bonus for low wages
  , fgtbTaxableGrossIncome :: Int
  , fgtbWithholdingTax :: Int
  , fgtbWithholdingTaxReduction :: Int
    -- ^ reduction of the withholding tax for low wages
  , fgtbSpecialContribution :: Int
    -- ^ specitial contribution for the social security
  , fgtbNetRevenue :: Int
  }


--------------------------------------------------------------------------------
showFgtb (FgtbInput{..}, FgtbOutput{..}) = unwords
  [
  -- input

    fgtbInputMonth
  , case fgtbStatus of
      FgtbLaborer -> "laborer"
      FgtbEmployee -> "employee"
  , case fgtbWorkingRegime of
      FgtbFullTime -> "full-time"
      FgtbFullTimeIncomplete actual full ->
        show actual ++ "days/" ++ show full
      FgtbPartTime actual full ->
        show actual ++ "hours/" ++ show full
  , case fgtbMaritalStatus of
      FgtbSingle -> "single"
      FgtbMariedOneIncome -> "married-1"
      FgtbMariedTwoIncome -> "married-2"
  , case fgtbWorkerIsDisabled of
      True -> "disabled"
      False -> "able-bodied"
  , show fgtbDependantChildren
  , show fgtbDisabledChildren
  , showEurocents (fgtbGrossIncome * 100)

  -- output

  , showEurocents fgtbPersonnalSocialContribution
  , showEurocents fgtbWorkBonus
  , showEurocents fgtbTaxableGrossIncome
  , showEurocents fgtbWithholdingTax
  , showEurocents fgtbWithholdingTaxReduction
  , showEurocents fgtbSpecialContribution
  , showEurocents fgtbNetRevenue
  ]

showEurocents x = show (x `div` 100) ++ "." ++ (pad 2 . show) (x `mod` 100)

pad n s = replicate (n - length s) '0' ++ s


--------------------------------------------------------------------------------
fgtbExamples :: [(FgtbInput, FgtbOutput)]
fgtbExamples =
  [ ( FgtbInput "012021" FgtbEmployee FgtbFullTime FgtbSingle False 0 0 100
    , FgtbOutput 1307 1307 10000 0 0 0 10000
    )
  ]


--------------------------------------------------------------------------------
showSd (SdInput{..}, SdOutput{..}) = unwords
  [
  -- input

    case sdMaritalStatus of
      SdUnmarried -> "unmarried"
      SdMarried -> "married"
      SdWidower -> "widower"
      SdLegallyDivorced -> "legally-divorced"
      SdSeparated -> "separated"
      SdCohabiting -> "cohabiting"
      SdLegallyCohabiting -> "legally-cohabiting"
  , case sdStatute of
      SdBlueCollar -> "blue-collar"
      SdWhiteCollar -> "white-collar"
  , show sdHoursPerWeek
  , case sdRegime of
      SdFullTime -> "full-time"
      SdPartTime -> "part-time"
      SdPartTimeLT2h -> "less-than-2h"
      SdPartTimeLT3h -> "less-than-3h"
      SdPartTimeUnknown -> "part-time-unknown"
  , showEurocents sdGrossMonthlySalary

  -- output

  , showEurocents sdNsso
  , showEurocents sdAdvanceLevy
  , showEurocents sdSpecialSocialSecurityContribution
  , showEurocents sdNet
  ]


--------------------------------------------------------------------------------
-- SD Worx: http://www.sd.be/loonsimulator/public/?lang=EN
-- The form is richer than the FGTB one. It seems "hours per week" must
-- necessarily be filled, even when "Full-time" is selected.

data SdInput = SdInput
  { sdMaritalStatus :: SdMaritalStatus
  , sdStatute :: SdStatute
  , sdHoursPerWeek :: Int
  , sdRegime :: SdRegime
  , sdGrossMonthlySalary :: Int -- ^ in eurocents
  }

data SdMaritalStatus =
    SdUnmarried | SdMarried
  | SdWidower | SdLegallyDivorced | SdSeparated
  | SdCohabiting | SdLegallyCohabiting

data SdStatute = SdBlueCollar | SdWhiteCollar

data SdRegime =
    SdFullTime
  | SdPartTime | SdPartTimeLT2h | SdPartTimeLT3h | SdPartTimeUnknown

data SdOutput = SdOutput
  { sdNsso :: Int
  , sdAdvanceLevy :: Int
  , sdSpecialSocialSecurityContribution :: Int
  , sdNet :: Int
  }


--------------------------------------------------------------------------------
sdExamples :: [(SdInput, SdOutput)]
sdExamples =
  [ ( SdInput SdUnmarried SdWhiteCollar 40 SdFullTime 10000
    , SdOutput 0 0 0 10000
    )
  ]
