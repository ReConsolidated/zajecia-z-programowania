-- Configuration (pobieranie z edytora)
local part = script.Parent -- Part, który chcemy przesunąć

-- Ustawienie 'Anchored' na true, aby zapobiec spadaniu
part.Anchored = true

-- Dodajemy te wartości jako obiekty `Vector3Value` w hierarchii skryptu
local changeX = script:WaitForChild("ChangeX").Value -- Zmiana na osi X
local changeZ = script:WaitForChild("ChangeZ").Value -- Zmiana na osi Z
local moveTime = script:WaitForChild("MoveTime").Value -- Zmiana na osi Z

-- Obliczamy punkt A (startowy) i B (końcowy) na podstawie zmian
local pointA = part.Position -- Początkowa pozycja
local pointB = Vector3.new(part.Position.X + changeX, part.Position.Y, part.Position.Z + changeZ) -- Nowa pozycja po zmianach

-- Funkcja do płynnego przesuwania obiektu między dwoma punktami
local function movePart()

	while true do
		-- Losowe opóźnienie przed rozpoczęciem ruchu
		

		-- Teleportacja na punkt A, zachowując wysokość
		part.Position = Vector3.new(pointA.X, part.Position.Y, pointA.Z)

		-- Przemieszczanie się od A do B
		local startTime = tick() -- Czas rozpoczęcia ruchu
		while tick() - startTime < moveTime do
			local t = (tick() - startTime) / moveTime -- Proporcja czasu
			-- Manualne obliczanie pozycji w każdym kroku, zachowując wysokość
			part.Position = Vector3.new(
				pointA.X + (pointB.X - pointA.X) * t,
				part.Position.Y, -- Zachowanie wysokości
				pointA.Z + (pointB.Z - pointA.Z) * t
			)
			wait(0.03) -- Czas oczekiwania, aby nie obciążać procesora
		end

		-- Przemieszczanie się od B do A
		startTime = tick() -- Czas rozpoczęcia ruchu
		while tick() - startTime < moveTime do
			local t = (tick() - startTime) / moveTime -- Proporcja czasu
			-- Manualne obliczanie pozycji w każdym kroku, zachowując wysokość
			part.Position = Vector3.new(
				pointB.X + (pointA.X - pointB.X) * t,
				part.Position.Y, -- Zachowanie wysokości
				pointB.Z + (pointA.Z - pointB.Z) * t
			)
			wait(0.03) -- Czas oczekiwania, aby nie obciążać procesora
		end
	end
end

local randomDelay = math.random() * moveTime * 3 -- Losowe opóźnienie w zakresie (0, moveTime)
wait(randomDelay) -- Czekanie na losowe opóźnienie przed rozpoczęciem ruchu

-- Uruchomienie funkcji ruchu
movePart()
