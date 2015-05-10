local composer = require("composer");
local widget = require("widget");
local json = require("json");

local scene = composer.newScene();
	
function scene:create(event)
	local sceneGroup = self.view;
	
	display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight):setFillColor(37/255, 39/255, 46/255, 0.7);
	display.newRoundedRect(sceneGroup, display.contentCenterX, 490, 460, 620, 10):setFillColor(244/255);

	local okButton = widget.newButton {
		shape = 'roundedRect',
		radius = 5,
		width = 440,	height = 70,
		left = 50, top = 720,
		fillColor = { default={ 0.2 }, over={ 0, 149/255, 59/255 } },
		labelColor = { default={ 1 }, over={ 1 } },
		fontSize = 32,
		label = "OK",
		onPress = function(event)
			composer.hideOverlay("fade", 400);
		end
	}
	sceneGroup:insert(okButton);
	
	
	-- Считаем калории
	------------------------------------------------------------------
	function calculate()
		local bmr;
		if (sex == "мужской") then
			bmr = (10*weight + 6.25*height - 5*age + 5); -- требуемое количество калорий в сутки для мужчин
		elseif (sex == "женский") then
			bmr = (10*weight + 6.25*height - 5*age - 161); -- требуемое количество калорий в сутки для женщин
		end
		v = bmr*activity_factor/24; -- считаем потраченные калории за час
		res = math.round(v*time/60); -- потраченное количество калорий
		return res;
	end

	
	-- Выводим результаты
	------------------------------------------------------------------

	display.newText(sceneGroup, "Результаты", display.contentCenterX, 230, native.systemFont, 36);
	display.newImage(sceneGroup, "img/burn.png", 105, 230);
	cal = calculate(); 
	display.newText({
		parent=sceneGroup, 
		text=activity_name, 
		x = display.contentCenterX, y = 360, 
		width = 420, 
		fontSize = 30, 
		align="center"
	});
	display.newText(sceneGroup, "Время", display.contentCenterX, 430, native.systemFont, 24);
	display.newText(sceneGroup, time.." мин.", display.contentCenterX, 470, native.systemFont, 32);
	display.newText(sceneGroup, "Сожгли калорий", display.contentCenterX, 530, native.systemFont, 24);
	display.newText(sceneGroup, cal, display.contentCenterX, 580, native.systemFont, 52):setFillColor(0, 165/255, 80/255);

	-- Сохраняем параметры в файл
	function saveSettings(t, filename)
		local path = system.pathForFile(filename, system.ResourceDirectory);
		local file = io.open(path, "w");
		if (file) then
			local contents = json.encode(t);
			file:write(contents);
			io.close(file);
			return true
		else
			return false
		end
	end


	-- Сохраняем параметры
	------------------------------------------------------------------
	
	settings = {};
	settings.weight = weight;
	settings.height = height;
	settings.age = age;
	settings.sex = sex;
	settings.time = time;
	settings.activity_index = activity_index;
	settings.activity_name = activity_name;
	settings.activity_factor = activity_factor;
	saveSettings(settings, "settings.json");
end

scene:addEventListener("create", scene);
return scene;
	