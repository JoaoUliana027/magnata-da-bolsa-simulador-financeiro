-- ============================================================================
-- 1. SERVIÇOS DO ROBLOX & CONFIGURAÇÕES GLOBAIS
-- ============================================================================
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")

local SEPARADOR_DECIMAL = ","
local INTERVALO_AUTOSAVE = 120        -- Segundos entre salvamentos automáticos
local TENTATIVAS_DATASTORE = 3        -- Tentativas de pcall para o DataStore
local INTERVALO_BENS_SEGUNDOS = 5     -- 5 segundos para rentabilidade dos Bens
local INTERVALO_FIIS_SEGUNDOS = 1     -- 1 segundo para o pagamento dos FIIs
local DEV_USER_ID = 1324151081        -- UserId autorizado para o Painel de Dev

-- ============================================================================
-- 2. TABELAS DE DADOS DO JOGO (ATIVOS, BENS, CORRETORAS E NOTÍCIAS)
-- ============================================================================
local SUFIXOS = {
	"", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc",
	"Un", "Duo", "Tre", "Qua", "Qui", "SE", "SP", "OC", "NV", "VIG",
	"CE", "TRV", "QTU", "SPZ"
}

local marketAssets = {
	-- Fundos Imobiliários (FIIs)
	{Nome = "FII Imobiliário FIIX", PrecoBase = 2.00,  Preco = 2.00,  Tipo = "FII", MinYield = 0.005, MaxYield = 0.02,  CurrentYield = 0.01},
	{Nome = "FII MallPrime",        PrecoBase = 8.00,  Preco = 8.00,  Tipo = "FII", MinYield = 0.008, MaxYield = 0.025, CurrentYield = 0.015},
	{Nome = "FII AgroBrasil",       PrecoBase = 10.50, Preco = 10.50, Tipo = "FII", MinYield = 0.006, MaxYield = 0.022, CurrentYield = 0.012},
	{Nome = "FII EducacionalEdu",   PrecoBase = 12.50, Preco = 12.50, Tipo = "FII", MinYield = 0.005, MaxYield = 0.019, CurrentYield = 0.010},
	{Nome = "FII LogísticaBR",      PrecoBase = 18.00, Preco = 18.00, Tipo = "FII", MinYield = 0.010, MaxYield = 0.030, CurrentYield = 0.020},
	{Nome = "FII ShoppingsMax",    PrecoBase = 25.00, Preco = 25.00, Tipo = "FII", MinYield = 0.007, MaxYield = 0.024, CurrentYield = 0.014},
	{Nome = "FII InfraRed",         PrecoBase = 45.00, Preco = 45.00, Tipo = "FII", MinYield = 0.009, MaxYield = 0.028, CurrentYield = 0.018},
	{Nome = "FII HospitaisCare",    PrecoBase = 60.00, Preco = 60.00, Tipo = "FII", MinYield = 0.010, MaxYield = 0.030, CurrentYield = 0.020},

	-- Ações Especulativas (Stocks)
	{Nome = "Ação VarejoMix (VRJO)",    PrecoBase = 3.00,  Preco = 3.00,  Tipo = "Stock", Info = "Varejo Especulativo"},
	{Nome = "Ação Tech Corp (PETR)",    PrecoBase = 4.50,  Preco = 4.50,  Tipo = "Stock", Info = "Alta Oscilação Tech"},
	{Nome = "Ação CryptoMining (CRPT)", PrecoBase = 6.80,  Preco = 6.80,  Tipo = "Stock", Info = "Alta Especulação Cripto"},
	{Nome = "Ação AutoMotors (AUTO)",   PrecoBase = 8.50,  Preco = 8.50,  Tipo = "Stock", Info = "Setor Automotivo Global"},
	{Nome = "Ação MegaBank (MBNK)",     PrecoBase = 12.00, Preco = 12.00, Tipo = "Stock", Info = "Setor Bancário Sólido"},
	{Nome = "Ação EnergeticGreen (ENGY)",PrecoBase = 15.00, Preco = 15.00, Tipo = "Stock", Info = "Energia Renovável"},
	{Nome = "Ação BioPharma (BIOS)",    PrecoBase = 22.50, Preco = 22.50, Tipo = "Stock", Info = "Biotecnologia Avançada"},
	{Nome = "Ação AeroSpace (AERO)",    PrecoBase = 35.00, Preco = 35.00, Tipo = "Stock", Info = "Indústria Aeroespacial"}
}

local lifestyleGoods = {
	{Nome = "🛹 Skateboard Pro", Preco = 5.00},
	{Nome = "🚲 Bicicleta Urbana", Preco = 10.00},
	{Nome = "🛴 Patinete Elétrico", Preco = 25.00},
	{Nome = "⌚ Relógio Smart", Preco = 50.00},
	{Nome = "🎧 Headset Premium", Preco = 80.00},
	{Nome = "💻 Laptop Gamer", Preco = 150.00},
	{Nome = "🏍️ Moto Esportiva", Preco = 300.00},
	{Nome = "📸 Câmera Profissional", Preco = 500.00},
	{Nome = "🛸 Drone 4K", Preco = 800.00},
	{Nome = "🚗 Carro Sedan", Preco = 1500.00},
	{Nome = "🍷 Adega de Vinhos Raros", Preco = 3000.00},
	{Nome = "🏎️ Superesportivo", Preco = 6000.00},
	{Nome = "🚤 Jet Ski Turbo", Preco = 10000.00},
	{Nome = "🐎 Cavalo Puro-Sangue", Preco = 18000.00},
	{Nome = "🛥️ Lancha de Luxo", Preco = 30000.00},
	{Nome = "🏡 Mansão de Luxo", Preco = 50000.00},
	{Nome = "🏎️ Carro de Fórmula 1", Preco = 100000.00},
	{Nome = "🚁 Helicóptero Executivo", Preco = 200000.00},
	{Nome = "🛥️ Iate Particular", Preco = 400000.00},
	{Nome = "🛩️ Jato Privado", Preco = 800000.00},
	{Nome = "🏢 Penthouse em Nova York", Preco = 1500000.00},
	{Nome = "🏰 Castelo Histórico", Preco = 3000000.00},
	{Nome = "🏝️ Ilha Particular", Preco = 6000000.00},
	{Nome = "🎨 Coleção de Arte Valiosa", Preco = 10000000.00},
	{Nome = "🛩️ Caça Supersônico Privado", Preco = 18000000.00},
	{Nome = "🏨 Resort de Luxo", Preco = 30000000.00},
	{Nome = "🏢 Arranha-Céu Comercial", Preco = 50000000.00},
	{Nome = "🚢 Transatlântico de Cruzeiro", Preco = 90000000.00},
	{Nome = "🪸 Atol de Corais Privado", Preco = 150000000.00},
	{Nome = "🎰 Cassino em Las Vegas", Preco = 250000000.00},
	{Nome = "🏟️ Estádio de Futebol", Preco = 400000000.00},
	{Nome = "✈️ Frota Aérea Comercial", Preco = 700000000.00},
	{Nome = "🛢️ Refinaria de Petróleo", Preco = 1200000000.00},
	{Nome = "🛰️ Estação Espacial Privada", Preco = 2000000000.00},
	{Nome = "💎 Mina de Diamantes", Preco = 3500000000.00},
	{Nome = "🌐 Rede Social Global", Preco = 6000000000.00},
	{Nome = "📽️ Estúdio de Cinema", Preco = 10000000000.00},
	{Nome = "🏦 Banco Comercial Privado", Preco = 18000000000.00},
	{Nome = "⚡ Usina Nuclear de Energia", Preco = 30000000000.00},
	{Nome = "🚢 Frota Global de Cargueiros", Preco = 50000000000.00},
	{Nome = "🚀 Empresa Espacial Privada", Preco = 90000000000.00},
	{Nome = "🏗️ Cidade Inteligente Privada", Preco = 150000000000.00},
	{Nome = "🛰️ Constelação Global de Satélites", Preco = 250000000000.00},
	{Nome = "🌕 Base de Mineração Lunar", Preco = 400000000000.00},
	{Nome = "🪐 Colônia em Marte", Preco = 700000000000.00},
	{Nome = "🌌 Elevador Espacial Orbitário", Preco = 1200000000000.00},
	{Nome = "☀️ Esfera Energética Solar", Preco = 2000000000000.00},
	{Nome = "🪐 Estação de Mineração em Asteroides", Preco = 3500000000000.00},
	{Nome = "🛸 Frota Comercial Interplanetária", Preco = 6000000000000.00},
	{Nome = "🌀 Reator de Fusão Quântica", Preco = 10000000000000.00},
	{Nome = "🛰️ Megastrutura Orbital", Preco = 18000000000000.00},
	{Nome = "🏙️ Metrópole Submarina", Preco = 30000000000000.00},
	{Nome = "🌌 Portal de Dobra Espacial", Preco = 50000000000000.00},
	{Nome = "🪐 Terraformação de Planeta", Preco = 90000000000000.00},
	{Nome = "⭐ Anel de Mineração Estelar", Preco = 150000000000000.00},
	{Nome = "💫 Matriz Quântica Galáctica", Preco = 250000000000000.00},
	{Nome = "🌌 Rede de Comunicação Intergaláctica", Preco = 500000000000000.00},
	{Nome = "🪐 Domínio de Sistema Solar", Preco = 1000000000000000.00},
	{Nome = "✨ Esfera de Dyson Completa", Preco = 2500000000000000.00},
	{Nome = "🌌 Núcleo Energético Universal", Preco = 5000000000000000.00},

	-- NOVOS BENS DE EXPANSÃO (PROGRESSÃO FUTURÍSTICA & CÓSMICA)
	{Nome = "🔮 Manipulador de Matéria Negra", Preco = 10000000000000000.00},
	{Nome = "🌀 Motor de Gravidade Artificial", Preco = 25000000000000000.00},
	{Nome = "🌌 Matriz de Realidade Simulada", Preco = 60000000000000000.00},
	{Nome = "🪐 Anel Orbital Terrestre", Preco = 150000000000000000.00},
	{Nome = "💫 Gerador de Singularidade Controlada", Preco = 400000000000000000.00},
	{Nome = "⭐ Forja Estelar de Elementos Raros", Preco = 1000000000000000000.00},
	{Nome = "🌌 Frota Construtora de Planetóides", Preco = 2800000000000000000.00},
	{Nome = "🪐 Bio-Domo Subterrâneo em Titã", Preco = 7500000000000000000.00},
	{Nome = "🌀 Estação de Energia Quântica", Preco = 20000000000000000000.00},
	{Nome = "✨ Tecelão do Espaço-Tempo", Preco = 55000000000000000000.00},
	{Nome = "🌌 Complexo Multidimensional", Preco = 150000000000000000000.00},
	{Nome = "🔮 Processador Taquiônico", Preco = 400000000000000000000.00},
	{Nome = "🪐 Terraformador de Galáxias", Preco = 1200000000000000000000.00},
	{Nome = "⭐ Escudo de Força Planetário", Preco = 3500000000000000000000.00},
	{Nome = "🌀 Portal de Dobra Subespacial", Preco = 9000000000000000000000.00},
	{Nome = "🌌 Cidade Orbital Voadora", Preco = 25000000000000000000000.00},
	{Nome = "💫 Transmutador Elementar Universal", Preco = 70000000000000000000000.00},
	{Nome = "🪐 Colônia Estratificada em Vênus", Preco = 200000000000000000000000.00},
	{Nome = "✨ Condensador de Matéria Escura", Preco = 600000000000000000000000.00},
	{Nome = "🔮 Sintetizador de Micro-Universos", Preco = 1800000000000000000000000.00},
	{Nome = "🌌 Rede de Faróis Intergalácticos", Preco = 5000000000000000000000000.00},
	{Nome = "🌀 Motor de Antimatéria Estável", Preco = 15000000000000000000000000.00},
	{Nome = "⭐ Projetor Gravitacional Global", Preco = 42000000000000000000000000.00},
	{Nome = "🪐 Esfera Habitacional em Europa", Preco = 120000000000000000000000000.00},
	{Nome = "💫 Âncora Temporal Estática", Preco = 350000000000000000000000000.00},
	{Nome = "🌌 Frota Interdimensional", Preco = 1000000000000000000000000000.00},
	{Nome = "🔮 Consciência Coletiva Sintética", Preco = 3000000000000000000000000000.00},
	{Nome = "🌀 Condensador de Vácuo Quântico", Preco = 8500000000000000000000000000.00},
	{Nome = "⭐ Forja de Buracos de Minhoca", Preco = 25000000000000000000000000000.00},
	{Nome = "🪐 Colheita Energética de Pulsares", Preco = 75000000000000000000000000000.00},
	{Nome = "✨ Matriz de Dobra Multiversal", Preco = 200000000000000000000000000000.00},
	{Nome = "🌌 Rede Neural Galáctica", Preco = 600000000000000000000000000000.00},
	{Nome = "🔮 Amplificador de Entropia Negativa", Preco = 1800000000000000000000000000000.00},
	{Nome = "🌀 Gerador de Dobra Cosmóide", Preco = 5000000000000000000000000000000.00},
	{Nome = "⭐ Reator Neutrônico de Alta Densidade", Preco = 15000000000000000000000000000000.00},
	{Nome = "🪐 Domínio de Aglomerado Estelar", Preco = 45000000000000000000000000000000.00},
	{Nome = "💫 Matriz Transdimensional Infinita", Preco = 120000000000000000000000000000000.00},
	{Nome = "🌌 Núcleo de Criação de Big Bangs", Preco = 350000000000000000000000000000000.00},
	{Nome = "🔮 Tecelão da Tapeçaria Cósmica", Preco = 1000000000000000000000000000000000.00},
	{Nome = "🌀 Motor Exótico Dimensional", Preco = 3000000000000000000000000000000000.00},
	{Nome = "⭐ Reator Quântico Multiversal", Preco = 9000000000000000000000000000000000.00},
	{Nome = "🪐 Complexo Pan-Galáctico", Preco = 25000000000000000000000000000000000.00},
	{Nome = "✨ Condensador Hiper-Espacial", Preco = 75000000000000000000000000000000000.00},
	{Nome = "🌌 Tecelão Espaço-Temporal", Preco = 200000000000000000000000000000000000.00},
	{Nome = "🔮 Núcleo do Omniverso", Preco = 600000000000000000000000000000000000.00},
	{Nome = "🌀 Fonte Primordial de Energia", Preco = 1800000000000000000000000000000000000.00},
	{Nome = "⭐ Manipulador de Constantes Físicas", Preco = 5000000000000000000000000000000000000.00},
	{Nome = "🪐 Refúgio Trans-Dimensional", Preco = 15000000000000000000000000000000000000.00},
	{Nome = "💫 Matriz Suprema da Existência", Preco = 45000000000000000000000000000000000000.00},
	{Nome = "🌌 Arquitetura do Infinito", Preco = 100000000000000000000000000000000000000.00}
}

local brokerageList = {
	{Nome = "Angélica", Preco = 50.00, Bonus = 0.01},
	{Nome = "PrimeTrade", Preco = 250.00, Bonus = 0.02},
	{Nome = "Apex Invest", Preco = 1000.00, Bonus = 0.03},
	{Nome = "Titan Global", Preco = 5000.00, Bonus = 0.04},
	{Nome = "Zenith Capital", Preco = 20000.00, Bonus = 0.05},
	{Nome = "Vanguard Plus", Preco = 75000.00, Bonus = 0.07},
	{Nome = "BlackGold Asset", Preco = 250000.00, Bonus = 0.09},
	{Nome = "Quantum Wealth", Preco = 1000000.00, Bonus = 0.11},
	{Nome = "Orion Wealth", Preco = 3500000.00, Bonus = 0.13},
	{Nome = "Apex Prime", Preco = 10000000.00, Bonus = 0.15},
	{Nome = "Alpha Capital", Preco = 30000000.00, Bonus = 0.18},
	{Nome = "Nebula Financial", Preco = 80000000.00, Bonus = 0.21},
	{Nome = "Sterling Trust", Preco = 200000000.00, Bonus = 0.24},
	{Nome = "Apex Dynasty", Preco = 500000000.00, Bonus = 0.27},
	{Nome = "Horizon Holdings", Preco = 1200000000.00, Bonus = 0.30},
	{Nome = "Olympus Global", Preco = 3000000000.00, Bonus = 0.34},
	{Nome = "Phoenix Partners", Preco = 8000000000.00, Bonus = 0.38},
	{Nome = "Sovereign Capital", Preco = 20000000000.00, Bonus = 0.42},
	{Nome = "Infinity Securities", Preco = 50000000000.00, Bonus = 0.46},
	{Nome = "Paragon Asset", Preco = 120000000000.00, Bonus = 0.50},
	{Nome = "Eclipse Investments", Preco = 300000000000.00, Bonus = 0.55},
	{Nome = "Citadel Wealth", Preco = 800000000000.00, Bonus = 0.60},
	{Nome = "Crestview Financial", Preco = 2000000000000.00, Bonus = 0.65},
	{Nome = "Crown Royal Capital", Preco = 5000000000000.00, Bonus = 0.70},
	{Nome = "Dominion Securities", Preco = 12000000000000.00, Bonus = 0.72},
	{Nome = "Dynasty Global", Preco = 30000000000000.00, Bonus = 0.73},
	{Nome = "Enterprise Wealth", Preco = 80000000000000.00, Bonus = 0.74},
	{Nome = "Fortress Financial", Preco = 200000000000000.00, Bonus = 0.75},

	-- NOVAS CORRETORAS DE EXPANSÃO (PROGRESSÃO CÓSMICA)
	{Nome = "Valhalla Capital", Preco = 500000000000000.00, Bonus = 0.78},
	{Nome = "Titan Prime Trust", Preco = 1200000000000000.00, Bonus = 0.82},
	{Nome = "Zenith Universal", Preco = 3000000000000000.00, Bonus = 0.86},
	{Nome = "Chronos Financial", Preco = 8000000000000000.00, Bonus = 0.90},
	{Nome = "Hyperion Asset", Preco = 20000000000000000.00, Bonus = 0.95},
	{Nome = "Aether Trust", Preco = 50000000000000000.00, Bonus = 1.00},
	{Nome = "Quantum Dynasty", Preco = 120000000000000000.00, Bonus = 1.06},
	{Nome = "Stellar Prime", Preco = 300000000000000000.00, Bonus = 1.12},
	{Nome = "Celestial Holdings", Preco = 800000000000000000.00, Bonus = 1.18},
	{Nome = "Galactic Sovereign", Preco = 2000000000000000000.00, Bonus = 1.25},
	{Nome = "Nebula Securities", Preco = 5000000000000000000.00, Bonus = 1.32},
	{Nome = "Pulsar Wealth", Preco = 12000000000000000000.00, Bonus = 1.40},
	{Nome = "Singularity Trust", Preco = 30000000000000000000.00, Bonus = 1.48},
	{Nome = "Astral Capital", Preco = 75000000000000000000.00, Bonus = 1.57},
	{Nome = "Cosmos Asset", Preco = 180000000000000000000.00, Bonus = 1.66},
	{Nome = "Eclipse Sovereign", Preco = 450000000000000000000.00, Bonus = 1.76},
	{Nome = "Horizon Galaxy", Preco = 1000000000000000000000.00, Bonus = 1.87},
	{Nome = "Paragon Infinity", Preco = 2500000000000000000000.00, Bonus = 1.98},
	{Nome = "Titan Multiverse", Preco = 6000000000000000000000.00, Bonus = 2.10},
	{Nome = "Vanguard Cosmic", Preco = 15000000000000000000000.00, Bonus = 2.23},
	{Nome = "Orion Prime Global", Preco = 40000000000000000000000.00, Bonus = 2.37},
	{Nome = "Sovereign Multiverse", Preco = 100000000000000000000000.00, Bonus = 2.52},
	{Nome = "Apex Infinity", Preco = 250000000000000000000000.00, Bonus = 2.68},
	{Nome = "BlackHole Asset", Preco = 600000000000000000000000.00, Bonus = 2.85},
	{Nome = "Zenith Quantum", Preco = 1500000000000000000000000.00, Bonus = 3.03},
	{Nome = "Nebula Sovereign", Preco = 4000000000000000000000000.00, Bonus = 3.22},
	{Nome = "Chronos Empire", Preco = 10000000000000000000000000.00, Bonus = 3.42},
	{Nome = "Celestial Empire", Preco = 25000000000000000000000000.00, Bonus = 3.63},
	{Nome = "Aether Infinity", Preco = 60000000000000000000000000.00, Bonus = 3.85},
	{Nome = "Galactic Apex", Preco = 150000000000000000000000000.00, Bonus = 4.08},
	{Nome = "Singular Wealth", Preco = 400000000000000000000000000.00, Bonus = 4.32},
	{Nome = "Transcendent Trust", Preco = 1000000000000000000000000000.00, Bonus = 4.57},
	{Nome = "Prime Omniverse", Preco = 2500000000000000000000000000.00, Bonus = 4.83},
	{Nome = "Horizon Quantum", Preco = 6000000000000000000000000000.00, Bonus = 5.10},
	{Nome = "Paragon Cosmic", Preco = 15000000000000000000000000000.00, Bonus = 5.38},
	{Nome = "Titan Empire", Preco = 40000000000000000000000000000.00, Bonus = 5.67},
	{Nome = "Vanguard Transcendent", Preco = 100000000000000000000000000000.00, Bonus = 5.97},
	{Nome = "Infinity Sovereign", Preco = 250000000000000000000000000000.00, Bonus = 6.28},
	{Nome = "Apex Omniverse", Preco = 600000000000000000000000000000.00, Bonus = 6.60},
	{Nome = "Astral Empire", Preco = 1500000000000000000000000000000.00, Bonus = 6.93},
	{Nome = "Cosmos Sovereign", Preco = 4000000000000000000000000000000.00, Bonus = 7.27},
	{Nome = "Zenith Transcendent", Preco = 10000000000000000000000000000000.00, Bonus = 7.62},
	{Nome = "Chronos Omniverse", Preco = 25000000000000000000000000000000.00, Bonus = 7.98},
	{Nome = "Aether Sovereign", Preco = 60000000000000000000000000000000.00, Bonus = 8.35},
	{Nome = "Galactic Infinity", Preco = 150000000000000000000000000000000.00, Bonus = 8.73},
	{Nome = "Singular Empire", Preco = 400000000000000000000000000000000.00, Bonus = 9.12},
	{Nome = "Transcendent Omniverse", Preco = 1000000000000000000000000000000000.00, Bonus = 9.52},
	{Nome = "Prime Eternal", Preco = 2500000000000000000000000000000000.00, Bonus = 9.93},
	{Nome = "Horizon Infinity", Preco = 6000000000000000000000000000000000.00, Bonus = 10.35},
	{Nome = "Paragon Eternal", Preco = 15000000000000000000000000000000000.00, Bonus = 10.78}
}

local noticiasPossiveis = {
	{Texto = "BOOM IMOBILIÁRIO! Dividendos dos FIIs renderam o dobro!", Multiplicador = 2.0},
	{Texto = "CRISE FINANCEIRA! Rendimentos globais caíram pela metade!", Multiplicador = 0.5},
	{Texto = "MERCADO ESTÁVEL! Os investimentos operam em ritmo normal.", Multiplicador = 1.0},
	{Texto = "INCENTIVO FISCAL! Renda passiva aumentou +50%!", Multiplicador = 1.5}
}

-- ============================================================================
-- 3. ESTADO GLOBAL DO SISTEMA
-- ============================================================================
local playerDataMap = {}
local playerUIs = {}
local iniciando = {}

local multiplicadorNoticia = 1.0
local noticiaAtual = "MERCADO ESTÁVEL! Os investimentos operam em ritmo normal."

local successDS, financeDataStore = pcall(function()
	return DataStoreService:GetDataStore("SimuladorFinanceiro_Save_v13")
end)

-- ============================================================================
-- 4. FUNÇÕES UTILITÁRIAS & FORMATADORES DE TEXTO/UI
-- ============================================================================
local function formatarNumero(valor, casas, comSinal)
	valor = valor or 0
	local negativo = valor < 0
	valor = math.abs(valor)

	if valor < 1000 then
		casas = casas or 2
		local texto = string.format("%." .. casas .. "f", valor)
		texto = string.gsub(texto, "%.", SEPARADOR_DECIMAL)
		if negativo and tonumber(texto) ~= 0 then
			return "-" .. texto
		elseif comSinal and tonumber(texto) ~= 0 then
			return "+" .. texto
		end
		return texto
	end

	local index = 1
	while valor >= 1000 and index < #SUFIXOS do
		valor = valor / 1000
		index = index + 1
	end

	local texto = string.format("%.2f", valor)
	texto = string.gsub(texto, "%.0+$", "")
	texto = string.gsub(texto, "(%d+%.%d-)0+$", "%1")
	texto = string.gsub(texto, "%.", SEPARADOR_DECIMAL)

	local resultado = texto .. SUFIXOS[index]
	if negativo then
		resultado = "-" .. resultado
	elseif comSinal then
		resultado = "+" .. resultado
	end
	return resultado
end

local function formatarMoeda(valor, casas, comSinal)
	local texto = formatarNumero(valor, casas, comSinal)
	local sinal = string.match(texto, "^[%+%-]")
	if sinal then
		return sinal .. "$" .. string.sub(texto, 2)
	end
	return "$" .. texto
end

local function formatarTempo(segundos)
	local min = math.floor(segundos / 60)
	local seg = segundos % 60
	return string.format("%02d:%02d", min, seg)
end

local function copiarTabela(origem)
	local copia = {}
	for k, v in pairs(origem) do copia[k] = v end
	return copia
end

-- UI Helpers
local function addCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 8)
	c.Parent = parent
	return c
end

local function addStroke(parent, color, thickness, trans)
	local s = Instance.new("UIStroke")
	s.Color = color or Color3.fromRGB(60, 68, 90)
	s.Thickness = thickness or 1
	s.Transparency = trans or 0.4
	s.Parent = parent
	return s
end

local function addGradient(parent, color1, color2, rotation)
	local g = Instance.new("UIGradient")
	g.Color = ColorSequence.new(color1, color2)
	g.Rotation = rotation or 90
	g.Parent = parent
	return g
end

local function textoInfoAtivo(ativo)
	if ativo.Tipo == "FII" then
		return "Rendimento: " .. formatarMoeda((ativo.Preco * ativo.CurrentYield) / INTERVALO_FIIS_SEGUNDOS, 3) .. "/s\nPreço: " .. formatarMoeda(ativo.Preco)
	end
	return (ativo.Info or "Ação") .. "\nPreço: " .. formatarMoeda(ativo.Preco)
end

local function variacaoPercentual(ativo)
	return ((ativo.Preco - ativo.PrecoBase) / ativo.PrecoBase) * 100
end

-- ============================================================================
-- 5. GERENCIAMENTO DE DATASTORE (CARREGAR / SALVAR / INICIALIZAR)
-- ============================================================================
local function criarDadosIniciais()
	local dados = {
		saldo = 5.00,
		portfolioQtd = {},
		portfolioPrecoMedio = {},
		bensComprados = {},
		corretorasCompradas = {},
		totalGanhoFII = 0.00,
		totalGanhoBens = 0.00,
		totalGanhoAcoes = 0.00,
		tempoBensSegundos = 0,
		tempoFIIsSegundos = 0,
		nivelRebirth = 0,
		carregado = false,
		salvando = false,
		salvoFinal = false
	}
	for _, ativo in ipairs(marketAssets) do
		dados.portfolioQtd[ativo.Nome] = 0
		dados.portfolioPrecoMedio[ativo.Nome] = 0.00
	end
	for _, bem in ipairs(lifestyleGoods) do
		dados.bensComprados[bem.Nome] = false
	end
	for _, corretora in ipairs(brokerageList) do
		dados.corretorasCompradas[corretora.Nome] = false
	end
	return dados
end

local function tentarDataStore(descricao, funcao)
	local ultimoErro
	for tentativa = 1, TENTATIVAS_DATASTORE do
		local ok, resultado = pcall(funcao)
		if ok then return true, resultado end
		ultimoErro = resultado
		warn(string.format("[DataStore] %s falhou (tentativa %d/%d): %s", descricao, tentativa, TENTATIVAS_DATASTORE, tostring(resultado)))
		if tentativa < TENTATIVAS_DATASTORE then task.wait(2 * tentativa) end
	end
	return false, ultimoErro
end

local function aplicarDadosSalvos(dados, salvo)
	if type(salvo) ~= "table" then return end
	if type(salvo.saldo) == "number" then dados.saldo = salvo.saldo end
	if type(salvo.nivelRebirth) == "number" then dados.nivelRebirth = salvo.nivelRebirth end

	local function mesclar(destino, origem)
		if type(origem) == "table" then
			for k, v in pairs(origem) do destino[k] = v end
		end
	end
	mesclar(dados.portfolioQtd, salvo.portfolioQtd)
	mesclar(dados.portfolioPrecoMedio, salvo.portfolioPrecoMedio)
	mesclar(dados.bensComprados, salvo.bensComprados)
	mesclar(dados.corretorasCompradas, salvo.corretorasCompradas)

	for _, campo in ipairs({"totalGanhoFII", "totalGanhoBens", "totalGanhoAcoes"}) do
		if type(salvo[campo]) == "number" then dados[campo] = salvo[campo] end
	end
end

local function carregarDados(player)
	local chave = "Player_" .. player.UserId
	return tentarDataStore("carregar " .. player.Name, function()
		return financeDataStore:GetAsync(chave)
	end)
end

local function salvarDados(player, final)
	if not successDS or not financeDataStore then return false end
	local dados = playerDataMap[player]
	if not dados or not dados.carregado then return false end

	if dados.salvando then
		if not final then return false end
		while dados.salvando do task.wait(0.1) end
	end
	if final and dados.salvoFinal then return true end
	dados.salvando = true

	local dadosParaSalvar = {
		saldo = dados.saldo,
		nivelRebirth = dados.nivelRebirth,
		portfolioQtd = copiarTabela(dados.portfolioQtd),
		portfolioPrecoMedio = copiarTabela(dados.portfolioPrecoMedio),
		bensComprados = copiarTabela(dados.bensComprados),
		corretorasCompradas = copiarTabela(dados.corretorasCompradas),
		totalGanhoFII = dados.totalGanhoFII,
		totalGanhoBens = dados.totalGanhoBens,
		totalGanhoAcoes = dados.totalGanhoAcoes
	}

	local chave = "Player_" .. player.UserId
	local ok = tentarDataStore("salvar " .. player.Name, function()
		financeDataStore:UpdateAsync(chave, function() return dadosParaSalvar end)
	end)

	dados.salvando = false
	if ok and final then dados.salvoFinal = true end
	return ok
end

-- ============================================================================
-- 6. CONSTRUTOR DA INTERFACE GRÁFICA DO JOGADOR
-- ============================================================================
local function criarInterface(player, dados)
	local playerGui = player:WaitForChild("PlayerGui")
	if playerGui:FindFirstChild("TerminalInvestimentos") then
		playerGui.TerminalInvestimentos:Destroy()
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "TerminalInvestimentos"
	screenGui.IgnoreGuiInset = true
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	local mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.new(1, 0, 1, 0)
	mainFrame.BackgroundColor3 = Color3.fromRGB(15, 17, 26)
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screenGui

	-- Banner de Notícias Global (Topo)
	local bannerNoticia = Instance.new("TextLabel")
	bannerNoticia.Name = "BannerNoticia"
	bannerNoticia.Size = UDim2.new(1, 0, 0, 28)
	bannerNoticia.Position = UDim2.new(0, 0, 0, 0)
	bannerNoticia.BackgroundColor3 = Color3.fromRGB(245, 165, 35)
	bannerNoticia.TextColor3 = Color3.fromRGB(20, 20, 25)
	bannerNoticia.Font = Enum.Font.FredokaOne
	bannerNoticia.TextSize = 13
	bannerNoticia.Text = "📢 " .. noticiaAtual
	bannerNoticia.Parent = mainFrame
	addGradient(bannerNoticia, Color3.fromRGB(255, 185, 45), Color3.fromRGB(230, 140, 20))

	-- Header Superior
	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 65)
	header.Position = UDim2.new(0, 0, 0, 28)
	header.BackgroundColor3 = Color3.fromRGB(22, 26, 38)
	header.BorderSizePixel = 0
	header.Parent = mainFrame
	addStroke(header, Color3.fromRGB(45, 52, 75), 1, 0.5)

	local titulo = Instance.new("TextLabel")
	titulo.Size = UDim2.new(0, 240, 1, 0)
	titulo.Position = UDim2.new(0, 210, 0, 0)
	titulo.Text = "💰 SIMULADOR FINANCEIRO"
	titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
	titulo.TextSize = 16
	titulo.Font = Enum.Font.FredokaOne
	titulo.TextXAlignment = Enum.TextXAlignment.Left
	titulo.BackgroundTransparency = 1
	titulo.Parent = header

	local navContainer = Instance.new("Frame")
	navContainer.Size = UDim2.new(0, 680, 0, 42)
	navContainer.Position = UDim2.new(0, 420, 0, 11)
	navContainer.BackgroundTransparency = 1
	navContainer.Parent = header

	-- Card de Saldo no Header
	local saldoCard = Instance.new("Frame")
	saldoCard.Size = UDim2.new(0, 310, 0, 44)
	saldoCard.Position = UDim2.new(1, -330, 0, 10)
	saldoCard.BackgroundColor3 = Color3.fromRGB(15, 30, 25)
	saldoCard.BorderSizePixel = 0
	saldoCard.Parent = header
	addCorner(saldoCard, 8)
	addStroke(saldoCard, Color3.fromRGB(0, 200, 115), 1, 0.4)

	local saldoText = Instance.new("TextLabel")
	saldoText.Name = "SaldoLabel"
	saldoText.Size = UDim2.new(1, -20, 1, 0)
	saldoText.Position = UDim2.new(0, 10, 0, 0)
	saldoText.Text = "Saldo: " .. formatarMoeda(dados.saldo)
	saldoText.TextColor3 = Color3.fromRGB(0, 230, 130)
	saldoText.TextSize = 15
	saldoText.TextScaled = true
	saldoText.Font = Enum.Font.FredokaOne
	saldoText.TextXAlignment = Enum.TextXAlignment.Right
	saldoText.BackgroundTransparency = 1
	saldoText.Parent = saldoCard

	local limiteSaldo = Instance.new("UITextSizeConstraint")
	limiteSaldo.MaxTextSize = 15
	limiteSaldo.MinTextSize = 8
	limiteSaldo.Parent = saldoText

	-- Botão & Modal de Reset do Desenvolvedor
	if player.UserId == DEV_USER_ID then
		local btnDevReset = Instance.new("TextButton")
		btnDevReset.Size = UDim2.new(0, 30, 0, 30)
		btnDevReset.Position = UDim2.new(1, -370, 0, 17)
		btnDevReset.BackgroundColor3 = Color3.fromRGB(32, 38, 54)
		btnDevReset.Text = "⚙️"
		btnDevReset.TextColor3 = Color3.fromRGB(255, 255, 255)
		btnDevReset.TextSize = 14
		btnDevReset.BorderSizePixel = 0
		btnDevReset.Parent = header
		addCorner(btnDevReset, 6)
		addStroke(btnDevReset, Color3.fromRGB(80, 90, 115), 1, 0.3)

		local modalReset = Instance.new("Frame")
		modalReset.Size = UDim2.new(0, 360, 0, 180)
		modalReset.Position = UDim2.new(0.5, -180, 0.5, -90)
		modalReset.BackgroundColor3 = Color3.fromRGB(24, 28, 40)
		modalReset.BorderSizePixel = 0
		modalReset.Visible = false
		modalReset.ZIndex = 30
		modalReset.Parent = mainFrame
		addCorner(modalReset, 12)
		addStroke(modalReset, Color3.fromRGB(235, 60, 80), 2, 0.2)

		local modalTitle = Instance.new("TextLabel")
		modalTitle.Size = UDim2.new(1, 0, 0, 40)
		modalTitle.Position = UDim2.new(0, 0, 0, 10)
		modalTitle.Text = "⚠️ RESETAR PROGRESSO (DEV)"
		modalTitle.TextColor3 = Color3.fromRGB(255, 80, 80)
		modalTitle.Font = Enum.Font.FredokaOne
		modalTitle.TextSize = 16
		modalTitle.BackgroundTransparency = 1
		modalTitle.ZIndex = 31
		modalTitle.Parent = modalReset

		local modalDesc = Instance.new("TextLabel")
		modalDesc.Size = UDim2.new(1, -30, 0, 50)
		modalDesc.Position = UDim2.new(0, 15, 0, 50)
		modalDesc.Text = "Tem certeza que deseja apagar permanentemente todo o progresso do DataStore? Esta ação não pode ser desfeita."
		modalDesc.TextColor3 = Color3.fromRGB(200, 205, 220)
		modalDesc.Font = Enum.Font.SourceSans
		modalDesc.TextSize = 14
		modalDesc.TextWrapped = true
		modalDesc.BackgroundTransparency = 1
		modalDesc.ZIndex = 31
		modalDesc.Parent = modalReset

		local btnConfirmarReset = Instance.new("TextButton")
		btnConfirmarReset.Size = UDim2.new(0, 140, 0, 36)
		btnConfirmarReset.Position = UDim2.new(0.5, -150, 1, -48)
		btnConfirmarReset.BackgroundColor3 = Color3.fromRGB(220, 50, 70)
		btnConfirmarReset.Text = "SIM, RESETAR"
		btnConfirmarReset.TextColor3 = Color3.fromRGB(255, 255, 255)
		btnConfirmarReset.Font = Enum.Font.FredokaOne
		btnConfirmarReset.TextSize = 12
		btnConfirmarReset.BorderSizePixel = 0
		btnConfirmarReset.ZIndex = 31
		btnConfirmarReset.Parent = modalReset
		addCorner(btnConfirmarReset, 6)

		local btnCancelarReset = Instance.new("TextButton")
		btnCancelarReset.Size = UDim2.new(0, 140, 0, 36)
		btnCancelarReset.Position = UDim2.new(0.5, 10, 1, -48)
		btnCancelarReset.BackgroundColor3 = Color3.fromRGB(45, 52, 70)
		btnCancelarReset.Text = "CANCELAR"
		btnCancelarReset.TextColor3 = Color3.fromRGB(255, 255, 255)
		btnCancelarReset.Font = Enum.Font.FredokaOne
		btnCancelarReset.TextSize = 12
		btnCancelarReset.BorderSizePixel = 0
		btnCancelarReset.ZIndex = 31
		btnCancelarReset.Parent = modalReset
		addCorner(btnCancelarReset, 6)

		btnDevReset.MouseButton1Click:Connect(function() modalReset.Visible = true end)
		btnCancelarReset.MouseButton1Click:Connect(function() modalReset.Visible = false end)
		btnConfirmarReset.MouseButton1Click:Connect(function()
			if successDS and financeDataStore then
				pcall(function() financeDataStore:RemoveAsync("Player_" .. player.UserId) end)
			end
			playerDataMap[player] = nil
			player:Kick("Seu progresso foi resetado com sucesso pelo Painel de Desenvolvedor.")
		end)
	end

	-- Containers das Abas
	local abas = {"Investimentos", "Bens & Luxo", "Corretoras", "Status & Relatórios", "🚀 Rebirth"}
	local botoesAbas = {}
	local telasConteudo = {}

	-- ABA 1: INVESTIMENTOS
	local contentInvestimentos = Instance.new("Frame")
	contentInvestimentos.Size = UDim2.new(1, 0, 1, -95)
	contentInvestimentos.Position = UDim2.new(0, 0, 0, 95)
	contentInvestimentos.BackgroundTransparency = 1
	contentInvestimentos.Parent = mainFrame
	telasConteudo["Investimentos"] = contentInvestimentos

	-- ABA 2: BENS & LUXO
	local containerBensLuxo = Instance.new("Frame")
	containerBensLuxo.Size = UDim2.new(1, -30, 1, -115)
	containerBensLuxo.Position = UDim2.new(0, 15, 0, 100)
	containerBensLuxo.BackgroundTransparency = 1
	containerBensLuxo.Visible = false
	containerBensLuxo.Parent = mainFrame

	local headerTimerBens = Instance.new("Frame")
	headerTimerBens.Size = UDim2.new(1, 0, 0, 36)
	headerTimerBens.BackgroundColor3 = Color3.fromRGB(24, 30, 46)
	headerTimerBens.BorderSizePixel = 0
	headerTimerBens.Parent = containerBensLuxo
	addCorner(headerTimerBens, 8)
	addStroke(headerTimerBens, Color3.fromRGB(0, 180, 105), 1, 0.4)

	local lblTimerBens = Instance.new("TextLabel")
	lblTimerBens.Size = UDim2.new(1, -20, 1, 0)
	lblTimerBens.Position = UDim2.new(0, 10, 0, 0)
	lblTimerBens.Text = "⏱️ Próximo Pagamento dos Bens: 00:05"
	lblTimerBens.TextColor3 = Color3.fromRGB(0, 230, 130)
	lblTimerBens.Font = Enum.Font.FredokaOne
	lblTimerBens.TextSize = 14
	lblTimerBens.TextXAlignment = Enum.TextXAlignment.Center
	lblTimerBens.BackgroundTransparency = 1
	lblTimerBens.Parent = headerTimerBens

	local contentBens = Instance.new("ScrollingFrame")
	contentBens.Size = UDim2.new(1, 0, 1, -44)
	contentBens.Position = UDim2.new(0, 0, 0, 44)
	contentBens.BackgroundColor3 = Color3.fromRGB(20, 24, 34)
	contentBens.BorderSizePixel = 0
	contentBens.CanvasSize = UDim2.new(0, 0, 0, #lifestyleGoods * 80)
	contentBens.ScrollBarThickness = 6
	contentBens.Parent = containerBensLuxo
	addCorner(contentBens, 10)
	addStroke(contentBens)

	local layoutBens = Instance.new("UIListLayout")
	layoutBens.Padding = UDim.new(0, 10)
	layoutBens.Parent = contentBens
	local padBens = Instance.new("UIPadding")
	padBens.PaddingTop = UDim.new(0, 12)
	padBens.PaddingLeft = UDim.new(0, 12)
	padBens.PaddingRight = UDim.new(0, 12)
	padBens.Parent = contentBens
	telasConteudo["Bens & Luxo"] = containerBensLuxo

	-- ABA 3: CORRETORAS
	local contentCorretoras = Instance.new("ScrollingFrame")
	contentCorretoras.Size = UDim2.new(1, -30, 1, -115)
	contentCorretoras.Position = UDim2.new(0, 15, 0, 100)
	contentCorretoras.BackgroundColor3 = Color3.fromRGB(20, 24, 34)
	contentCorretoras.BorderSizePixel = 0
	contentCorretoras.CanvasSize = UDim2.new(0, 0, 0, #brokerageList * 80)
	contentCorretoras.ScrollBarThickness = 6
	contentCorretoras.Visible = false
	contentCorretoras.Parent = mainFrame
	addCorner(contentCorretoras, 10)
	addStroke(contentCorretoras)

	local layoutCorretoras = Instance.new("UIListLayout")
	layoutCorretoras.Padding = UDim.new(0, 10)
	layoutCorretoras.Parent = contentCorretoras
	local padCorretoras = Instance.new("UIPadding")
	padCorretoras.PaddingTop = UDim.new(0, 12)
	padCorretoras.PaddingLeft = UDim.new(0, 12)
	padCorretoras.PaddingRight = UDim.new(0, 12)
	padCorretoras.Parent = contentCorretoras
	telasConteudo["Corretoras"] = contentCorretoras

	-- ABA 4: DASHBOARD / STATUS & RELATÓRIOS
	local contentStatus = Instance.new("Frame")
	contentStatus.Size = UDim2.new(0.68, 0, 0.80, 0)
	contentStatus.Position = UDim2.new(0.16, 0, 0.11, 10)
	contentStatus.BackgroundColor3 = Color3.fromRGB(22, 26, 38)
	contentStatus.BorderSizePixel = 0
	contentStatus.Visible = false
	contentStatus.Parent = mainFrame
	addCorner(contentStatus, 12)
	addStroke(contentStatus, Color3.fromRGB(0, 200, 115), 1.5, 0.3)
	telasConteudo["Status & Relatórios"] = contentStatus

	local statusTitle = Instance.new("TextLabel")
	statusTitle.Size = UDim2.new(1, 0, 0, 50)
	statusTitle.Position = UDim2.new(0, 0, 0, 10)
	statusTitle.Text = "📊 DASHBOARD FINANCEIRO"
	statusTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	statusTitle.Font = Enum.Font.FredokaOne
	statusTitle.TextSize = 24
	statusTitle.TextXAlignment = Enum.TextXAlignment.Center
	statusTitle.BackgroundTransparency = 1
	statusTitle.Parent = contentStatus

	-- Card 1: Fluxo de Caixa (Topo)
	local cardFIIs = Instance.new("Frame")
	cardFIIs.Size = UDim2.new(1, -40, 0, 145)
	cardFIIs.Position = UDim2.new(0, 20, 0, 65)
	cardFIIs.BackgroundColor3 = Color3.fromRGB(28, 33, 48)
	cardFIIs.BorderSizePixel = 0
	cardFIIs.Parent = contentStatus
	addCorner(cardFIIs, 8)
	addStroke(cardFIIs, Color3.fromRGB(0, 180, 105), 1, 0.4)

	local titleFIIs = Instance.new("TextLabel")
	titleFIIs.Size = UDim2.new(1, -30, 0, 25)
	titleFIIs.Position = UDim2.new(0, 15, 0, 10)
	titleFIIs.Text = "📈 FLUXO DE CAIXA E RENDIMENTOS (FIIs)"
	titleFIIs.TextColor3 = Color3.fromRGB(0, 230, 130)
	titleFIIs.Font = Enum.Font.FredokaOne
	titleFIIs.TextSize = 17
	titleFIIs.TextXAlignment = Enum.TextXAlignment.Left
	titleFIIs.BackgroundTransparency = 1
	titleFIIs.Parent = cardFIIs

	local textFIIs = Instance.new("TextLabel")
	textFIIs.Size = UDim2.new(1, -30, 0, 100)
	textFIIs.Position = UDim2.new(0, 15, 0, 38)
	textFIIs.Text = "Carregando..."
	textFIIs.TextColor3 = Color3.fromRGB(235, 240, 255)
	textFIIs.Font = Enum.Font.SourceSansBold
	textFIIs.TextSize = 17
	textFIIs.TextXAlignment = Enum.TextXAlignment.Left
	textFIIs.TextYAlignment = Enum.TextYAlignment.Top
	textFIIs.BackgroundTransparency = 1
	textFIIs.Parent = cardFIIs

	-- Card 2: Renda dos Bens (Esquerdo)
	local cardBens = Instance.new("Frame")
	cardBens.Size = UDim2.new(0.48, -5, 0, 125)
	cardBens.Position = UDim2.new(0, 20, 0, 220)
	cardBens.BackgroundColor3 = Color3.fromRGB(28, 33, 48)
	cardBens.BorderSizePixel = 0
	cardBens.Parent = contentStatus
	addCorner(cardBens, 8)
	addStroke(cardBens, Color3.fromRGB(70, 80, 110), 1, 0.4)

	local titleBens = Instance.new("TextLabel")
	titleBens.Size = UDim2.new(1, -20, 0, 25)
	titleBens.Position = UDim2.new(0, 12, 0, 10)
	titleBens.Text = "🏰 RENDA PASSIVA DOS BENS (5s)"
	titleBens.TextColor3 = Color3.fromRGB(255, 200, 80)
	titleBens.Font = Enum.Font.FredokaOne
	titleBens.TextSize = 16
	titleBens.TextXAlignment = Enum.TextXAlignment.Left
	titleBens.BackgroundTransparency = 1
	titleBens.Parent = cardBens

	local textBens = Instance.new("TextLabel")
	textBens.Size = UDim2.new(1, -20, 0, 75)
	textBens.Position = UDim2.new(0, 12, 0, 38)
	textBens.Text = "Carregando..."
	textBens.TextColor3 = Color3.fromRGB(235, 240, 255)
	textBens.Font = Enum.Font.SourceSansBold
	textBens.TextSize = 19
	textBens.TextXAlignment = Enum.TextXAlignment.Left
	textBens.TextYAlignment = Enum.TextYAlignment.Top
	textBens.BackgroundTransparency = 1
	textBens.Parent = cardBens

	-- Card 3: Ganhos Históricos (Direito)
	local cardLifetime = Instance.new("Frame")
	cardLifetime.Size = UDim2.new(0.48, -5, 0, 125)
	cardLifetime.Position = UDim2.new(0.52, -15, 0, 220)
	cardLifetime.BackgroundColor3 = Color3.fromRGB(28, 33, 48)
	cardLifetime.BorderSizePixel = 0
	cardLifetime.Parent = contentStatus
	addCorner(cardLifetime, 8)
	addStroke(cardLifetime, Color3.fromRGB(70, 80, 110), 1, 0.4)

	local titleLifetime = Instance.new("TextLabel")
	titleLifetime.Size = UDim2.new(1, -20, 0, 25)
	titleLifetime.Position = UDim2.new(0, 12, 0, 10)
	titleLifetime.Text = "🏆 GANHOS HISTÓRICOS (LIFETIME)"
	titleLifetime.TextColor3 = Color3.fromRGB(120, 200, 255)
	titleLifetime.Font = Enum.Font.FredokaOne
	titleLifetime.TextSize = 16
	titleLifetime.TextXAlignment = Enum.TextXAlignment.Left
	titleLifetime.BackgroundTransparency = 1
	titleLifetime.Parent = cardLifetime

	local textLifetime = Instance.new("TextLabel")
	textLifetime.Size = UDim2.new(1, -20, 0, 75)
	textLifetime.Position = UDim2.new(0, 12, 0, 38)
	textLifetime.Text = "Carregando..."
	textLifetime.TextColor3 = Color3.fromRGB(235, 240, 255)
	textLifetime.Font = Enum.Font.SourceSansBold
	textLifetime.TextSize = 19
	textLifetime.TextXAlignment = Enum.TextXAlignment.Left
	textLifetime.TextYAlignment = Enum.TextYAlignment.Top
	textLifetime.BackgroundTransparency = 1
	textLifetime.Parent = cardLifetime

	-- ABA 5: REBIRTH
	local contentRebirth = Instance.new("Frame")
	contentRebirth.Size = UDim2.new(0.58, 0, 0.78, 0)
	contentRebirth.Position = UDim2.new(0.21, 0, 0.11, 10)
	contentRebirth.BackgroundColor3 = Color3.fromRGB(22, 26, 38)
	contentRebirth.BorderSizePixel = 0
	contentRebirth.Visible = false
	contentRebirth.Parent = mainFrame
	addCorner(contentRebirth, 12)
	addStroke(contentRebirth, Color3.fromRGB(245, 165, 35), 1.5, 0.3)
	telasConteudo["🚀 Rebirth"] = contentRebirth

	local rebirthTitle = Instance.new("TextLabel")
	rebirthTitle.Size = UDim2.new(1, 0, 0, 50)
	rebirthTitle.Position = UDim2.new(0, 0, 0, 15)
	rebirthTitle.Text = "🚀 REBIRTH"
	rebirthTitle.TextColor3 = Color3.fromRGB(255, 185, 45)
	rebirthTitle.Font = Enum.Font.FredokaOne
	rebirthTitle.TextSize = 28
	rebirthTitle.TextXAlignment = Enum.TextXAlignment.Center
	rebirthTitle.BackgroundTransparency = 1
	rebirthTitle.Parent = contentRebirth

	local rebirthDesc = Instance.new("TextLabel")
	rebirthDesc.Size = UDim2.new(1, -50, 0, 150)
	rebirthDesc.Position = UDim2.new(0, 25, 0, 75)
	rebirthDesc.Text = "Reinicie sua jornada financeira para alcançar patamares globais ainda maiores!\n\n"
		.. "✨ **O que você ganha:** +25% de bônus permanente em todos os seus ganhos por cada Rebirth.\n"
		.. "🛡️ **O que é mantido:** Suas Corretoras contratadas continuam ativas (dando bônus nos FIIs e Bens!)\n"
		.. "🔄 **O que reseta:** Saldo, portfólio de ativos e bens comprados."
	rebirthDesc.TextColor3 = Color3.fromRGB(225, 230, 245)
	rebirthDesc.Font = Enum.Font.SourceSansBold
	rebirthDesc.TextSize = 18
	rebirthDesc.TextWrapped = true
	rebirthDesc.TextXAlignment = Enum.TextXAlignment.Left
	rebirthDesc.TextYAlignment = Enum.TextYAlignment.Top
	rebirthDesc.BackgroundTransparency = 1
	rebirthDesc.Parent = contentRebirth

	local lblStatusRebirth = Instance.new("TextLabel")
	lblStatusRebirth.Size = UDim2.new(1, -40, 0, 45)
	lblStatusRebirth.Position = UDim2.new(0, 20, 0, 240)
	lblStatusRebirth.Text = "Nível Atual: 0 | Bônus Global: +0%"
	lblStatusRebirth.TextColor3 = Color3.fromRGB(0, 230, 130)
	lblStatusRebirth.Font = Enum.Font.FredokaOne
	lblStatusRebirth.TextSize = 22
	lblStatusRebirth.TextXAlignment = Enum.TextXAlignment.Center
	lblStatusRebirth.BackgroundTransparency = 1
	lblStatusRebirth.Parent = contentRebirth

	local btnRebirth = Instance.new("TextButton")
	btnRebirth.Size = UDim2.new(0.85, 0, 0, 54)
	btnRebirth.Position = UDim2.new(0.075, 0, 1, -75)
	btnRebirth.BackgroundColor3 = Color3.fromRGB(245, 165, 35)
	btnRebirth.Text = "EXECUTAR REBIRTH (Custo: $100.0K)"
	btnRebirth.TextColor3 = Color3.fromRGB(20, 20, 25)
	btnRebirth.Font = Enum.Font.FredokaOne
	btnRebirth.TextSize = 18
	btnRebirth.BorderSizePixel = 0
	btnRebirth.Parent = contentRebirth
	addCorner(btnRebirth, 8)
	addGradient(btnRebirth, Color3.fromRGB(255, 195, 55), Color3.fromRGB(220, 135, 20))

	-- Lógica de Alternância das Abas
	local abaAtiva = "Investimentos"
	for i, nomeAba in ipairs(abas) do
		local btnNav = Instance.new("TextButton")
		btnNav.Size = UDim2.new(0, 130, 0, 38)
		btnNav.Position = UDim2.new(0, (i - 1) * 135, 0, 2)
		btnNav.BackgroundColor3 = (i == 1) and Color3.fromRGB(0, 180, 105) or Color3.fromRGB(32, 38, 54)
		btnNav.Text = nomeAba
		btnNav.TextColor3 = Color3.fromRGB(255, 255, 255)
		btnNav.Font = Enum.Font.FredokaOne
		btnNav.TextSize = 12
		btnNav.BorderSizePixel = 0
		btnNav.Parent = navContainer
		addCorner(btnNav, 8)
		addStroke(btnNav, Color3.fromRGB(60, 70, 95), 1, 0.5)

		botoesAbas[nomeAba] = btnNav

		btnNav.MouseEnter:Connect(function()
			if abaAtiva ~= nomeAba then btnNav.BackgroundColor3 = Color3.fromRGB(0, 210, 120) end
		end)
		btnNav.MouseLeave:Connect(function()
			if abaAtiva == nomeAba then
				btnNav.BackgroundColor3 = Color3.fromRGB(0, 180, 105)
			else
				btnNav.BackgroundColor3 = Color3.fromRGB(32, 38, 54)
			end
		end)
		btnNav.MouseButton1Click:Connect(function()
			abaAtiva = nomeAba
			for n, b in pairs(botoesAbas) do
				b.BackgroundColor3 = (n == abaAtiva) and Color3.fromRGB(0, 180, 105) or Color3.fromRGB(32, 38, 54)
			end
			for n, t in pairs(telasConteudo) do t.Visible = false end
			telasConteudo[nomeAba].Visible = true
		end)
	end

	-- ------------------------------------------------------------------------
	-- CONSTRUÇÃO DA ABA 1 (MERCADO & PORTFÓLIO)
	-- ------------------------------------------------------------------------
	local qtdCompra = 1
	local qtdVenda = 1

	-- Filtros do Mercado
	local marketFilterBar = Instance.new("Frame")
	marketFilterBar.Size = UDim2.new(0.48, -20, 0, 32)
	marketFilterBar.Position = UDim2.new(0, 15, 0, 10)
	marketFilterBar.BackgroundTransparency = 1
	marketFilterBar.Parent = contentInvestimentos

	local filtroMercadoAtual = "TODOS"
	local marketCardsFrames = {}

	local function atualizarFiltroMercado()
		for nome, dadosCard in pairs(marketCardsFrames) do
			dadosCard.Card.Visible = (filtroMercadoAtual == "TODOS" or dadosCard.Tipo == filtroMercadoAtual)
		end
	end

	local filtrosM = {"TODOS", "FII", "Stock"}
	for i, fName in ipairs(filtrosM) do
		local btnF = Instance.new("TextButton")
		btnF.Size = UDim2.new(0, 80, 1, 0)
		btnF.Position = UDim2.new(0, (i - 1) * 86, 0, 0)
		btnF.BackgroundColor3 = (fName == "TODOS") and Color3.fromRGB(0, 180, 105) or Color3.fromRGB(32, 38, 54)
		btnF.Text = fName
		btnF.TextColor3 = Color3.fromRGB(255, 255, 255)
		btnF.Font = Enum.Font.FredokaOne
		btnF.TextSize = 12
		btnF.BorderSizePixel = 0
		btnF.Parent = marketFilterBar
		addCorner(btnF, 6)

		btnF.MouseButton1Click:Connect(function()
			for _, child in ipairs(marketFilterBar:GetChildren()) do
				if child:IsA("TextButton") then child.BackgroundColor3 = Color3.fromRGB(32, 38, 54) end
			end
			btnF.BackgroundColor3 = Color3.fromRGB(0, 180, 105)
			filtroMercadoAtual = fName
			atualizarFiltroMercado()
		end)
	end

	-- ScrollingFrame de Mercado
	local marketFrame = Instance.new("ScrollingFrame")
	marketFrame.Size = UDim2.new(0.48, -20, 1, -115)
	marketFrame.Position = UDim2.new(0, 15, 0, 48)
	marketFrame.BackgroundColor3 = Color3.fromRGB(20, 24, 34)
	marketFrame.BorderSizePixel = 0
	marketFrame.CanvasSize = UDim2.new(0, 0, 0, #marketAssets * 98)
	marketFrame.ScrollBarThickness = 6
	marketFrame.Parent = contentInvestimentos
	addCorner(marketFrame, 10)
	addStroke(marketFrame)

	local layoutMercado = Instance.new("UIListLayout")
	layoutMercado.Padding = UDim.new(0, 10)
	layoutMercado.Parent = marketFrame
	local paddingMercado = Instance.new("UIPadding")
	paddingMercado.PaddingTop = UDim.new(0, 12)
	paddingMercado.PaddingLeft = UDim.new(0, 12)
	paddingMercado.PaddingRight = UDim.new(0, 12)
	paddingMercado.Parent = marketFrame

	-- Controls de Mercado (Lote Compra)
	local marketControlBar = Instance.new("Frame")
	marketControlBar.Size = UDim2.new(0.48, -20, 0, 45)
	marketControlBar.Position = UDim2.new(0, 15, 1, -55)
	marketControlBar.BackgroundColor3 = Color3.fromRGB(24, 29, 42)
	marketControlBar.BorderSizePixel = 0
	marketControlBar.Parent = contentInvestimentos
	addCorner(marketControlBar, 8)
	addStroke(marketControlBar)

	local lblBuyText = Instance.new("TextLabel")
	lblBuyText.Size = UDim2.new(0, 75, 1, 0)
	lblBuyText.Position = UDim2.new(0, 12, 0, 0)
	lblBuyText.Text = "Comprar:"
	lblBuyText.TextColor3 = Color3.fromRGB(220, 220, 230)
	lblBuyText.Font = Enum.Font.FredokaOne
	lblBuyText.TextSize = 13
	lblBuyText.TextXAlignment = Enum.TextXAlignment.Left
	lblBuyText.BackgroundTransparency = 1
	lblBuyText.Parent = marketControlBar

	-- Dual-Filtro do Portfólio (Vendas)
	local portfolioFilterBar = Instance.new("Frame")
	portfolioFilterBar.Size = UDim2.new(0.48, -10, 0, 32)
	portfolioFilterBar.Position = UDim2.new(0.5, 5, 0, 10)
	portfolioFilterBar.BackgroundTransparency = 1
	portfolioFilterBar.Parent = contentInvestimentos

	local filtroStatusVendas = "TUDO"
	local filtroTipoVendas = "TUDO"
	local portfolioCardsFrames = {}

	local function atualizarFiltroPortfolio()
		for _, dadosCard in pairs(portfolioCardsFrames) do
			local qtd = dadosCard.GetQtd()
			local tipo = dadosCard.Tipo
			local passaStatus = (filtroStatusVendas == "TUDO") or (filtroStatusVendas == "COMPRADOS" and qtd > 0)
			local passaTipo = (filtroTipoVendas == "TUDO") or (filtroTipoVendas == tipo)
			dadosCard.Card.Visible = passaStatus and passaTipo
		end
	end

	-- Grupo Filtro Status
	local statusButtons = {}
	local opcoesStatus = {{Nome = "Tudo", Filtro = "TUDO", Width = 50}, {Nome = "Comprados", Filtro = "COMPRADOS", Width = 80}}
	local posXLeft = 0
	for _, opt in ipairs(opcoesStatus) do
		local btnS = Instance.new("TextButton")
		btnS.Size = UDim2.new(0, opt.Width, 1, 0)
		btnS.Position = UDim2.new(0, posXLeft, 0, 0)
		btnS.BackgroundColor3 = (opt.Filtro == "TUDO") and Color3.fromRGB(235, 60, 80) or Color3.fromRGB(32, 38, 54)
		btnS.Text = opt.Nome
		btnS.TextColor3 = Color3.fromRGB(255, 255, 255)
		btnS.Font = Enum.Font.FredokaOne
		btnS.TextSize = 11
		btnS.BorderSizePixel = 0
		btnS.Parent = portfolioFilterBar
		addCorner(btnS, 6)
		statusButtons[opt.Filtro] = btnS

		btnS.MouseButton1Click:Connect(function()
			for _, b in pairs(statusButtons) do b.BackgroundColor3 = Color3.fromRGB(32, 38, 54) end
			btnS.BackgroundColor3 = Color3.fromRGB(235, 60, 80)
			filtroStatusVendas = opt.Filtro
			atualizarFiltroPortfolio()
		end)
		posXLeft = posXLeft + opt.Width + 5
	end

	-- Grupo Filtro Tipo
	local typeButtons = {}
	local opcoesTipo = {{Nome = "Tudo", Filtro = "TUDO", Width = 50}, {Nome = "FIIs", Filtro = "FII", Width = 50}, {Nome = "Ações", Filtro = "Stock", Width = 55}}
	local posXRight = 165
	for _, opt in ipairs(opcoesTipo) do
		local btnT = Instance.new("TextButton")
		btnT.Size = UDim2.new(0, opt.Width, 1, 0)
		btnT.Position = UDim2.new(0, posXRight, 0, 0)
		btnT.BackgroundColor3 = (opt.Filtro == "TUDO") and Color3.fromRGB(0, 180, 105) or Color3.fromRGB(32, 38, 54)
		btnT.Text = opt.Nome
		btnT.TextColor3 = Color3.fromRGB(255, 255, 255)
		btnT.Font = Enum.Font.FredokaOne
		btnT.TextSize = 11
		btnT.BorderSizePixel = 0
		btnT.Parent = portfolioFilterBar
		addCorner(btnT, 6)
		typeButtons[opt.Filtro] = btnT

		btnT.MouseButton1Click:Connect(function()
			for _, b in pairs(typeButtons) do b.BackgroundColor3 = Color3.fromRGB(32, 38, 54) end
			btnT.BackgroundColor3 = Color3.fromRGB(0, 180, 105)
			filtroTipoVendas = opt.Filtro
			atualizarFiltroPortfolio()
		end)
		posXRight = posXRight + opt.Width + 5
	end

	-- ScrollingFrame do Portfólio
	local portfolioFrame = Instance.new("ScrollingFrame")
	portfolioFrame.Size = UDim2.new(0.48, -10, 1, -115)
	portfolioFrame.Position = UDim2.new(0.5, 5, 0, 48)
	portfolioFrame.BackgroundColor3 = Color3.fromRGB(20, 24, 34)
	portfolioFrame.BorderSizePixel = 0
	portfolioFrame.CanvasSize = UDim2.new(0, 0, 0, #marketAssets * 98)
	portfolioFrame.ScrollBarThickness = 6
	portfolioFrame.Parent = contentInvestimentos
	addCorner(portfolioFrame, 10)
	addStroke(portfolioFrame)

	local layoutPortfolio = Instance.new("UIListLayout")
	layoutPortfolio.Padding = UDim.new(0, 10)
	layoutPortfolio.Parent = portfolioFrame
	local paddingPortfolio = Instance.new("UIPadding")
	paddingPortfolio.PaddingTop = UDim.new(0, 12)
	paddingPortfolio.PaddingLeft = UDim.new(0, 12)
	paddingPortfolio.PaddingRight = UDim.new(0, 12)
	paddingPortfolio.Parent = portfolioFrame

	-- Controls do Portfólio (Lote Venda)
	local portfolioControlBar = Instance.new("Frame")
	portfolioControlBar.Size = UDim2.new(0.48, -10, 0, 45)
	portfolioControlBar.Position = UDim2.new(0.5, 5, 1, -55)
	portfolioControlBar.BackgroundColor3 = Color3.fromRGB(24, 29, 42)
	portfolioControlBar.BorderSizePixel = 0
	portfolioControlBar.Parent = contentInvestimentos
	addCorner(portfolioControlBar, 8)
	addStroke(portfolioControlBar)

	local lblSellText = Instance.new("TextLabel")
	lblSellText.Size = UDim2.new(0, 75, 1, 0)
	lblSellText.Position = UDim2.new(0, 12, 0, 0)
	lblSellText.Text = "Vender:"
	lblSellText.TextColor3 = Color3.fromRGB(220, 220, 230)
	lblSellText.Font = Enum.Font.FredokaOne
	lblSellText.TextSize = 13
	lblSellText.TextXAlignment = Enum.TextXAlignment.Left
	lblSellText.BackgroundTransparency = 1
	lblSellText.Parent = portfolioControlBar

	-- Helper para Botões de Lote (1, 10, 100, Tudo)
	local function criarBotoesLote(parentBar, tipo)
		local opcoes = {1, 10, 100, "Tudo"}
		local botoes = {}
		local posX = 82

		for _, v in ipairs(opcoes) do
			local larguraBtn = (v == "Tudo") and 52 or 36
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(0, larguraBtn, 0, 30)
			btn.Position = UDim2.new(0, posX, 0.5, -15)
			btn.BackgroundColor3 = (v == 1) and (tipo == "Compra" and Color3.fromRGB(0, 180, 105) or Color3.fromRGB(235, 60, 80)) or Color3.fromRGB(38, 44, 62)
			btn.Text = tostring(v)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.Font = Enum.Font.FredokaOne
			btn.TextSize = (v == "Tudo") and 11 or 12
			btn.BorderSizePixel = 0
			btn.Parent = parentBar
			botoes[v] = btn
			addCorner(btn, 6)

			btn.MouseButton1Click:Connect(function()
				for _, b in pairs(botoes) do b.BackgroundColor3 = Color3.fromRGB(38, 44, 62) end
				btn.BackgroundColor3 = (tipo == "Compra") and Color3.fromRGB(0, 180, 105) or Color3.fromRGB(235, 60, 80)
				if tipo == "Compra" then qtdCompra = v else qtdVenda = v end
			end)
			posX = posX + larguraBtn + 5
		end
	end

	criarBotoesLote(marketControlBar, "Compra")
	criarBotoesLote(portfolioControlBar, "Venda")

	-- Gerador de Cards de Mercado e Venda
	local assetCardsUI = {}
	local portfolioCardsUI = {}

	for _, ativo in ipairs(marketAssets) do
		-- Card de Compra (Mercado)
		local card = Instance.new("Frame")
		card.Size = UDim2.new(1, 0, 0, 88)
		card.BackgroundColor3 = Color3.fromRGB(28, 33, 48)
		card.BorderSizePixel = 0
		card.Parent = marketFrame
		addCorner(card, 8)
		addStroke(card)

		marketCardsFrames[ativo.Nome] = {Card = card, Tipo = ativo.Tipo}

		local nomeAtivo = Instance.new("TextLabel")
		nomeAtivo.Size = UDim2.new(0.55, 0, 0.35, 0)
		nomeAtivo.Position = UDim2.new(0, 12, 0, 6)
		nomeAtivo.Text = ativo.Nome .. " (" .. ativo.Tipo .. ")"
		nomeAtivo.TextColor3 = Color3.fromRGB(255, 255, 255)
		nomeAtivo.Font = Enum.Font.FredokaOne
		nomeAtivo.TextSize = 14
		nomeAtivo.TextXAlignment = Enum.TextXAlignment.Left
		nomeAtivo.BackgroundTransparency = 1
		nomeAtivo.Parent = card

		local infoAtivo = Instance.new("TextLabel")
		infoAtivo.Size = UDim2.new(0.55, 0, 0.55, 0)
		infoAtivo.Position = UDim2.new(0, 12, 0.35, 0)
		infoAtivo.TextColor3 = Color3.fromRGB(190, 195, 210)
		infoAtivo.Font = Enum.Font.SourceSans
		infoAtivo.TextSize = 13
		infoAtivo.TextXAlignment = Enum.TextXAlignment.Left
		infoAtivo.BackgroundTransparency = 1
		infoAtivo.Parent = card

		local variacaoLabel = Instance.new("TextLabel")
		variacaoLabel.Size = UDim2.new(0, 90, 0, 45)
		variacaoLabel.Position = UDim2.new(0.56, 0, 0.22, 0)
		variacaoLabel.TextSize = 15
		variacaoLabel.Font = Enum.Font.FredokaOne
		variacaoLabel.TextXAlignment = Enum.TextXAlignment.Center
		variacaoLabel.BackgroundTransparency = 1
		variacaoLabel.Parent = card

		local pct = variacaoPercentual(ativo)
		variacaoLabel.Text = formatarNumero(pct, 1, true) .. "%"
		variacaoLabel.TextColor3 = pct >= 0 and Color3.fromRGB(0, 240, 130) or Color3.fromRGB(255, 90, 90)
		infoAtivo.Text = textoInfoAtivo(ativo)

		-- Botão de Compra em destaque
		local btnComprar = Instance.new("TextButton")
		btnComprar.Size = UDim2.new(0.24, -5, 0.68, 0)
		btnComprar.Position = UDim2.new(0.74, 0, 0.16, 0)
		btnComprar.BackgroundColor3 = Color3.fromRGB(0, 160, 90)
		btnComprar.Text = "COMPRAR"
		btnComprar.TextColor3 = Color3.fromRGB(255, 255, 255)
		btnComprar.Font = Enum.Font.FredokaOne
		btnComprar.TextSize = 14
		btnComprar.BorderSizePixel = 0
		btnComprar.Parent = card
		addCorner(btnComprar, 6)
		addStroke(btnComprar, Color3.fromRGB(255, 255, 255), 1, 0.4)

		assetCardsUI[ativo.Nome] = {Info = infoAtivo, Variacao = variacaoLabel}

		-- Card de Venda (Portfólio)
		local pCard = Instance.new("Frame")
		pCard.Size = UDim2.new(1, 0, 0, 88)
		pCard.BackgroundColor3 = Color3.fromRGB(28, 33, 48)
		pCard.BorderSizePixel = 0
		pCard.Parent = portfolioFrame
		addCorner(pCard, 8)
		addStroke(pCard)

		portfolioCardsFrames[ativo.Nome] = {
			Card = pCard,
			Tipo = ativo.Tipo,
			GetQtd = function() return dados.portfolioQtd[ativo.Nome] end
		}

		local pText = Instance.new("TextLabel")
		pText.Size = UDim2.new(0.65, -10, 1, 0)
		pText.Position = UDim2.new(0, 12, 0, 0)
		pText.Text = ativo.Nome .. "\nQtd: 0 | Pago: " .. formatarMoeda(0) .. " | Atual: " .. formatarMoeda(0)
		pText.TextColor3 = Color3.fromRGB(220, 220, 230)
		pText.Font = Enum.Font.SourceSans
		pText.TextSize = 12
		pText.TextWrapped = true
		pText.TextXAlignment = Enum.TextXAlignment.Left
		pText.BackgroundTransparency = 1
		pText.Parent = pCard

		-- Botão de Venda em destaque
		local btnVender = Instance.new("TextButton")
		btnVender.Size = UDim2.new(0.28, -5, 0.65, 0)
		btnVender.Position = UDim2.new(0.70, 0, 0.18, 0)
		btnVender.BackgroundColor3 = Color3.fromRGB(200, 45, 65)
		btnVender.Text = "VENDER"
		btnVender.TextColor3 = Color3.fromRGB(255, 255, 255)
		btnVender.Font = Enum.Font.FredokaOne
		btnVender.TextSize = 13
		btnVender.BorderSizePixel = 0
		btnVender.Parent = pCard
		addCorner(btnVender, 6)
		addStroke(btnVender, Color3.fromRGB(255, 255, 255), 1, 0.4)

		portfolioCardsUI[ativo.Nome] = pText

		-- Eventos de Transação
		btnComprar.MouseButton1Click:Connect(function()
			local qtdParaComprar = (qtdCompra == "Tudo") and math.floor(dados.saldo / ativo.Preco) or qtdCompra

			if qtdParaComprar > 0 then
				local custoTotal = ativo.Preco * qtdParaComprar
				if dados.saldo >= custoTotal then
					local qtdAtual = dados.portfolioQtd[ativo.Nome]
					local pmAtual = dados.portfolioPrecoMedio[ativo.Nome]

					if qtdAtual == 0 then
						dados.portfolioPrecoMedio[ativo.Nome] = ativo.Preco
					else
						dados.portfolioPrecoMedio[ativo.Nome] = ((pmAtual * qtdAtual) + (ativo.Preco * qtdParaComprar)) / (qtdAtual + qtdParaComprar)
					end

					dados.portfolioQtd[ativo.Nome] = qtdAtual + qtdParaComprar
					dados.saldo = dados.saldo - custoTotal
					atualizarFiltroPortfolio()
				end
			end
		end)

		btnVender.MouseButton1Click:Connect(function()
			local qtdDisponivel = dados.portfolioQtd[ativo.Nome]
			local qtdParaVender = (qtdVenda == "Tudo") and qtdDisponivel or math.min(qtdVenda, qtdDisponivel)

			if qtdParaVender > 0 then
				local valorVenda = ativo.Preco * qtdParaVender
				local valorPago = dados.portfolioPrecoMedio[ativo.Nome] * qtdParaVender
				local lucroRealizado = valorVenda - valorPago

				if lucroRealizado > 0 then
					dados.totalGanhoAcoes = dados.totalGanhoAcoes + lucroRealizado
				end

				dados.portfolioQtd[ativo.Nome] = dados.portfolioQtd[ativo.Nome] - qtdParaVender
				dados.saldo = dados.saldo + valorVenda

				if dados.portfolioQtd[ativo.Nome] == 0 then
					dados.portfolioPrecoMedio[ativo.Nome] = 0.00
				end

				atualizarFiltroPortfolio()
			end
		end)
	end

	atualizarFiltroPortfolio()

	-- ------------------------------------------------------------------------
	-- CONSTRUÇÃO DA ABA 2 (BENS & ESTILO DE VIDA - COM 110 ITENS NO TOTAL)
	-- ------------------------------------------------------------------------
	local bensCardsUI = {}

	for _, bem in ipairs(lifestyleGoods) do
		local cardBem = Instance.new("Frame")
		cardBem.Size = UDim2.new(1, 0, 0, 70)
		cardBem.BackgroundColor3 = Color3.fromRGB(28, 33, 48)
		cardBem.BorderSizePixel = 0
		cardBem.Parent = contentBens
		addCorner(cardBem, 8)
		addStroke(cardBem)

		local nomeBem = Instance.new("TextLabel")
		nomeBem.Size = UDim2.new(0.6, 0, 0.5, 0)
		nomeBem.Position = UDim2.new(0, 15, 0, 8)
		nomeBem.Text = bem.Nome
		nomeBem.TextColor3 = Color3.fromRGB(255, 255, 255)
		nomeBem.Font = Enum.Font.FredokaOne
		nomeBem.TextSize = 15
		nomeBem.TextXAlignment = Enum.TextXAlignment.Left
		nomeBem.BackgroundTransparency = 1
		nomeBem.Parent = cardBem

		local precoBem = Instance.new("TextLabel")
		precoBem.Size = UDim2.new(0.6, 0, 0.4, 0)
		precoBem.Position = UDim2.new(0, 15, 0.5, 0)
		precoBem.Text = "Preço: " .. formatarMoeda(bem.Preco) .. " | Renda (20%): +" .. formatarMoeda(bem.Preco * 0.20) .. " a cada 5s"
		precoBem.TextColor3 = Color3.fromRGB(190, 195, 210)
		precoBem.Font = Enum.Font.SourceSans
		precoBem.TextSize = 13
		precoBem.TextXAlignment = Enum.TextXAlignment.Left
		precoBem.BackgroundTransparency = 1
		precoBem.Parent = cardBem

		local btnComprarBem = Instance.new("TextButton")
		btnComprarBem.Size = UDim2.new(0.28, -10, 0.62, 0)
		btnComprarBem.Position = UDim2.new(0.70, 0, 0.19, 0)
		btnComprarBem.BackgroundColor3 = Color3.fromRGB(0, 160, 90)
		btnComprarBem.Text = "COMPRAR"
		btnComprarBem.TextColor3 = Color3.fromRGB(255, 255, 255)
		btnComprarBem.Font = Enum.Font.FredokaOne
		btnComprarBem.TextSize = 13
		btnComprarBem.BorderSizePixel = 0
		btnComprarBem.Parent = cardBem
		addCorner(btnComprarBem, 6)
		addStroke(btnComprarBem, Color3.fromRGB(255, 255, 255), 1, 0.4)

		bensCardsUI[bem.Nome] = btnComprarBem

		if dados.bensComprados[bem.Nome] then
			btnComprarBem.Text = "ADQUIRIDO"
			btnComprarBem.BackgroundColor3 = Color3.fromRGB(60, 68, 85)
		end

		btnComprarBem.MouseButton1Click:Connect(function()
			if not dados.bensComprados[bem.Nome] and dados.saldo >= bem.Preco then
				dados.saldo = dados.saldo - bem.Preco
				dados.bensComprados[bem.Nome] = true
				btnComprarBem.Text = "ADQUIRIDO"
				btnComprarBem.BackgroundColor3 = Color3.fromRGB(60, 68, 85)
			end
		end)
	end

	-- Função de atualização visual da lista de Bens após o Rebirth
	local function atualizarUIBens()
		for _, bem in ipairs(lifestyleGoods) do
			local btn = bensCardsUI[bem.Nome]
			if btn then
				if dados.bensComprados[bem.Nome] then
					btn.Text = "ADQUIRIDO"
					btn.BackgroundColor3 = Color3.fromRGB(60, 68, 85)
				else
					btn.Text = "COMPRAR"
					btn.BackgroundColor3 = Color3.fromRGB(0, 160, 90)
				end
			end
		end
	end

	-- ------------------------------------------------------------------------
	-- CONSTRUÇÃO DA ABA 3 (CORRETORAS - COM 78 ITENS NO TOTAL)
	-- ------------------------------------------------------------------------
	for _, corretora in ipairs(brokerageList) do
		local cardCorretora = Instance.new("Frame")
		cardCorretora.Size = UDim2.new(1, 0, 0, 70)
		cardCorretora.BackgroundColor3 = Color3.fromRGB(28, 33, 48)
		cardCorretora.BorderSizePixel = 0
		cardCorretora.Parent = contentCorretoras
		addCorner(cardCorretora, 8)
		addStroke(cardCorretora)

		local nomeCorretora = Instance.new("TextLabel")
		nomeCorretora.Size = UDim2.new(0.6, 0, 0.5, 0)
		nomeCorretora.Position = UDim2.new(0, 15, 0, 8)
		nomeCorretora.Text = "💼 Corretora " .. corretora.Nome
		nomeCorretora.TextColor3 = Color3.fromRGB(255, 255, 255)
		nomeCorretora.Font = Enum.Font.FredokaOne
		nomeCorretora.TextSize = 15
		nomeCorretora.TextXAlignment = Enum.TextXAlignment.Left
		nomeCorretora.BackgroundTransparency = 1
		nomeCorretora.Parent = cardCorretora

		local infoCorretora = Instance.new("TextLabel")
		infoCorretora.Size = UDim2.new(0.6, 0, 0.4, 0)
		infoCorretora.Position = UDim2.new(0, 15, 0.5, 0)
		infoCorretora.Text = "Preço: " .. formatarMoeda(corretora.Preco) .. " | Bônus (FII & Bens): +" .. formatarNumero(corretora.Bonus * 100, 0) .. "%"
		infoCorretora.TextColor3 = Color3.fromRGB(190, 195, 210)
		infoCorretora.Font = Enum.Font.SourceSans
		infoCorretora.TextSize = 13
		infoCorretora.TextXAlignment = Enum.TextXAlignment.Left
		infoCorretora.BackgroundTransparency = 1
		infoCorretora.Parent = cardCorretora

		local btnComprarCorretora = Instance.new("TextButton")
		btnComprarCorretora.Size = UDim2.new(0.28, -10, 0.62, 0)
		btnComprarCorretora.Position = UDim2.new(0.70, 0, 0.19, 0)
		btnComprarCorretora.BackgroundColor3 = Color3.fromRGB(0, 160, 90)
		btnComprarCorretora.Text = "CONTRATAR"
		btnComprarCorretora.TextColor3 = Color3.fromRGB(255, 255, 255)
		btnComprarCorretora.Font = Enum.Font.FredokaOne
		btnComprarCorretora.TextSize = 13
		btnComprarCorretora.BorderSizePixel = 0
		btnComprarCorretora.Parent = cardCorretora
		addCorner(btnComprarCorretora, 6)
		addStroke(btnComprarCorretora, Color3.fromRGB(255, 255, 255), 1, 0.4)

		if dados.corretorasCompradas[corretora.Nome] then
			btnComprarCorretora.Text = "CONTRATADA"
			btnComprarCorretora.BackgroundColor3 = Color3.fromRGB(60, 68, 85)
		end

		btnComprarCorretora.MouseButton1Click:Connect(function()
			if not dados.corretorasCompradas[corretora.Nome] and dados.saldo >= corretora.Preco then
				dados.saldo = dados.saldo - corretora.Preco
				dados.corretorasCompradas[corretora.Nome] = true
				btnComprarCorretora.Text = "CONTRATADA"
				btnComprarCorretora.BackgroundColor3 = Color3.fromRGB(60, 68, 85)
			end
		end)
	end

	-- Lógica do Botão de Rebirth
	local custoRebirthBase = 100000.00 
	local function calcularCustoRebirth(nivel)
		return custoRebirthBase * math.pow(3.5, nivel)
	end

	local function atualizarUIRebirth()
		local custoAtual = calcularCustoRebirth(dados.nivelRebirth)
		local bonusGlobal = dados.nivelRebirth * 25
		lblStatusRebirth.Text = "Nível Atual: " .. dados.nivelRebirth .. " | Bônus Global: +" .. bonusGlobal .. "%"
		btnRebirth.Text = "EXECUTAR REBIRTH (Custo: " .. formatarMoeda(custoAtual) .. ")"
	end

	atualizarUIRebirth()

	btnRebirth.MouseButton1Click:Connect(function()
		local custoAtual = calcularCustoRebirth(dados.nivelRebirth)
		if dados.saldo >= custoAtual then
			dados.nivelRebirth = dados.nivelRebirth + 1
			dados.saldo = 5.00
			dados.totalGanhoFII = 0.00
			dados.totalGanhoBens = 0.00
			dados.totalGanhoAcoes = 0.00
			dados.tempoBensSegundos = 0
			dados.tempoFIIsSegundos = 0

			for _, ativo in ipairs(marketAssets) do
				dados.portfolioQtd[ativo.Nome] = 0
				dados.portfolioPrecoMedio[ativo.Nome] = 0.00
			end
			for _, bem in ipairs(lifestyleGoods) do
				dados.bensComprados[bem.Nome] = false
			end

			atualizarUIRebirth()
			atualizarFiltroPortfolio()
			atualizarUIBens()
		end
	end)

	-- Registro das Referências na Tabela UI do Jogador
	playerUIs[player] = {
		assetCardsUI = assetCardsUI,
		portfolioCardsUI = portfolioCardsUI,
		saldoText = saldoText,
		textFIIs = textFIIs,
		textBens = textBens,
		textLifetime = textLifetime,
		bannerNoticia = bannerNoticia,
		lblTimerBens = lblTimerBens,
		dados = dados
	}

	-- ------------------------------------------------------------------------
	-- LOOP DE RENDIMENTO DO JOGADOR (1 SEGUNDO)
	-- ------------------------------------------------------------------------
	task.spawn(function()
		while screenGui.Parent do
			task.wait(1)

			local multiplicadorRebirth = 1 + (dados.nivelRebirth * 0.25)

			local somaBonusCorretoras = 0
			for _, corretora in ipairs(brokerageList) do
				if dados.corretorasCompradas[corretora.Nome] then
					somaBonusCorretoras = somaBonusCorretoras + corretora.Bonus
				end
			end
			local multiplicadorCorretoras = 1 + somaBonusCorretoras

			-- 1. FIIs pagando a cada 1 segundo (INTERVALO_FIIS_SEGUNDOS = 1)
			dados.tempoFIIsSegundos = dados.tempoFIIsSegundos + 1

			if dados.tempoFIIsSegundos >= INTERVALO_FIIS_SEGUNDOS then
				dados.tempoFIIsSegundos = 0
				local lucroFIIsBase = 0
				for _, ativo in ipairs(marketAssets) do
					local qtd = dados.portfolioQtd[ativo.Nome]
					if qtd > 0 and ativo.Tipo == "FII" then
						lucroFIIsBase = lucroFIIsBase + ((ativo.Preco * ativo.CurrentYield) * qtd)
					end
				end

				local pagamentoFIIsLote = (lucroFIIsBase * multiplicadorCorretoras * multiplicadorNoticia * multiplicadorRebirth) * INTERVALO_FIIS_SEGUNDOS
				dados.totalGanhoFII = dados.totalGanhoFII + pagamentoFIIsLote
				dados.saldo = dados.saldo + pagamentoFIIsLote
			end

			-- Estimativa visual do lucro por segundo para o Display
			local lucroFIIsBaseVisual = 0
			for _, ativo in ipairs(marketAssets) do
				local qtd = dados.portfolioQtd[ativo.Nome]
				if qtd > 0 and ativo.Tipo == "FII" then
					lucroFIIsBaseVisual = lucroFIIsBaseVisual + ((ativo.Preco * ativo.CurrentYield) * qtd)
				end
			end
			local lucroFIIsLiquidoSeg = (lucroFIIsBaseVisual * multiplicadorCorretoras * multiplicadorNoticia * multiplicadorRebirth)

			-- 2. Renda Passiva dos Bens (a cada 5s / 20% do valor do bem + Corretoras + Rebirth)
			dados.tempoBensSegundos = dados.tempoBensSegundos + 1
			local tempoRestante = INTERVALO_BENS_SEGUNDOS - dados.tempoBensSegundos

			local valorTotalBens = 0
			for _, bem in ipairs(lifestyleGoods) do
				if dados.bensComprados[bem.Nome] then
					valorTotalBens = valorTotalBens + bem.Preco
				end
			end
			local proximoPagamentoBens = (valorTotalBens * 0.20) * multiplicadorCorretoras * multiplicadorRebirth

			if dados.tempoBensSegundos >= INTERVALO_BENS_SEGUNDOS then
				dados.tempoBensSegundos = 0
				if proximoPagamentoBens > 0 then
					dados.saldo = dados.saldo + proximoPagamentoBens
					dados.totalGanhoBens = dados.totalGanhoBens + proximoPagamentoBens
				end
			end

			lblTimerBens.Text = "⏱️ Próximo Pagamento dos Bens: " .. formatarTempo(math.max(0, tempoRestante)) .. " | Valor: +" .. formatarMoeda(proximoPagamentoBens)

			-- 3. Atualização dos Cards do Portfólio
			for _, ativo in ipairs(marketAssets) do
				local qtd = dados.portfolioQtd[ativo.Nome]
				local labelPort = portfolioCardsUI[ativo.Nome]
				if labelPort then
					if qtd > 0 then
						local valorPagoTotal = dados.portfolioPrecoMedio[ativo.Nome] * qtd
						local valorAtualTotal = ativo.Preco * qtd
						local lucroPotencial = valorAtualTotal - valorPagoTotal
						local linhaQtd = "Qtd: " .. formatarNumero(qtd, 0) .. " | Pago: " .. formatarMoeda(valorPagoTotal) .. " | Atual: " .. formatarMoeda(valorAtualTotal)

						if ativo.Tipo == "FII" then
							local rendimentoTotalFII = (((ativo.Preco * ativo.CurrentYield) * qtd) * multiplicadorCorretoras * multiplicadorNoticia * multiplicadorRebirth)
							labelPort.Text = ativo.Nome .. "\n" .. linhaQtd
								.. "\nRendimento: " .. formatarMoeda(rendimentoTotalFII, 3) .. "/s | Lucro: " .. formatarMoeda(lucroPotencial, 2, true)
						else
							labelPort.Text = ativo.Nome .. "\n" .. linhaQtd
								.. "\nLucro Venda: " .. formatarMoeda(lucroPotencial, 2, true)
						end
						labelPort.TextColor3 = (lucroPotencial >= 0) and Color3.fromRGB(0, 240, 130) or Color3.fromRGB(255, 90, 90)
					else
						labelPort.Text = ativo.Nome .. "\nQtd: 0 | Valor: " .. formatarMoeda(0)
						labelPort.TextColor3 = Color3.fromRGB(220, 220, 230)
					end
				end
			end

			-- 4. Atualização da Interface (Header e Dashboard em Cards)
			local multiplicadorTotal = multiplicadorCorretoras * multiplicadorRebirth * multiplicadorNoticia
			local pctBonusEfetivo = (multiplicadorTotal - 1) * 100

			saldoText.Text = "Saldo: " .. formatarMoeda(dados.saldo)

			textFIIs.Text = "🔥 MULTIPLICADOR TOTAL: " .. formatarNumero(multiplicadorTotal, 2) .. "x (" .. formatarNumero(pctBonusEfetivo, 1, true) .. "%)\n"
				.. "• Rendimento FIIs Líquido: +" .. formatarMoeda(lucroFIIsLiquidoSeg, 3) .. "/s (Pago a cada 1s)\n"
				.. "• Bônus Corretoras: +" .. formatarNumero(somaBonusCorretoras * 100, 0) .. "%\n"
				.. "• Bônus Rebirth (" .. dados.nivelRebirth .. "x): +" .. (dados.nivelRebirth * 25) .. "%\n"
				.. "• Multiplicador Notícias: " .. formatarNumero(multiplicadorNoticia, 1) .. "x"

			textBens.Text = "• Cronômetro: " .. formatarTempo(math.max(0, tempoRestante)) .. "\n"
				.. "• Injeção (20% c/ Corretoras & Rebirth): +" .. formatarMoeda(proximoPagamentoBens)

			textLifetime.Text = "• Faturado FIIs: " .. formatarMoeda(dados.totalGanhoFII) .. "\n"
				.. "• Faturado Bens: " .. formatarMoeda(dados.totalGanhoBens) .. "\n"
				.. "• Lucro Ações: " .. formatarMoeda(dados.totalGanhoAcoes)
		end
	end)
end

-- ============================================================================
-- 7. LOOPS GLOBAIS DE SIMULAÇÃO DO MERCADO & SISTEMA
-- ============================================================================

-- Loop de Oscilação de Ações (a cada 1s)
task.spawn(function()
	while true do
		task.wait(1)
		for _, ativo in ipairs(marketAssets) do
			if ativo.Tipo == "Stock" then
				local precoMinimo = ativo.PrecoBase * 0.30
				local precoMaximo = ativo.PrecoBase * 3.00
				local variacao = math.random(-60, 60) / 1000
				ativo.Preco = math.clamp(ativo.Preco * (1 + variacao), precoMinimo, precoMaximo)

				for _, uiData in pairs(playerUIs) do
					local cardInfo = uiData.assetCardsUI[ativo.Nome]
					if cardInfo then
						cardInfo.Info.Text = textoInfoAtivo(ativo)
						local pctTotal = variacaoPercentual(ativo)
						cardInfo.Variacao.Text = formatarNumero(pctTotal, 1, true) .. "%"
						cardInfo.Variacao.TextColor3 = (pctTotal >= 0) and Color3.fromRGB(0, 240, 130) or Color3.fromRGB(255, 90, 90)
					end
				end
			end
		end
	end
end)

-- Loop de Oscilação de FIIs (a cada 10s)
task.spawn(function()
	while true do
		task.wait(10)
		for _, ativo in ipairs(marketAssets) do
			if ativo.Tipo == "FII" then
				local precoMinimo = ativo.PrecoBase * 0.50
				local precoMaximo = ativo.PrecoBase * 2.00
				local variacao = math.random(-25, 25) / 1000
				ativo.Preco = math.clamp(ativo.Preco * (1 + variacao), precoMinimo, precoMaximo)
				ativo.CurrentYield = math.random(math.floor(ativo.MinYield * 1000), math.floor(ativo.MaxYield * 1000)) / 1000

				for _, uiData in pairs(playerUIs) do
					local cardInfo = uiData.assetCardsUI[ativo.Nome]
					if cardInfo then
						cardInfo.Info.Text = textoInfoAtivo(ativo)
						local pctTotal = variacaoPercentual(ativo)
						cardInfo.Variacao.Text = formatarNumero(pctTotal, 1, true) .. "%"
						cardInfo.Variacao.TextColor3 = (pctTotal >= 0) and Color3.fromRGB(0, 240, 130) or Color3.fromRGB(255, 90, 90)
					end
				end
			end
		end
	end
end)

-- Loop de Notícias Econômicas Globais (a cada 60s)
task.spawn(function()
	while true do
		task.wait(60)
		local noticiaSorteada = noticiasPossiveis[math.random(1, #noticiasPossiveis)]
		noticiaAtual = noticiaSorteada.Texto
		multiplicadorNoticia = noticiaSorteada.Multiplicador

		for _, uiData in pairs(playerUIs) do
			if uiData.bannerNoticia then
				uiData.bannerNoticia.Text = "📢 " .. noticiaAtual
			end
		end
	end
end)

-- Loop de Salvamento Automático (a cada 120s)
task.spawn(function()
	while true do
		task.wait(INTERVALO_AUTOSAVE)
		for player, dados in pairs(playerDataMap) do
			if dados.carregado then
				task.spawn(salvarDados, player, false)
			end
		end
	end
end)

-- ============================================================================
-- 8. GERENCIAMENTO DE CONEXÃO E DESCONEXÃO DE JOGADORES
-- ============================================================================
local function iniciarJogador(player)
	if iniciando[player] then return end
	iniciando[player] = true

	local dados = criarDadosIniciais()

	if successDS and financeDataStore then
		local okLoad, salvo = carregarDados(player)

		if player.Parent ~= Players then
			iniciando[player] = nil
			return
		end

		if okLoad then
			aplicarDadosSalvos(dados, salvo)
			dados.carregado = true
		elseif RunService:IsStudio() then
			warn("[DataStore] Não foi possível carregar o save no Studio. Jogando sem salvar.")
		else
			warn("[DataStore] Falha ao carregar o save de " .. player.Name .. ". Jogador removido para proteger o progresso.")
			iniciando[player] = nil
			player:Kick("Não foi possível carregar o seu progresso agora. Entre novamente em alguns instantes.")
			return
		end
	else
		warn("[DataStore] DataStore indisponível. O progresso não será salvo.")
	end

	playerDataMap[player] = dados
	criarInterface(player, dados)
end

-- Eventos do Servidor
Players.PlayerAdded:Connect(iniciarJogador)

for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(iniciarJogador, player)
end

Players.PlayerRemoving:Connect(function(player)
	playerUIs[player] = nil
	salvarDados(player, true)
	playerDataMap[player] = nil
	iniciando[player] = nil
end)

-- Encerramento do Servidor (Segurança DataStore)
game:BindToClose(function()
	local pendentes = 0
	for player, dados in pairs(playerDataMap) do
		if dados.carregado then
			pendentes = pendentes + 1
			task.spawn(function()
				salvarDados(player, true)
				pendentes = pendentes - 1
			end)
		end
	end

	local inicio = os.clock()
	while pendentes > 0 and os.clock() - inicio < 25 do
		task.wait(0.1)
	end
end)