local composer = require("composer");
local widget = require("widget");
local data = require("scenes.data"); -- вызов файла data.lua

local scene = composer.newScene();

function scene:create(event)
	local sceneGroup = self.view;
	
	-- полупрозрачный прямоугольник
	display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight):setFillColor(37/255, 39/255, 46/255, 0.7);
	
	-- отображаем список
	function onRowRender(event)
		local row = event.row;
		local id = row.index;
		-- выводим текст заданным шрифтом

		row.activityText = display.newText(data[id].name, 24, 24, native.systemFont, 22);
		row.activityText.anchorX = 0; -- задаём точку отсчёта координат
		if (data[id].category == 1) then 
			row.activityText:setFillColor(1); -- для заголовков цвет белый
			else row.activityText:setFillColor(0) -- для остального текста чёрный
		end
		row:insert(row.activityText);
		return true
	end
	
	-- нажатие на пункт списка
	function onRowTouch(event)
		local row = event.row
		if (event.phase == "release") then
			-- присваиваем переменным выбранные значения
			activity_index = row.index;
			activity_name = data[activity_index].name;
			activity_factor = data[activity_index].factor;
			activityText.text = activity_name;
			composer.hideOverlay("fade", 400); -- закрываем окно
		end
	end

	-- создаём список
	local activityList = widget.newTableView {
	   top = 70, left = 40, -- координаты
	   width = 460, height = 850, -- размеры
	   onRowRender = onRowRender,
	   onRowTouch = onRowTouch,
	}
	
	sceneGroup:insert(activityList); -- добавляем список в группу sceneGroup
	
	-- добавляем в список данные
	for i = 1, #data do
		if (data[i].category == 1) then isCategory = true;
			else isCategory = false;
		end
		if (isCategory == true) then
			rowColor = { default = {237/255, 103/255, 57/255} };
			else rowColor = { default = {1} }
		end
		activityList:insertRow{
			rowHeight = 50,
			isCategory = isCategory,
			rowColor = rowColor,
		}
	end
	
	-- прокручиваем список к выбранному ранее пункту
	if (activity_index > 1) then
		activityList:scrollToY({y=-(activity_index-2)*50});
	end
	
	-- кнопка закрытия списка
	close = display.newImage(sceneGroup, "img/close.png", 500, 76);	
	close:addEventListener("touch", function(event)
			if event.phase == 'ended' then
				composer.hideOverlay("fade", 400);
			end
		end
	);
	
end

scene:addEventListener("create", scene);

return scene;
