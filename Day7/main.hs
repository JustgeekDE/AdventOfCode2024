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

-- Recursive evaluation with logging
recursiveEvaluationWithLogging :: [Int] -> IO [Int]
recursiveEvaluationWithLogging [] = return []
recursiveEvaluationWithLogging [x] = return [x]
recursiveEvaluationWithLogging (x:xs) = do
    subValues <- recursiveEvaluationWithLogging xs
    let result = concatMap (\value -> [x + value, x * value]) subValues
    -- Print the intermediate results here
    putStrLn $ "Evaluating: " ++ show x ++ " with subValues: " ++ show subValues
    putStrLn $ "Resulting values: " ++ show result
    return result

-- Check if the result appears in the recursive evaluation
isValidCalibration :: SingleEquation -> IO Bool
isValidCalibration (SingleEquation { result = res, values = vals }) = do
    let reversedVals = reverse vals
    evaluatedValues <- recursiveEvaluationWithLogging reversedVals
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
    let filePath = "example.txt"
    parsedData <- processFile filePath  
    checkCalibrations parsedData
