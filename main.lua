local composer = require("composer");

-- Переменные
------------------------------------------------------------------

weightMin	= 40;   	-- Минимальный вес
weightMax	= 140;  -- Максимальный вес
heightMin	= 100;  -- Минимальный рост
heightMax = 200;  -- Максимальный рост
ageMin		= 18;   	-- Минимальный возраст
ageMax    	= 98; 	-- Максимальный возраст
timeMin		= 1;		-- Минимальное время 
timeMax	= 120; 	-- Максимальное время 

-- значения по умолчанию
weight 	= weightMin; -- вес
height 	= heightMin; -- рост
age 		= ageMin; -- возраст
sex 		= "мужской"; -- пол
time		= timeMin; -- время
activity_name	= "Ходьба, 4 км/ч"; -- активность по умолчанию
activity_factor 	= 3; -- коэффициент активности
activity_index 	= 147;	-- номер в списке для перехода к нему

w = display.contentWidth - 20; -- ширина контента

-- Настройки цвета фона и текста
------------------------------------------------------------------

display.setDefault("background", 37/255, 39/255, 46/255); -- фон приложения
display.setDefault("fillColor", 0); -- цвет текста по умолчанию

-- Переходим к сцене calc
------------------------------------------------------------------

composer.gotoScene("scenes.calc");