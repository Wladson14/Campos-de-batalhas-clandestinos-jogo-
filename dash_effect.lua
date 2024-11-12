--ServerScriptService

-- Obtém o serviço ReplicatedStorage para acessar eventos compartilhados entre cliente e servidor
local rs = game:GetService('ReplicatedStorage')

-- Acessa a pasta de eventos e o evento remoto "dash"
local events = rs:WaitForChild('Events')
local events_dash = events:WaitForChild('dash')

-- Conecta a função ao evento remoto "dash" para responder ao pedido de dash do cliente
events_dash.OnServerEvent:Connect(function(player, cooldown)
	-- Obtém o personagem do jogador
	local character = player.Character or player.CharacterAdded:Wait()

	-- Cria um BodyVelocity para impulsionar o personagem
	local BV = Instance.new('BodyVelocity', character.HumanoidRootPart)
	-- Define a força máxima do BodyVelocity nas direções X e Z para controlar o movimento
	BV.MaxForce = Vector3.new(100000, 200, 100000)
	-- Define a velocidade do impulso usando o vetor de direção do HumanoidRootPart do personagem
	BV.Velocity = character.HumanoidRootPart.CFrame.LookVector * 60  -- Multiplicador ajusta a força do dash

	-- Aguarda pelo tempo de cooldown para limitar a duração do dash
	task.wait(cooldown)
	-- Remove o BodyVelocity após o cooldown para interromper o movimento
	BV:Destroy()
end)
