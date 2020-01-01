cesarUnit :: (Int -> Int -> Int) -> Int -> Char -> Char
cesarUnit op x y | not (isAlpha y) = y
                 | isLower y       = toEnum (((fromEnum y - fromEnum 'a') `op`  x) `mod` 26 + fromEnum 'a')
                 | isUpper y       = toEnum (((fromEnum y - fromEnum 'A') `op`  x) `mod` 26 + fromEnum 'A')

cesarCod :: Int -> String -> String
cesarCod x = map (cesarUnit (+) x)

cesarDes :: Int -> String -> String
cesarDes x = map (cesarUnit (-) x)

atbash :: String -> String
atbash [] = []
atbash (x:y) | not (isAlpha x) = x:(atbash y)
             | isLower x = (cba !! (fromEnum x - fromEnum 'a')) : (atbash y)
             | isUpper x = (cBA !! (fromEnum x - fromEnum 'A')) : (atbash y)
             where cba = reverse ['a'..'z']
                   cBA = reverse ['A'..'Z']

vigenereCod :: String -> String -> String
vigenereCod [] _      = []
vigenereCod xs []     = xs
vigenereCod xs y      = map (vigenereUnit (+)) (zip ns xs)
                      where ns  = vigenereWord xs (y)

vigenereWord :: String -> String -> String
vigenereWord [] _                 = []
vigenereWord (x:xs) y | isAlpha x = head lis : (vigenereWord xs (drop 1 lis))
                      | otherwise = x : (vigenereWord xs lis)
                      where lis   = cycle y

vigenereUnit :: (Int -> Int->Int) -> (Char,  Char) -> Char
vigenereUnit op (x, y) | not (isAlpha x) = x
                    | isUpper x = cesarUnit op (fromEnum  x - fromEnum  'A') y
                    | otherwise = cesarUnit op (fromEnum  x - fromEnum  'a') y

vigenereDes :: String -> String -> String
vigenereDes [] _      = []
vigenereDes xs []     = xs
vigenereDes xs y      = map (vigenereUnit (-)) (zip ns xs)
                      where ns  = vigenereWord xs (y)

isAlpha :: Char -> Bool
isAlpha x = (x >= 'A' && x <= 'Z') || (x >= 'a' && x <= 'z')

isUpper :: Char -> Bool
isUpper x = x >= 'A' && x <= 'Z'

isLower :: Char -> Bool
isLower x = x >= 'a' && x <= 'z'