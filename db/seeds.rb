# frozen_string_literal: true

# =============================================================================
# Seeds — dados iniciais do Kortz Center Heist
# -----------------------------------------------------------------------------
# Rode com:  bin/rails db:seed
#
# Main Target matrix (Easy/Hard × First weekly × Alarm): tabela da comunidade
# (GTA Boom / planilhas da crew). Secondary: Beebom.
# =============================================================================

puts ">> Limpando tabelas..."
Target.delete_all
PrepMission.delete_all
EntryPoint.delete_all

# -----------------------------------------------------------------------------
# PRIMARY TARGETS — matriz completa
# Colunas: [name,
#   easy_repeat, easy_first_no_alarm, easy_first_alarm, easy_repeat_alarm,
#   hard_repeat, hard_first_no_alarm, hard_first_alarm, hard_repeat_alarm]
# -----------------------------------------------------------------------------
puts ">> Criando primary targets (matriz Easy/Hard)..."

primaries = [
  ["La Dernière Débauche",
   481_250, 1_925_000, 1_443_750, 360_938,
   529_375, 2_117_500, 1_588_125, 397_031],
  ["The Outcome of Endeavour",
   365_000, 1_460_000, 1_095_000, 273_750,
   401_500, 1_606_000, 1_204_500, 301_125],
  ["Mi O Melee",
   317_000, 1_268_000, 951_000, 237_750,
   348_700, 1_394_800, 1_046_100, 261_525],
  ["What Are Melons?",
   316_000, 1_264_000, 948_000, 237_000,
   347_600, 1_390_400, 1_042_800, 260_700],
  ["Until Death",
   315_500, 1_262_000, 946_500, 236_625,
   347_050, 1_388_200, 1_041_150, 260_288],
  ["Trust",
   315_000, 1_260_000, 945_000, 236_250,
   346_500, 1_386_000, 1_039_500, 259_875],
  ["Teckels",
   314_500, 1_258_000, 943_500, 235_875,
   345_950, 1_383_800, 1_037_850, 259_463],
  ["A Winding Road Home",
   314_000, 1_256_000, 942_000, 235_500,
   345_400, 1_381_600, 1_036_200, 259_050],
  ["Juiced",
   313_500, 1_254_000, 940_500, 235_125,
   344_850, 1_379_400, 1_034_550, 258_638],
  ["In Excess of Success",
   313_000, 1_252_000, 939_000, 234_750,
   344_300, 1_377_200, 1_032_900, 258_225],
  ["To Beat About the Bush",
   312_500, 1_250_000, 937_500, 234_375,
   343_750, 1_375_000, 1_031_250, 257_813],
  ["I, Fruit",
   312_000, 1_248_000, 936_000, 234_000,
   343_200, 1_372_800, 1_029_600, 257_400],
  ["Stacks Study V",
   311_500, 1_246_000, 934_500, 233_625,
   342_650, 1_370_600, 1_027_950, 256_988],
  ["Twindifference",
   311_000, 1_244_000, 933_000, 233_250,
   342_100, 1_368_400, 1_026_300, 256_575],
  ["Pumpkin",
   310_500, 1_242_000, 931_500, 232_875,
   341_550, 1_366_200, 1_024_650, 256_163],
  ["Chat on Fruit",
   310_000, 1_240_000, 930_000, 232_500,
   341_000, 1_364_000, 1_023_000, 255_750],
  ["The Girl With the Pearl Necklace",
   309_500, 1_238_000, 928_500, 232_125,
   340_450, 1_361_800, 1_021_350, 255_338],
  ["Winter, Nowhere in Particular",
   309_000, 1_236_000, 927_000, 231_750,
   339_900, 1_359_600, 1_019_700, 254_925],
  ["I Hear Voices",
   308_500, 1_234_000, 925_500, 231_375,
   339_350, 1_357_400, 1_018_050, 254_513],
  ["Consumato",
   308_000, 1_232_000, 924_000, 231_000,
   338_800, 1_355_200, 1_016_400, 254_100],
  ["Breathless",
   307_500, 1_230_000, 922_500, 230_625,
   338_250, 1_353_000, 1_014_750, 253_688],
  ["True Love",
   307_000, 1_228_000, 921_000, 230_250,
   337_700, 1_350_800, 1_013_100, 253_275],
  ["Gone To Seed",
   306_500, 1_226_000, 919_500, 229_875,
   337_150, 1_348_600, 1_011_450, 252_863],
  ["A Cast of Characters",
   306_000, 1_224_000, 918_000, 229_500,
   336_600, 1_346_400, 1_009_800, 252_450],
  ["Brother Brother",
   305_500, 1_222_000, 916_500, 229_125,
   336_050, 1_344_200, 1_008_150, 252_038],
  ["The Downfall of Rome",
   305_000, 1_220_000, 915_000, 228_750,
   335_500, 1_342_000, 1_006_500, 251_625],
  ["Hare Oneself Think",
   304_500, 1_218_000, 913_500, 228_375,
   334_950, 1_339_800, 1_004_850, 251_213]
]

primaries.each_with_index do |row, index|
  name, er, efn, efa, era, hr, hfn, hfa, hra = row

  Target.create!(
    name: name,
    kind: "primary",
    location: "Kortz Center Vault",
    # Campos legados = Easy first / Easy repeat (pra helpers antigos)
    first_weekly_payout: efn,
    repeat_payout: er,
    # Matriz completa
    easy_repeat: er,
    easy_first_no_alarm: efn,
    easy_first_alarm: efa,
    easy_repeat_alarm: era,
    hard_repeat: hr,
    hard_first_no_alarm: hfn,
    hard_first_alarm: hfa,
    hard_repeat_alarm: hra,
    bag_weight: 0,
    notes: "Main Target — Easy/Hard × 1st weekly × alarm (community payout table).",
    position: index + 1
  )
end

# -----------------------------------------------------------------------------
# SECONDARY TARGETS
# -----------------------------------------------------------------------------
puts ">> Criando secondary targets..."

secondaries = [
  # ---------------------------------------------------------------------------
  # Vault secondaries — HAND-CORRECTED (do not use the GTA$850k/825k/775k/750k
  # figures some guides list; crew/in-game values are below).
  # ---------------------------------------------------------------------------
  ["With Friends Like These", "Vault", 85_000, 50, "Vault painting — high priority"],
  ["Het Gouden Hondje", "Vault", 82_500, 50, "Vault painting — high priority"],
  ["Swingset Study No. LXiX", "Vault", 77_500, 50, "Vault painting"],
  ["The Hunter Becomes The Hunted", "Vault", 75_000, 50, "Vault painting"],
  ["Don't Forgo These Blueprints", "2nd floor", 150_000, 40, "Upper gallery"],
  ["The Great Circle Back", "2nd floor", 145_000, 40, "2nd floor gallery"],
  ["Cooked", "2nd floor", 120_000, 40, "Kircher — 2nd floor"],
  ["Venus d'Algernon (Ivory)", "2nd floor", 120_000, 35, "Display / sculpture"],
  ["Sod Off", "2nd floor", 115_000, 40, "2nd floor painting"],
  ["The Chief", "1st floor", 110_000, 40, "1st floor gallery"],
  ["Orange Crush", "1st floor", 107_500, 40, "1st floor gallery"],
  ["Yellow Topaz Gemstone", "2nd floor", 107_500, 20, "Jewel — light in bag"],
  ["La Duchesse", "1st floor", 105_000, 40, "1st floor gallery"],
  ["Do You See Me", "1st floor", 105_000, 40, "1st floor gallery"],
  ["Coquard Carcanet (Tanzanite)", "2nd floor", 97_500, 15, "Jewel"],
  ["Perlino Andalusian", "2nd floor", 95_000, 30, "Gallery piece"],
  ["Fertility Statue (Bronze)", "2nd floor", 88_000, 30, "Statue"],
  ["Meteorite Fragment", "2nd floor", 84_000, 20, "Display"],
  ["Memento Non Mori (Emerald)", "Ground floor", 77_500, 20, "Jewel — ground floor"],
  ["Fertility Statue (Ivory)", "1st floor", 62_000, 30, "Statue"],
  ["Œuf de Coquard décoratif", "Ground floor", 54_000, 15, "Decorative egg"],
  ["Œuf de Coquard enchanté", "2nd floor", 52_000, 15, "Decorative egg"],
  ["Antique Bands", "1st floor", 35_000, 10, "Rings"],
  ["Art Deco Rings", "1st floor", 34_000, 10, "Rings"],
  ["Antique Rings", "1st floor", 34_000, 10, "Rings"],
  ["Coquard Rings", "1st floor", 31_000, 10, "Rings"],
  ["Pharaonic Bangles", "1st floor", 31_000, 10, "Bracelets"],
  ["Byzantine Hoops", "Ground floor", 29_000, 10, "Earrings"],
  ["Coquard Bracelets", "2nd floor", 29_000, 10, "Bracelets"]
]

secondaries.each_with_index do |(name, location, payout, weight, notes), index|
  Target.create!(
    name: name,
    kind: "secondary",
    location: location,
    first_weekly_payout: payout,
    repeat_payout: payout,
    bag_weight: weight,
    notes: notes,
    position: index + 1
  )
end

# -----------------------------------------------------------------------------
# PREP MISSIONS
# -----------------------------------------------------------------------------
puts ">> Criando prep missions..."

mandatory_preps = [
  ["Scope Out", "scope", "Photograph entries, CCTV, and targets. Foundation of the board."],
  ["Access Code", "equipment", "Access code required for infiltration."],
  ["Hacking Device", "equipment", "Device used to hack museum systems."],
  ["Infiltration Gear", "infiltration", "Chooses your entry point (1 gear = 1 entry)."],
  ["Unmarked Weapons", "weapons", "Unmarked weapons for the crew."],
  ["Getaway Vehicle", "getaway", "Escape vehicle (may pay a small bonus)."]
]

mandatory_preps.each_with_index do |(name, category, description), index|
  PrepMission.create!(
    name: name,
    category: category,
    mandatory: true,
    description: description,
    unlock_hint: "Appears on the Planning Board after Scope Out / story progress.",
    position: index + 1
  )
end

optional_preps = [
  ["EMP Charges", "optional",
   "Destroys reinforcement weapons and gear.",
   "Photograph the electrical box on the roof during Scope Out."],
  ["Guard Routes", "optional",
   "Intel on guard patrol routes.",
   "Photograph the radio tower on the roof."],
  ["Guard Shipments", "optional",
   "Interrupts shipments / reinforcements.",
   "View the crates via Loading Bay CCTV."],
  ["Power Drills", "optional",
   "Drills for vault lockboxes.",
   "View the vault lockboxes via CCTV."],
  ["Glass Cutter", "optional",
   "Cuts reinforced display cases (skull / tall cases).",
   "Photograph a tall reinforced case inside."]
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

# [name, gear, description, guide_url]
[
  ["Staff Entrance", "Staff Disguise / Gear A",
   "Staff door on the ground floor via the Bell Building.",
   "https://www.youtube.com/watch?v=nDw_zremjsk"],
  ["Skylight", "Rooftop Gear / Gear B",
   "Rooftop skylight — access via the Bell Building.",
   "https://www.youtube.com/watch?v=P87H4d86Oao"],
  ["Loading Bay", "Dock Worker Gear / Gear C",
   "Loading dock; also visible on security cameras.",
   "https://www.youtube.com/watch?v=nvvqRv86C_w"],
  ["Sewer", "Sewer Gear / Gear D",
   "Manhole in the hedge maze center (needs the manhole key).",
   "https://www.youtube.com/watch?v=1XANjiI0sTg"]

].each_with_index do |(name, gear, description, guide_url), index|
  EntryPoint.create!(
    name: name,
    gear_option: gear,
    description: description,
    guide_url: guide_url,
    position: index + 1
  )
end

puts "✅ Seed concluído!"
puts "   Primaries: #{Target.primary.count} | Secondaries: #{Target.secondary.count}"
puts "   Preps: #{PrepMission.count} | Entries: #{EntryPoint.count}"
