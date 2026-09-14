--Evalua cada sección del codigo y lo convierte en un Int
lecturaSec:: Int -> Int -> Int -> Int
lecturaSec n inicio digitos = read(take digitos(drop (inicio-1) (show n)))

--Deducir el periodo que fue matriculado
establecerPeriodo:: Int -> String
establecerPeriodo a =
    if a == 262
        then "2026-2 "
        else if a == 271
            then "2027-1 "
            else if a == 272
                then "2027-2 "
                else if a == 281
                    then "2028-1 "
                    else if a == 282
                        then "2028-2 "
                        else if a == 291
                            then "2029-1 "
                            else "2029-2 "


--Deducir la escuela a la que pertenece
listarDivisores:: Int -> [Int]
listarDivisores n = filter (\d -> n `mod` d == 0) [1 .. n-1]

sumaDivisores:: Int -> Int
sumaDivisores n = sum (listarDivisores n)

establecerEscuela:: Int -> String 
establecerEscuela x =
    if x == sumaDivisores x 
        then "Engineering "
        else if x > sumaDivisores x
            then "Humanities "
            else "Administrative "

--Definir par o impar
esPar:: Int -> String
esPar m = 
    if mod m 2 == 0
        then " even"
        else " odd"


--main
main :: IO()
main = do
    numeroIn <- getLine
    if length numeroIn /=8 
        then putStrLn "Código inválido: debe tener exactamente 8 dígitos"
        
        else do
            let codigo = read numeroIn:: Int
            let periodoA = lecturaSec codigo 1 3
            let categoria = lecturaSec codigo 4 2
            let nAdmision = lecturaSec codigo 7 3
    
            let fecha = establecerPeriodo periodoA
            let escuela = establecerEscuela categoria
            let numero = "num" ++ show nAdmision ++ esPar nAdmision
    
            putStrLn (fecha ++ escuela ++ numero)
    
    