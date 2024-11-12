--ServerScriptService

-- Obtém o serviço ReplicatedStorage para acessar objetos compartilhados entre o cliente e o servidor
local rs = game:GetService('ReplicatedStorage')

-- Acessa a pasta de eventos e o evento remoto "Hitbox" no ReplicatedStorage
local events = rs:WaitForChild('Events')
local hitboxEvent = events:WaitForChild('Hitbox')

-- Função para criar uma nova hitbox
function newhitbox(character, size, offset, damage, linger)
	-- Procura a parte "HumanoidRootPart" do personagem (ponto de referência central)
	local hrp = character:FindFirstChild('HumanoidRootPart')
	if hrp == nil then return end  -- Se não encontrar o HRP, encerra a função

	-- Cria uma "WeldConstraint" para fixar a hitbox ao HRP
	local weld = Instance.new('WeldConstraint', hrp)
	local hitbox = Instance.new('Part')  -- Cria uma nova peça para representar a hitbox
	weld.Part0 = hrp
	weld.Part1 = hitbox  -- Liga a hitbox ao HRP

	-- Configurações visuais e físicas da hitbox
	hitbox.Transparency = 1  -- Torna a hitbox invisível
	hitbox.CanCollide = false  -- Desativa a colisão para evitar interação física com objetos
	hitbox.CanQuery = false  -- Desativa a consulta de colisão para otimizar o desempenho
	hitbox.Massless = true  -- Define como sem massa para não afetar a física do personagem

	-- Define o tamanho e a posição da hitbox com base no HRP e nos parâmetros fornecidos
	hitbox.Size = size
	hitbox.CFrame = hrp.CFrame + hrp.CFrame.LookVector * offset.X + Vector3.new(0, offset.Y)
	hitbox.Parent = character  -- Coloca a hitbox no personagem

	-- Conecta um evento ao toque da hitbox para causar dano a personagens inimigos
	hitbox.Touched:Connect(function(hit)
		-- Verifica se o objeto tocado possui um humanoide, para identificar personagens
		if hit.Parent:FindFirstChild('Humanoid') == nil then return end

		-- Verifica se o personagem já foi atingido para evitar múltiplos danos
		for _, v in pairs(hitbox:GetChildren()) do 
			if v:IsA('ObjectValue') and v.Value == hit.Parent then return end
		end

		-- Registra o personagem atingido criando um "ObjectValue" na hitbox
		local hitcounter = Instance.new('ObjectValue', hitbox)
		hitcounter.Value = hit.Parent

		-- Causa dano ao personagem atingido
		hit.Parent.Humanoid:TakeDamage(damage)
	end)

	-- Adiciona a hitbox ao "Debris" para removê-la após o tempo especificado
	game.Debris:AddItem(hitbox, linger)
end

-- Conecta a função "newhitbox" ao evento remoto para responder a pedidos do cliente
hitboxEvent.OnServerEvent:Connect(function(plr, size, offset, damage, linger)
	newhitbox(plr.Character, size, offset, damage, linger)
end)
