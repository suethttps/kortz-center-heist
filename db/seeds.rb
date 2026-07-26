# frozen_string_literal: true

# =============================================================================
# Seeds — dados iniciais do Kortz Center Heist
# -----------------------------------------------------------------------------
# Rode com:  bin/rails db:seed
# Ou junto com migrate:  bin/rails db:setup
#
# Fontes consultadas (comunidade / guias, jul/2026):
#   - Beebom: lista de secondary targets e preços
#   - GTA Boom / GameRant: first weekly vs buyer fatigue
#   - Crime Net Gazette / Reddit discussions: takes realistas solo
#
# AVISO: Rockstar pode alterar valores a qualquer patch.
# Este app é um guia de estudo + ferramenta pra crew de amigos.
# =============================================================================

puts ">> Limpando tabelas..."
Target.delete_all
PrepMission.delete_all
EntryPoint.delete_all

# -----------------------------------------------------------------------------
# PRIMARY TARGETS
# A 1ª venda após o reset de quinta paga o valor "boosted".
# Vendas extras na mesma semana caem pra buyer fatigue (~1/4).
# -----------------------------------------------------------------------------
puts ">> Criando primary targets..."

Target.create!(
  name: "La Dernière Débauche",
  kind: "primary",
  location: "Kortz Center Vault",
  first_weekly_payout: 1_925_000, # 1ª run da semana (reset quinta)
  repeat_payout: 481_250,         # buyer fatigue (runs extras)
  bag_weight: 0,                  # alvo de história — sempre sai
  notes: "Alvo obrigatório da história (Mr. Faber). Deve ser VENDIDO — " \
         "não fica em exposição. Setup fee: grátis na 1ª run, GTA$100.000 depois. " \
         "Hard Mode (+10%) se reiniciar em até ~15 min após a ligação do Raf.",
  position: 1
)

Target.create!(
  name: "The Downfall of Rome",
  kind: "primary",
  location: "Kortz Center Vault (rotação semanal)",
  first_weekly_payout: 1_342_000, # reportado em Hard na 1ª venda pós-reset
  repeat_payout: 335_500,
  bag_weight: 0,
  notes: "Pintura rotativa pós-história. Valor Hard Mode na 1ª venda da semana " \
         "confirmado pela comunidade (GTA Boom). Em Normal o valor pode variar.",
  position: 2
)

Target.create!(
  name: "Consumato",
  kind: "primary",
  location: "Kortz Center Vault (rotação semanal)",
  first_weekly_payout: nil, # 1ª venda boosted ainda não consolidada em todas as fontes
  repeat_payout: 308_000,   # Normal, venda adicional na mesma semana
  bag_weight: 0,
  notes: "Rotativa. Valor de repeat Normal (~GTA$308k) confirmado. " \
         "First-weekly boosted ainda gira conforme a semana.",
  position: 3
)

# -----------------------------------------------------------------------------
# SECONDARY TARGETS
# Preços da lista Beebom. bag_weight é uma estimativa didática:
# pinturas grandes ~50% da bolsa; joias/estátuas ocupam bem menos.
# -----------------------------------------------------------------------------
puts ">> Criando secondary targets..."

secondaries = [
  # Vault — as caras (vale priorizar se der)
  ["With Friends Like These", "Vault", 850_000, 50, "Pintura de cofre — alta prioridade"],
  ["Het Gouden Hondje", "Vault", 825_000, 50, "Pintura de cofre — alta prioridade"],
  ["Swingset Study No. LXiX", "Vault", 775_000, 50, "Pintura de cofre"],
  ["The Hunter Becomes The Hunted", "Vault", 750_000, 50, "Pintura de cofre"],

  # Galerias — pinturas médias
  ["Don't Forgo These Blueprints", "2º andar", 150_000, 40, "Galeria superior"],
  ["The Great Circle Back", "2º andar", 145_000, 40, "Galeria 2º andar"],
  ["Cooked", "2º andar", 120_000, 40, "Kircher — 2º andar"],
  ["Venus d'Algernon (Ivory)", "2º andar", 120_000, 35, "Display / escultura"],
  ["Sod Off", "2º andar", 115_000, 40, "Pintura 2º andar"],
  ["The Chief", "1º andar", 110_000, 40, "Galeria 1º andar"],
  ["Orange Crush", "1º andar", 107_500, 40, "Galeria 1º andar"],
  ["Yellow Topaz Gemstone", "2º andar", 107_500, 20, "Joia — leve na bolsa"],
  ["La Duchesse", "1º andar", 105_000, 40, "Galeria 1º andar"],
  ["Do You See Me", "1º andar", 105_000, 40, "Galeria 1º andar"],
  ["Coquard Carcanet (Tanzanite)", "2º andar", 97_500, 15, "Joia"],
  ["Perlino Andalusian", "2º andar", 95_000, 30, "Peça de galeria"],
  ["Fertility Statue (Bronze)", "2º andar", 88_000, 30, "Estátua"],
  ["Meteorite Fragment", "2º andar", 84_000, 20, "Display"],
  ["Memento Non Mori (Emerald)", "Térreo", 77_500, 20, "Joia — térreo"],
  ["Fertility Statue (Ivory)", "1º andar", 62_000, 30, "Estátua"],
  ["Œuf de Coquard décoratif", "Térreo", 54_000, 15, "Ovo decorativo"],
  ["Œuf de Coquard enchanté", "2º andar", 52_000, 15, "Ovo decorativo"],
  ["Antique Bands", "1º andar", 35_000, 10, "Anéis"],
  ["Art Deco Rings", "1º andar", 34_000, 10, "Anéis"],
  ["Antique Rings", "1º andar", 34_000, 10, "Anéis"],
  ["Coquard Rings", "1º andar", 31_000, 10, "Anéis"],
  ["Pharaonic Bangles", "1º andar", 31_000, 10, "Braceletes"],
  ["Byzantine Hoops", "Térreo", 29_000, 10, "Brincos"],
  ["Coquard Bracelets", "2º andar", 29_000, 10, "Braceletes"]
]

secondaries.each_with_index do |(name, location, payout, weight, notes), index|
  Target.create!(
    name: name,
    kind: "secondary",
    location: location,
    first_weekly_payout: payout, # secondary geralmente não muda com a semana
    repeat_payout: payout,
    bag_weight: weight,
    notes: notes,
    position: index + 1
  )
end

# -----------------------------------------------------------------------------
# PREP MISSIONS — espelhando o board do Art Studio
# -----------------------------------------------------------------------------
puts ">> Criando prep missions..."

mandatory_preps = [
  ["Scope Out", "scope", "Fotografar entradas, CCTV e alvos. Base de tudo no board."],
  ["Access Code", "equipment", "Código de acesso necessário pra infiltração."],
  ["Hacking Device", "equipment", "Dispositivo pra hackear sistemas do museu."],
  ["Infiltration Gear", "infiltration", "Escolhe o ponto de entrada (1 gear = 1 entry)."],
  ["Unmarked Weapons", "weapons", "Armas sem marcação pra equipe."],
  ["Getaway Vehicle", "getaway", "Veículo de fuga (pode pagar bônus pequeno)."]
]

mandatory_preps.each_with_index do |(name, category, description), index|
  PrepMission.create!(
    name: name,
    category: category,
    mandatory: true,
    description: description,
    unlock_hint: "Aparece no Planning Board após o Scope Out / progressão da história.",
    position: index + 1
  )
end

optional_preps = [
  ["EMP Charges", "optional",
   "Destrói armas/equipamentos dos reforços.",
   "Fotografe a caixa elétrica no telhado durante o Scope Out."],
  ["Guard Routes", "optional",
   "Intel das rotas dos guardas.",
   "Fotografe a torre de rádio no telhado."],
  ["Guard Shipments", "optional",
   "Interrompe remessas/reforços.",
   "Veja as caixas via CCTV da Loading Bay."],
  ["Power Drills", "optional",
   "Furadeiras pra lockboxes do cofre.",
   "Veja as lockboxes do vault via CCTV."],
  ["Glass Cutter", "optional",
   "Corta vitrines reforçadas (skull / displays altos).",
   "Fotografe uma vitrine alta/reforçada no interior."]
]

optional_preps.each_with_index do |(name, category, description, hint), index|
  PrepMission.create!(
    name: name,
    category: category,
    mandatory: false,
    description: description,
    unlock_hint: hint,
    position: index + 1
  )
end

# -----------------------------------------------------------------------------
# ENTRY POINTS
# -----------------------------------------------------------------------------
puts ">> Criando entry points..."

[
  ["Staff Entrance", "Staff Disguise / Gear A",
   "Entrada de funcionários no térreo, pelo Bell Building."],
  ["Skylight", "Rooftop Gear / Gear B",
   "Claraboia no telhado — acesso pelo Bell Building."],
  ["Loading Bay", "Dock Worker Gear / Gear C",
   "Doca de carga; também aparece nas câmeras de segurança."],
  ["Sewer", "Sewer Gear / Gear D",
   "Bueiro no centro do labirinto de sebes (precisa da chave do manhole)."]
].each_with_index do |(name, gear, description), index|
  EntryPoint.create!(
    name: name,
    gear_option: gear,
    description: description,
    position: index + 1
  )
end

puts "✅ Seed concluído!"
puts "   Targets: #{Target.count} | Preps: #{PrepMission.count} | Entries: #{EntryPoint.count}"
