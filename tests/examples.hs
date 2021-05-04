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
-- It seems possible to enter cents using a comma, although the data are
-- displayed incorrectly.

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
    -- ^ monthly gross income, in eurocents
  }

data FgtbStatus = FgtbLaborer | FgtbEmployee

data FgtbWorkingRegime =
    FgtbFullTime
  | FgtbFullTimeIncomplete Int Int
    -- ^ paid days, working days in the month
  | FgtbPartTime Int Int
    -- ^ paid hours, hours of a full-time

data FgtbMaritalStatus = FgtbSingle | FgtbMarriedOneIncome | FgtbMarriedTwoIncome

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
      FgtbMarriedOneIncome -> "married-1"
      FgtbMarriedTwoIncome -> "married-2"
  , case fgtbWorkerIsDisabled of
      True -> "disabled"
      False -> "able-bodied"
  , show fgtbDependantChildren
  , show fgtbDisabledChildren
  , showEurocents fgtbGrossIncome

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
-- Some values are taken as special cases from the computation of the
-- special social security contribution, some others lie in between.
fgtbExamples :: [(FgtbInput, FgtbOutput)]
fgtbExamples =
  fgtbSingleEmployees ++
  fgtbOneIncomeEmployees ++
  fgtbTwoIncomeEmployees ++
  fgtbSingleEmployees45

fgtbSingleEmployees =
  [ ( FgtbInput "012021" FgtbEmployee FgtbFullTime FgtbSingle False 0 0  10000
    , FgtbOutput  1307  1307  10000      0    0    0  10000
    )
  , ( FgtbInput "012021" FgtbEmployee FgtbFullTime FgtbSingle False 0 0  90000
    , FgtbOutput 11763 11763  90000      0    0    0  90000
    )
  , ( FgtbInput "012021" FgtbEmployee FgtbFullTime FgtbSingle False 0 0 109510
    , FgtbOutput 14313 14313 109510    293  293    0 109510
    )
  , ( FgtbInput "012021" FgtbEmployee FgtbFullTime FgtbSingle False 0 0 180000
    , FgtbOutput 23526 17811 174285  19125 5903    0 161063
    )
  , ( FgtbInput "012021" FgtbEmployee FgtbFullTime FgtbSingle False 0 0 194538
    , FgtbOutput 25426 14622 183734  22977 4846    0 165603
    )
  , ( FgtbInput "012021" FgtbEmployee FgtbFullTime FgtbSingle False 0 0 200000
    , FgtbOutput 26140 13423 187283  24261 4448  415 167055
    )
  , ( FgtbInput "012021" FgtbEmployee FgtbFullTime FgtbSingle False 0 0 219018
    , FgtbOutput 28626  9251 199643  30039 3066 1860 170810
    )
  , ( FgtbInput "012021" FgtbEmployee FgtbFullTime FgtbSingle False 0 0 360000
    , FgtbOutput 47052     0 312948  83740    0 3411 225797
    )
  , ( FgtbInput "012021" FgtbEmployee FgtbFullTime FgtbSingle False 0 0 603882
    , FgtbOutput 78927     0 524955 192942    0 6094 325919
    )
  , ( FgtbInput "012021" FgtbEmployee FgtbFullTime FgtbSingle False 0 0 650000
    , FgtbOutput 84955     0 565045 214610    0 6094 344341
    )
  ]

-- Same as above, but married 1 income
fgtbOneIncomeEmployees =
  zipWith
    (\a b -> ((fst a) { fgtbMaritalStatus = FgtbMarriedOneIncome }, b))
    fgtbSingleEmployees
    [ FgtbOutput  1307  1307  10000      0    0    0  10000
    , FgtbOutput 11763 11763  90000      0    0    0  90000
    , FgtbOutput 14313 14313 109510      0    0    0 109510
    , FgtbOutput 23526 17811 174285    356  356    0 174285
    , FgtbOutput 25426 14622 183734   2764 2764    0 183734
    , FgtbOutput 26140 13423 187283   3566 3566  415 186868
    , FgtbOutput 28626  9251 199643   7397 3066 1860 193452
    , FgtbOutput 47052     0 312948  51331    0 3411 258206
    , FgtbOutput 78927     0 524955 153010    0 6094 365851
    , FgtbOutput 84955     0 565045 174677    0 6094 384274
    ]

-- Same as above, but married 2 income
fgtbTwoIncomeEmployees =
  zipWith
    (\a b -> ((fst a) { fgtbMaritalStatus = FgtbMarriedTwoIncome }, b))
    fgtbSingleEmployees
    [ FgtbOutput  1307  1307  10000      0    0    0  10000
    , FgtbOutput 11763 11763  90000      0    0    0  90000
    , FgtbOutput 14313 14313 109510   2893 2893    0 109510
    , FgtbOutput 23526 17811 174285  21725 5903  930 157533
    , FgtbOutput 25426 14622 183734  25577 4846  930 162073
    , FgtbOutput 26140 13423 187283  26861 4448  930 163940
    , FgtbOutput 28626  9251 199643  32639 3066 1860 168210
    , FgtbOutput 47052     0 312948  86340    0 3411 223197
    , FgtbOutput 78927     0 524955 195542    0 5164 324249
    , FgtbOutput 84955     0 565045 217210    0 5164 342671
    ]

-- Same as above, single, disabled
-- This is the same as substracting 37 EUR from fgtbWithholdingTax (capped at
-- 0) and thus adding the same amount to the net.
fgtbSingleDisabledEmployees =
  zipWith
    (\a b -> ((fst a) { fgtbWorkerIsDisabled = True }, b))
    fgtbSingleEmployees
    [ FgtbOutput  1307  1307  10000      0    0    0  10000
    , FgtbOutput 11763 11763  90000      0    0    0  90000
    , FgtbOutput 14313 14313 109510      0    0    0 109510
    , FgtbOutput 23526 17811 174285  15425 5903    0 164763
    , FgtbOutput 25426 14622 183734  19277 4846    0 169303
    , FgtbOutput 26140 13423 187283  20561 4448  415 170755
    , FgtbOutput 28626  9251 199643  26339 3066 1860 174510
    , FgtbOutput 47052     0 312948  80040    0 3411 229497
    , FgtbOutput 78927     0 524955 189242    0 6094 329619
    , FgtbOutput 84955     0 565045 210910    0 6094 348041
    ]

-- Same as above, but working 32 hours out of 40, or 4 days out of 5, or ...
-- As far as I understand, only the fraction matters, although the Group S site
-- seems to round somehow the entered time.
-- I should probably use adapted gross salaries.
--
-- Moreover, the FGTB site leave the fgtbSpecialContribution at zero but I
-- haven't seen anything that should force it at zero. So I include here the
-- value reported by the Group S site. Actually this is ok, maybe FGTB site
-- does this only for Incomplete Full-time, not Part-time.
fgtbSingleEmployees45 =
  zipWith
    (\a b -> ((fst a) { fgtbWorkingRegime = FgtbPartTime 32 40 }, b))
    fgtbSingleEmployees
    [ FgtbOutput  1307  1307  10000      0    0    0  10000
    , FgtbOutput 11763 11763  90000      0    0    0  90000
    , FgtbOutput 14313 14313 109510    293  293    0 109510
    , FgtbOutput 23526  6350 162824  13989 2104    0 150939
      --                6348 on Group S
    , FgtbOutput 25426  3163 172275  17841 1048    0 155482
      --                3160 on Group S
      --                             this n this make 16794 on Group S
    , FgtbOutput 26140  1962 175822  19767  650  415 156290
    , FgtbOutput 28626     0 190392  25545    0 1860 162987
    , FgtbOutput 47052     0 312948  83740    0 3411 225797
    , FgtbOutput 78927     0 524955 192942    0 6094 325919
      --                                        6093 on Group S
    , FgtbOutput 84955     0 565045 214610    0 6094 344341
    ]
    -- TODO The last three ones are unchanged.


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
