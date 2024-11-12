--StarterGui --> ScreenGui


-- Obtém os serviços necessários
local players = game:GetService('Players')
local uis = game:GetService('UserInputService')
local rs = game:GetService('ReplicatedStorage')

-- Obtém o jogador local e seu personagem
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Acessa a pasta de eventos no ReplicatedStorage
local events = rs:WaitForChild('Events')
-- Obtém o evento remoto "dash" para comunicar ao servidor
local event_dash = events:WaitForChild('dash')

-- Variáveis para controlar o dash e o debounce (anti-spam)
local Debounce, cooldown, dash, track = false, 0.5, 1, nil

-- Função que é chamada quando uma tecla é pressionada
uis.InputBegan:Connect(function(Key, GameProcessedEvent)
	-- Ignora a entrada se já estiver processada (se for no chat, por exemplo)
	if GameProcessedEvent then return end

	-- Verifica se a tecla pressionada é "Q" e se o debounce está desativado
	if Key.KeyCode == Enum.KeyCode.Q and not Debounce then
		-- Ativa o debounce para evitar múltiplos dashes ao mesmo tempo
		Debounce = true

		-- Para a animação anterior, se houver uma em execução
		if track ~= nil then
			track:Stop()
		end

		-- Procura o Humanoid do personagem
		local Humanoid = character:FindFirstChild('Humanoid')
		if Humanoid then
			-- Alterna entre duas animações de dash
			if dash == 1 then
				dash = 2  -- Muda para a animação "dash2"
				track = Humanoid.Animator:LoadAnimation(script:WaitForChild("dash"))
			else
				dash = 1  -- Muda para a animação "dash1"
				track = Humanoid.Animator:LoadAnimation(script:WaitForChild("dash2"))
			end

			-- Executa a animação de dash escolhida
			track:Play()
		end

		-- Envia um evento para o servidor indicando o dash e o cooldown
		event_dash:FireServer(cooldown)

		-- Espera o tempo do cooldown e então para a animação e reseta o debounce
		task.wait(cooldown)
		track:Stop()  -- Para a animação
		track = nil   -- Limpa a variável da animação
		Debounce = false  -- Reseta o debounce para permitir outro dash
	end
end)
