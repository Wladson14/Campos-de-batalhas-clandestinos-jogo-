-- Obtém o serviço "ContextActionService" para gerenciar ações do jogador
local cas = game:GetService("ContextActionService")
-- Obtém o serviço "ReplicatedStorage" para acessar objetos que são compartilhados entre o cliente e o servidor
local rs = game:GetService("ReplicatedStorage")

-- Acessa a pasta "Events" dentro do "ReplicatedStorage"
local events = rs:WaitForChild("Events")
-- Obtém o evento remoto "Hitbox" que será usado para detectar hits
local hitboxevent = events:WaitForChild("Hitbox")

-- Obtém o jogador local e seu personagem
local plr = game.Players.LocalPlayer
local character = plr.Character or plr.CharacterAdded:Wait()
-- Obtém o humanoide do personagem
local hum = character:WaitForChild("Humanoid")
-- Acessa o "Animator" do humanoide para carregar animações
local animator = hum:WaitForChild("Animator")

-- Carrega as animações de socos e ataques
local leftPunch = animator:LoadAnimation(script:WaitForChild("soco1"))
local rightPunch = animator:LoadAnimation(script:WaitForChild("soco2"))
local atk3 = animator:LoadAnimation(script:WaitForChild("atk3"))
local atk4 = animator:LoadAnimation(script:WaitForChild("atk4"))

-- Variável para controlar o estado de um ataque específico (UpperCut)
local isuc = false

-- Variáveis para controlar a sequência de socos
local currentPunch = 0  -- Guarda o soco atual da sequência
local lastPunch = 0     -- Guarda o último tempo em que o soco foi dado
local debounce = false  -- Controla se o soco pode ser dado, evitando múltiplos socos simultâneos

-- Função que executa o soco
local function punch(actionName, inputState, inputObject)
	-- Verifica se o debounce está ativo, impedindo que outro soco seja dado
	if debounce then return end

	-- Se o último soco foi dado há mais de 1.5 segundos, reinicia a sequência para o primeiro soco
	if tick() - lastPunch > 1.5 then
		currentPunch = 1
	end

	-- Define o debounce como verdadeiro para evitar múltiplos socos ao mesmo tempo
	debounce = true

	-- Sequência de socos
	if currentPunch == 1 then
		leftPunch:Play()  -- Executa a animação do soco esquerdo
		hitboxevent:FireServer(Vector3.new(3,3,3), Vector3.new(2), 10, 0.3)  -- Dispara o evento "Hitbox" para tratar o hit
		task.wait(0.4)  -- Espera antes de permitir o próximo soco
		debounce = false

	elseif currentPunch == 2 then
		rightPunch:Play()  -- Executa a animação do soco direito
		hitboxevent:FireServer(Vector3.new(3,3,3), Vector3.new(2), 10, 0.3)
		task.wait(0.8)
		debounce = false

	elseif currentPunch == 3 then
		atk3:Play()  -- Executa a terceira animação de ataque
		hitboxevent:FireServer(Vector3.new(3,3,3), Vector3.new(2), 10, 0.3)
		task.wait(0.8)
		debounce = false

	elseif currentPunch == 4 then
		atk4:Play()  -- Executa a quarta animação de ataque
		hitboxevent:FireServer(Vector3.new(3,3,3), Vector3.new(2), 10, 0.3)
		task.wait(0.8)
		debounce = false
	end

	print(currentPunch)  -- Exibe o número do soco atual para debug

	-- Se o soco atual foi o quarto, reinicia a sequência para o primeiro soco
	if currentPunch == 4 then
		currentPunch = 1
	else
		currentPunch += 1  -- Caso contrário, incrementa para o próximo soco
	end

	lastPunch = tick()  -- Atualiza o tempo do último soco
end

-- Vincula a função "punch" ao botão esquerdo do mouse (MouseButton1)
cas:BindAction("Punch", punch, true, Enum.UserInputType.MouseButton1)
