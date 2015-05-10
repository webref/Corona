local composer = require("composer");
local widget = require("widget");
local json = require("json");

local scene = composer.newScene(); -- создаём новую сцену

function scene:show(event)
	local sceneGroup = self.view;
	
	setting = loadSettings("settings.json"); -- загружаем параметры из файла
	
	if (setting) then
		weight				= setting.weight;
		height 				= setting.height;
		age					= setting.age;
		sex					= setting.sex;
		time					= setting.time;
		activity_index 	= setting.activity_index;
		activity_name	= setting.activity_name;
		activity_factor 	= setting.activity_factor;
	end
	
	
	-- Вес
	------------------------------------------------------------------

	-- создаём группу для ввода веса
	local weightGroup = display.newGroup(); 

	-- добавляем круг
	display.newCircle(weightGroup, display.contentCenterX, 74, 60):setFillColor(244/255);
		
	-- прямоугольник со скруглёнными уголками
	display.newRoundedRect(weightGroup, display.contentCenterX, 110, w, 100, 10):setFillColor(244/255);

	-- выводим текст
	display.newText(weightGroup, "Укажите вес в килограммах", display.contentCenterX, 90, native.systemFont, 24);

	-- выводим текущий вес
	local myWeight = display.newText({
		parent = weightGroup,
		text = weight,
		x = display.contentCenterX, y = 53,
		font = native.systemFont, 
		fontSize = 50,
	});

	-- меняем цвет текста
	myWeight:setFillColor(0/255, 131/255, 202/255);

	-- параметры слайдера
	local optionsSlider = {
		frames = {   
			{ x=0, y=0, width=15, height=45 },
			{ x=16, y=0, width=130, height=45 },
			{ x=332, y=0, width=15, height=45 },
			{ x=153, y=0, width=15, height=45 },        
			{ x=353, y=0, width=47, height=47 },
		},
		sheetContentWidth = 400,
		sheetContentHeight = 45
	}

	-- выводим слайдер для ввода веса
	weightSlider = widget.newSlider {
		sheet = graphics.newImageSheet("img/slider.png", optionsSlider),
		leftFrame = 1, middleFrame = 2, rightFrame = 3, fillFrame = 4, handleFrame = 5,
		frameWidth = 15, frameHeight = 45,
		handleWidth = 45, handleHeight = 45,
		-- координаты слайдера
		top = 110, left= 84,
		-- размеры слайдера
		width = 360, height=47,
		orientation = "horizontal",
		-- устанавливаем положение ползунка веса
		value = 100*(weight - weightMin)/(weightMax - weightMin),
		-- выводим вес при перемещении слайдера
		listener = function(event)
			--weight = weightMin + event.value; -- простой вариант
			-- универсальный вариант
			weight = math.round(weightMin + (weightMax - weightMin)*event.value/100);
			myWeight.text = weight; -- выводим новый текст
		end
	}

	weightGroup:insert(weightSlider); -- добавляем слайдер в группу weightGroup

	-- кнопка минус
	weightMinusButton = widget.newButton {
		shape = 'roundedRect',
		raidus = 5,
		width = 60, height = 60,
		left = 19, top = 90,
		fontSize = 40,
		fillColor = { default={ 150/255 }, over={ 76/255 } },
		labelColor = { default={ 0 }, over={ 1 } },
		label = "-",
		onPress =  function(event)
			if (weight > weightMin) then 
				weight = weight - 1;
				myWeight.text = weight;
				weightSlider:setValue(100*(weight - weightMin)/(weightMax - weightMin));
			end			
		end
	}
		
	-- кнопка плюс
	weightPlusButton = widget.newButton {
		shape = 'roundedRect',
		raidus = 5,
		width = 60, height = 60,
		left = 462, top = 90,
		fontSize = 40,
		fillColor = { default={ 150/255 }, over={ 76/255 } },
		labelColor = { default={ 0 }, over={ 1 } },
		label = "+",
		onPress =  function(event)
			if (weight < weightMax) then 
				weight = weight + 1;
				myWeight.text = weight;
				weightSlider:setValue(100*(weight - weightMin)/(weightMax - weightMin));
			end			
		end
	}

	-- добавляем кнопки в группу weightGroup
	weightGroup:insert(weightMinusButton);
	weightGroup:insert(weightPlusButton);
	
	
	-- Рост
	------------------------------------------------------------------
	
	local heightGroup = display.newGroup();
	display.newCircle(heightGroup, display.contentCenterX, 224, 60):setFillColor(244/255);
	display.newRoundedRect(heightGroup, display.contentCenterX, 260, w, 100, 10):setFillColor(244/255);
	display.newText(heightGroup, "Укажите рост в сантиметрах", display.contentCenterX, 240, native.systemFont, 24);

	myHeight = display.newText({
		parent = heightGroup,
		text = height,
		x = display.contentCenterX, y = 203,
		font = native.systemFont, 
		fontSize = 50,
	});
	myHeight:setFillColor(0/255, 131/255, 202/255)
	
	heightSlider = widget.newSlider {
		sheet = graphics.newImageSheet("img/slider.png", optionsSlider),
		leftFrame = 1, middleFrame = 2, rightFrame = 3, fillFrame = 4, handleFrame = 5,
		frameWidth = 15, frameHeight = 45,
		handleWidth = 45, handleHeight = 45,
		top = 260, left= 84,
		orientation = "horizontal",
		value = 100*(height - heightMin)/(heightMax - heightMin),
		width = 360, height=47,
		listener = 	function (event)
			height = math.round(heightMin + (heightMax - heightMin)*event.value/100);
			myHeight.text = height;
		end
	}
	
	heightMinusButton = widget.newButton {
		shape = 'roundedRect',
		raidus = 5,
		width = 60, height = 60,
		left = 19,
		top = 240,
		labelXOffset = 2,
		fontSize = 40,
		fillColor = { default={ 150/255 }, over={ 76/255 } },
		labelColor = { default={ 0 }, over={ 1 } },
		label = "-",
		onPress =  function(event)
			if (height > weightMin) then 
				height = height - 1;
				myHeight.text = height;
				heightSlider:setValue(100*(height - heightMin)/(heightMax - heightMin));
			end			
		end
	}
	
	heightPlusButton = widget.newButton {
		shape = 'roundedRect',
		raidus = 5,
		width = 60, height = 60,
		left = 462,
		top = 240,
		labelXOffset = 2,
		fontSize = 40,
		fillColor = { default={ 150/255 }, over={ 76/255 } },
		labelColor = { default={ 0 }, over={ 1 } },
		label = "+",
		onPress =  function(event)
			if (height < heightMax) then 
				height = height + 1;
				myHeight.text = height;
				heightSlider:setValue(100*(height - heightMin)/(heightMax - heightMin));
			end			
		end
	}

	heightGroup:insert(heightSlider);
	heightGroup:insert(heightMinusButton);
	heightGroup:insert(heightPlusButton); 
	
	
	-- Возраст
	------------------------------------------------------------------
	
	local ageGroup = display.newGroup(); -- Создаём группу
	display.newCircle(ageGroup, display.contentCenterX, 374, 60):setFillColor(244/255);
	display.newRoundedRect(ageGroup, display.contentCenterX, 410, w, 100, 10):setFillColor(244/255);
	display.newText(ageGroup, "Укажите возраст", display.contentCenterX, 390, native.systemFont, 24);

	myAge = display.newText({
		parent = ageGroup,
		text = age,
		x = display.contentCenterX, y = 353,
		font = native.systemFont, 
		fontSize = 50,
	});
	myAge:setFillColor(0/255, 131/255, 202/255)

	ageSlider = widget.newSlider {
		sheet = graphics.newImageSheet("img/slider.png", optionsSlider),
		leftFrame = 1, middleFrame = 2, rightFrame = 3, fillFrame = 4, handleFrame = 5,
		frameWidth = 15, frameHeight = 45,
		handleWidth = 45, handleHeight = 45,
		top = 410, left= 84,
		orientation = "horizontal",
		value = 100*(age - ageMin)/(ageMax - ageMin),
		width = 360, height=47,
		listener = 	function (event)
			age = math.round(ageMin + (ageMax - ageMin)*event.value/100);
			myAge.text = age;
		end
	}
	
	ageMinusButton = widget.newButton {
		shape = 'roundedRect',
		raidus = 5,
		width = 60, height = 60,
		left = 19,
		top = 390,
		labelXOffset = 2,
		fontSize = 40,
		fillColor = { default={ 150/255 }, over={ 76/255 } },
		labelColor = { default={ 0 }, over={ 1 } },
		label = "-",
		onPress =  function(event)
			if (age > ageMin) then 
				age = age - 1;
				myAge.text = age;
				ageSlider:setValue(100*(age - ageMin)/(ageMax - ageMin));
			end			
		end
	}
	
	agePlusButton = widget.newButton {
		shape = 'roundedRect',
		raidus = 5,
		width = 60, height = 60,
		left = 462,
		top = 390,
		labelXOffset = 2,
		fontSize = 40,
		fillColor = { default={ 150/255 }, over={ 76/255 } },
		labelColor = { default={ 0 }, over={ 1 } },
		label = "+",
		onPress =  function(event)
			if (age < ageMax) then 
				age = age + 1;
				myAge.text = age;
				ageSlider:setValue(100*(age - ageMin)/(ageMax - ageMin));
			end			
		end
	}

	ageGroup:insert(ageMinusButton);
	ageGroup:insert(agePlusButton); 
	ageGroup:insert(ageSlider);
	

	-- Время
	------------------------------------------------------------------
	
	local timeGroup = display.newGroup();
	display.newCircle(timeGroup, display.contentCenterX, 524, 60):setFillColor(244/255);
	display.newRoundedRect(timeGroup, display.contentCenterX, 560, w, 100, 10):setFillColor(244/255);
	display.newText(timeGroup, "Укажите время в минутах", display.contentCenterX, 540, native.systemFont, 24);	

	myTime = display.newText({
		parent = timeGroup,
		text = time,
		x = display.contentCenterX, y = 503,
		font = native.systemFont, 
		fontSize = 50,
	});
	myTime:setFillColor(0/255, 131/255, 202/255)

	timeSlider = widget.newSlider {
		sheet = graphics.newImageSheet("img/slider.png", optionsSlider),
		leftFrame = 1, middleFrame = 2, rightFrame = 3, fillFrame = 4, handleFrame = 5,
		frameWidth = 15, frameHeight = 45,
		handleWidth = 45, handleHeight = 45,
		top = 560, left= 84,
		orientation = "horizontal",
		value = 100*(time - timeMin)/(timeMax - timeMin), -- устанавливаем положение ползунка времени
		width = 360, height=47,
		-- Выводим время при перемещении слайдера
		listener = 	function (event)
			time = math.round(timeMin + (timeMax-timeMin)*event.value/100);
			myTime.text = time;
		end
	}
	
	timeMinusButton = widget.newButton {
		shape = 'roundedRect',
		raidus = 5,
		width = 60, height = 60,
		left = 19,
		top = 540,
		labelXOffset = 2,
		fontSize = 40,
		fillColor = { default={ 150/255 }, over={ 76/255 } },
		labelColor = { default={ 0 }, over={ 1 } },
		label = "-",
		onPress =  function(event)
			if (time > timeMin) then 
				time = time - 1;
				myTime.text = time;
				timeSlider:setValue(100*(time - timeMin)/(timeMax - timeMin));
			end			
		end
	}
	
	timePlusButton = widget.newButton {
		shape = 'roundedRect',
		raidus = 5,
		width = 60, height = 60,
		left = 462,
		top = 540,
		labelXOffset = 2,
		fontSize = 40,
		fillColor = { default={ 150/255 }, over={ 76/255 } },
		labelColor = { default={ 0 }, over={ 1 } },
		label = "+",
		onPress =  function(event)
			if (time < timeMax) then 
				time = time + 1;
				myTime.text = time;
				timeSlider:setValue(100*(time - timeMin)/(timeMax - timeMin));
			end			
		end
	}

	timeGroup:insert(timeMinusButton);
	timeGroup:insert(timePlusButton); 
	timeGroup:insert(timeSlider);
	
	
	-- Пол
	------------------------------------------------------------------

	-- создаём группу для указания пола пользователя
	local sexGroup = display.newGroup();
		
	display.newRoundedRect(sexGroup, display.contentCenterX, 680, w, 120, 10):setFillColor(244/255);
	display.newText(sexGroup, "Укажите пол", 105, 660, native.systemFont, 24);

	sexSelect = display.newText(sexGroup, sex, 105, 700, native.systemFont, 24);
	sexSelect:setFillColor(0.4);
		
	-- выбор пола - мужской
	maleOn = display.newImage(sexGroup, "img/male_select.png", 300, 680); -- выбран мужской пол
	maleOff = display.newImage(sexGroup, "img/male.png", 300, 680); -- мужской пол не выбран

	-- выбор пола - женский
	femaleOn = display.newImage(sexGroup, "img/female_select.png", 440, 680);
	femaleOff = display.newImage(sexGroup, "img/female.png", 440, 680);
		
	if (sex == "мужской") then
		maleOff.isVisible = false; -- скрываем от просмотра
		femaleOn.isVisible = false;
	else
		maleOn.isVisible = false; -- скрываем от просмотра
		femaleOff.isVisible = false;
	end
		
	-- Выбор мужского пола
	function selectMale(event)
		if (event.phase == "began") then
			sex = "мужской";
			sexSelect.text = sex;
			maleOn.isVisible = true;
			maleOff.isVisible = false;
			femaleOn.isVisible = false;
			femaleOff.isVisible = true;
		end
		return true
	end	

	-- Выбор женского пола
	function selectFemale(event)
		if (event.phase == "began") then
			sex = "женский";
			sexSelect.text = sex;
			femaleOn.isVisible = true;
			femaleOff.isVisible = false;
			maleOn.isVisible = false;
			maleOff.isVisible = true;
		end
		return true
	end

	-- добавляем обработчик нажатия
	maleOff:addEventListener("touch", selectMale);
	femaleOff:addEventListener("touch", selectFemale);
	

	-- Активность
	------------------------------------------------------------------
	
	activityGroup = display.newGroup();	
	display.newRoundedRect(activityGroup, display.contentCenterX, 790, w, 60, 10):setFillColor(244/255);
	display.newPolygon(activityGroup, 500, 790, {500, 452, 520, 452, 510, 466}):setFillColor(0.4);
	activityText = display.newText(activityGroup, activity_name, display.contentCenterX, 790, native.systemFont, 24);
	activityText:setFillColor(237/255, 103/255, 57/255);
	activityGroup:addEventListener("touch", 	function(event)
			composer.showOverlay("scenes.activity", {
				isModal = true,
				effect = "fade",
				time = 400,
			});
		end
	);
	
	
	-- Кнопка
	------------------------------------------------------------------	

	local buttonCalc = widget.newButton {
		shape = 'roundedRect', raidus = 5,
		width = w, height = '70',
		left = 10, top = 870,
		fillColor = { default={ 245/255, 77/255, 128/255 }, over={ 0, 149/255, 59/255 } },
		labelColor = { default={ 1 }, over={ 1 } },
		fontSize = 32,	label = "Считать калории",
		onPress = function(event)
			composer.showOverlay("scenes.result", {
				isModal = true,
				effect = "fade",
				time = 400,
			});
		end
	}
	
	-- Вставляем все объекты в sceneGroup
	------------------------------------------------------------------		
	sceneGroup:insert(weightGroup);
	sceneGroup:insert(heightGroup);
	sceneGroup:insert(ageGroup);
	sceneGroup:insert(sexGroup);
	sceneGroup:insert(timeGroup);
	sceneGroup:insert(activityGroup);
	sceneGroup:insert(buttonCalc);	
end

	-- Загружаем параметры из файла
	function loadSettings(filename)
		local path = system.pathForFile(filename, system.ResourceDirectory);
		local contents = "";
		local myTable = {};
		local file = io.open(path, "r");
		if file then
			 local contents = file:read( "*a" );
			 myTable = json.decode(contents);
			 io.close(file);
			 return myTable;
		end
		return nil
	end
		
scene:addEventListener("show", scene);
return scene;
