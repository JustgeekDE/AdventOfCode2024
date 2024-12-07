import Data.List.Split (splitOn)
import Control.Monad (filterM)

data SingleEquation = SingleEquation 
    { result :: Int 
    , values :: [Int]
    }
    deriving (Show)

-- Parse a line from the file
parseLine :: String -> SingleEquation
parseLine line =
    let (keyPart:valuePart:_) = splitOn ": " line
        key = read keyPart :: Int
        values = map read (words valuePart)
    in SingleEquation key values

-- Read and parse the file
processFile :: FilePath -> IO [SingleEquation]
processFile filePath = do
    contents <- readFile filePath
    let linesList = lines contents
    let parsedData = map parseLine linesList
    return parsedData

-- combine two ints with "||"
combineInts :: Int -> Int -> Int
combineInts x y = read (show x ++ show y) :: Int

recursiveEvaluation :: [Int] -> IO [Int]
recursiveEvaluation [] = return []
recursiveEvaluation [x] = return [x]
recursiveEvaluation (x:xs) = do
    subValues <- recursiveEvaluation xs
    let result = concatMap (\value -> [x + value, x * value, combineInts value x]) subValues
    return result

-- Check if the result appears in the recursive evaluation
isValidCalibration :: SingleEquation -> IO Bool
isValidCalibration (SingleEquation { result = res, values = vals }) = do
    let reversedVals = reverse vals
    evaluatedValues <- recursiveEvaluation reversedVals
    return $ res `elem` evaluatedValues

checkCalibrations :: [SingleEquation] -> IO ()
checkCalibrations equations = do
    validEquations <- filterM isValidCalibration equations
    let totalResult = sum $ map result validEquations
    mapM_ printResult validEquations
    putStrLn $ "Total sum of valid results: " ++ show totalResult
  where
    printResult eq = do
        isValid <- isValidCalibration eq
        putStrLn $ "Equation: " ++ show eq ++ 
                   " -> Result appears: " ++ show isValid


main :: IO ()
main = do
    let filePath = "input"
    parsedData <- processFile filePath  
    checkCalibrations parsedData
