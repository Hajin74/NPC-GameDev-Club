-----------------------------------------------------------------------------------------
--
-- counter.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- 랜덤함수
math.randomseed(os.time())

-- 라이브러리
local widget = require("widget")
local physics = require("physics")

-- 변수
money = 0

-- GUI
local background = {} -- 1:초등학교, 2:트럭
local leftUI = {} -- 1:체력, 2:얼굴, 3:금액표시창, 4:금액표시
local rightUI = {} -- 1:환경설정, 2:레시피토글, 3:화면전환
local gameUI = {} -- 1:저금통, 2:저금통금액표시, 3:탁상달력,
local orderUI = {} -- 1:주문말풍선, 2:주문글, 3:주문수락, 4:주문거절
local person = {} -- 초등학생1, 초등학생2, 초등학생3
local kimbap = {}

function scene:create( event )
	local sceneGroup = self.view

	background[1] = display.newImageRect("img/elementaryschool.png", 1250, 460)
	background[1].x, background[1].y = display.contentWidth/2, 290
	background[2] = display.newImageRect("img/truck.png", display.contentWidth, display.contentHeight)
	background[2].x, background[2].y = display.contentWidth/2, display.contentHeight/2

	leftUI[1] = display.newImageRect("img/hp.png", 300, 30)
	leftUI[1].x, leftUI[1].y = 220, 40
	leftUI[2] = display.newImageRect("img/mara.png", 60, 60)
	leftUI[2].x, leftUI[2].y = 50, 40
	leftUI[3] = display.newImageRect("img/money.png", 350, 60)
	leftUI[3].x, leftUI[3].y = 200, 100
	leftUI[4] = display.newText("0원", 180, 107, "굴림")
	leftUI[4].text = string.format("%d원", money)
	leftUI[4].size = 30
	leftUI[4]:setFillColor(0)

	rightUI[1] = display.newImageRect("img/setting.png", 70, 70)
	rightUI[1].x, rightUI[1].y = display.contentWidth - 50, 50
	rightUI[2] = display.newImageRect("img/recipe.png", 70, 70)
	rightUI[2].x, rightUI[2].y = display.contentWidth - 120, 50
	rightUI[3] = display.newImageRect("img/arrow.png", 70, 70)
	rightUI[3].x, rightUI[3].y = display.contentWidth - 190, 50

	gameUI[1] = display.newImageRect("img/bank.png", 160, 120)
	gameUI[1].x, gameUI[1].y = display.contentWidth - 130, display.contentHeight - 100
	gameUI[2] = display.newText("+1000원", display.contentWidth - 130, display.contentHeight - 165, "굴림")
	gameUI[2].size = 30
	gameUI[2]:setFillColor(0)
	gameUI[2].alpha = 0
	gameUI[3] = display.newImageRect("img/calendar.png", 130, 130)
	gameUI[3].x, gameUI[3].y = 130, display.contentHeight - 100

	orderUI[1] = display.newImageRect("img/bubble.png", 500, 250)
	orderUI[1].x, orderUI[1].y = 850, 250
	orderUI[2] = display.newText("마라선생님! \n꼬마김밥 주세요.", 850, 220, "굴림")
	orderUI[2].size = 30
	orderUI[2]:setFillColor(0)
	orderUI[3] = display.newImageRect("img/accept.png", 110, 50)
	orderUI[3].x, orderUI[3].y = 780, 300
	orderUI[4] = display.newImageRect("img/deny.png", 110, 45)
	orderUI[4].x, orderUI[4].y = 900, 301
	for i = 1, 4, 1 do orderUI[i].alpha = 0 end

	person[1] = display.newImageRect("img/person1.png", 175, 205)
	person[2] = display.newImageRect("img/person2.png", 175, 205)
	person[3] = display.newImageRect("img/person3.png", 175, 205)
	for i = 1, 3, 1 do 
		person[i].x, person[i].y = 500, 418
		person[i].alpha = 0 
	end

	kimbap[1] = display.newImageRect("img/kimbap1.png", 300, 100)
	kimbap[2] = display.newImageRect("img/kimbap2.png", 300, 100)
	for i = 1, 2, 1 do
		kimbap[i].x, kimbap[i].y = display.contentWidth/2, display.contentHeight - 100
		kimbap[i].alpha = 0
		kimbap[i].name = i
	end


	-- [[함수]]
	local function toCook() -- 조리화면으로 이동
		for i = 1, 2, 1 do kimbap[i].alpha = 0 end -- 조리화면으로 이동하면 카운터에 놓인 김밥은 사라짐
		composer.setVariable("money", money)
		composer.gotoScene("cook")
	end

	local function delAll() -- 주문 거절 시 모든게 사라졌다가 1.5초후에 다시 등장
		for i = 1, 4, 1 do orderUI[i].alpha = 0 end
		for i = 1, 3, 1 do person[i].alpha = 0 end
		timer.performWithDelay(1500, customer, 1)
	end

	function putKimbap(event) -- cook scene에서도 쓸 수 있게 local이 아닌 전역 함수
		kimbap[event.target.name].alpha = 1
	end

	function calcCook() -- cook.lua에서 이루어진 돈계산 모두 반영
		leftUI[4].text = string.format("%d원", money)
	end

	function calcKimbap(event)
		event.target.alpha = 0
		
		if event.target == kimbap[1] then
			print("1번김밥")
			money = money + 1500
			print(money)
			leftUI[4].text = string.format("%d원", money)
		end

		calcCounter()
	end

	local function order() -- 주문창, 주문내용, 수락/거절 버튼 뜸
		for i = 1, 4, 1 do orderUI[i].alpha = 1 end
	end

	local function denyOrder()
		delAll()
	end

	local function acceptOrder()
		for i = 3, 4, 1 do orderUI[i].alpha = 0 end
		toCook()
	end

	function customer()
		person[math.random(1,3)].alpha = 1
		order()
	end




	
	


	-- 초기화
	
	timer.performWithDelay(1000, customer, 1)

	-- 이벤트 등록
	rightUI[3]:addEventListener("tap", toCook)
	orderUI[4]:addEventListener("tap", denyOrder)
	orderUI[3]:addEventListener("tap", acceptOrder)
	for i = 1, 2, 1 do kimbap[i]:addEventListener("tap", calcKimbap) end
	for i = 1, 2, 1 do kimbap[i]:addEventListener("tap", delAll) end

	-- 장면 삽입
	for i = 1, 2, 1 do sceneGroup:insert(background[i]) end
	for i = 1, 3, 1 do sceneGroup:insert(gameUI[i]) end
	sceneGroup:insert(rightUI[3])
	for i = 1, 3, 1 do sceneGroup:insert(person[i]) end
	sceneGroup:insert(leftUI[3])
	sceneGroup:insert(leftUI[4])
	for i = 1, 2, 1 do sceneGroup:insert(kimbap[i]) end
	for i = 1, 4, 1 do sceneGroup:insert(orderUI[i]) end
end



function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
	elseif phase == "did" then
		-- e.g. start timers, begin animation, play audio, etc.
	end   
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then

	elseif phase == "did" then
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene