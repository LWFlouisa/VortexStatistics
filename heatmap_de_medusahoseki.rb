def get_statistics(a1, a2, b1, b2, c1, c2)
  $factored_labels        = []
  $factored_probabilities = []

  a = a1, a2
  b = b1, b2
  c = c1, c2

  matrix = [
    [[a[0], a[0]], [a[0], b[0]], [a[0], c[0]]],
    [[b[0], a[0]], [b[0], b[0]], [b[0], c[0]]],
    [[c[0], a[0]], [c[0], b[0]], [c[0], c[0]]],
  ], [
    [[a[1], a[1]], [a[1], b[1]], [a[1], c[1]]],
    [[b[1], a[1]], [b[1], b[1]], [b[1], c[1]]],
    [[c[1], a[1]], [c[1], b[1]], [c[1], c[1]]],
  ], [
    [[0.50, 0.50], [0.50, 0.50], [0.50, 0.50]],
    [[0.50, 0.50], [0.50, 0.50], [0.50, 0.50]],
    [[0.50, 0.50], [0.50, 0.50], [0.50, 0.50]],
  ]

  label_type       = matrix[0]
  definition_type  = matrix[1]
  probability_type = matrix[2]
  
  row_probability = 0.33
  col_probability = 0.33
  
  graph_selection = row_probability * col_probability

  row_options = [0, 1, 2]
  col_options = [0, 1, 2]
  arr_options = [0, 1]

  cur_row = row_options.sample
  cur_col = col_options.sample
  cur_arr = arr_options.sample
  
  current_label       = label_type[cur_row][cur_col][cur_arr]
  current_definition  = definition_type[cur_row][cur_col][cur_arr]
  current_probability = probability_type[cur_row][cur_col][cur_arr] * graph_selection
  
  "I'm confident it is not [ #{current_label} #{current_definition} ] as it has only #{current_probability} probability."
  
  $current_label       = current_label
  $current_definition  = current_definition
  $current_probability = current_probability + current_probability
  $current_information = "#{current_label} #{current_definition}"
  
  $factored_labels        = $factored_labels.append(current_label)
  $factored_probabilities = $factored_probabilities.append($current_probability)
end

def reasses
  if $current_probability > 0.999999999999999999
    $current_probability = 0.9 / $current_probability
  end
  
  case $current_probability
  when 0.003921569000000000..0.287225000000000000
    "I'm confident it is not [ #{$current_information} ] because it has #{$current_probability}."
  when 0.287225000000000001..0.522225000000000000
    "I'm less unconfident it is not [ #{$current_information} ] because it has #{$current_probability}."
  when 0.522225000000000001..0.756112500000000000
    "I'm almost sure it is [ #{$current_information} ] because it has #{$current_probability}."
  when 0.756112500000000001..0.999999999999999999
    "I'm sure it is [ #{$current_information} ] because it has #{$current_probability}."

  else
    "The probability is either to low or to large, so I can't determine exactly."
  end
  
  $current_probability = $current_probability + $current_probability
  
  ## Remove the third index so as not to influence the total summation.
  #$factored_probabilities = $factored_probabilities.append($current_probability)
  #$factored_probabilities = $factored_probabilityes.delete(2)
end

def reconsider
  if $current_probability > 0.999999999999999999
    $current_probability = 0.9 / $current_probability
  end

  case $current_probability
  when 0.003921569000000000..0.287225000000000000
    "I'm confident it is not [ #{$current_information} ] because it has #{$current_probability}."
  when 0.287225000000000001..0.522225000000000000
    "I'm less unconfident it is not [ #{$current_information} ] because it has #{$current_probability}."
  when 0.522225000000000001..0.756112500000000000
    "I'm almost sure it is [ #{$current_information} ] because it has #{$current_probability}."
  when 0.756112500000000001..0.999999999999999999
    "I'm sure it is [ #{$current_information} ] because it has #{$current_probability}."
  else
    "The probability is either to low or to large, so I can't determine exactly."
  end
  
  $current_probability = $current_probability * $current_probability
  
  ## Remove the third index so as not to influence the total summation.
  #$factored_probabilities = $factored_probabilities.append($current_probability)
  #$factored_probabilities = $factored_probabilityes.delete(2)
end

def dynamic_reward_allocation
  l1_reasses = "level one reasses"
  l2_reasses = "level two reasses"
  l3_reasses = "level tre reasses"
  l4_reasses = "level fro reasses"

  reward_model = [
    [[l1_reasses, l1_reasses, l1_reasses, l1_reasses],
     [l1_reasses, l1_reasses, l1_reasses, l2_reasses],
     [l1_reasses, l1_reasses, l1_reasses, l3_reasses],
     [l1_reasses, l1_reasses, l1_reasses, l4_reasses]],
   
    [[l2_reasses, l2_reasses, l2_reasses, l1_reasses],
     [l2_reasses, l2_reasses, l2_reasses, l2_reasses],
     [l2_reasses, l2_reasses, l2_reasses, l3_reasses],
     [l2_reasses, l2_reasses, l2_reasses, l4_reasses]],
   
    [[l3_reasses, l3_reasses, l3_reasses, l1_reasses],
     [l3_reasses, l3_reasses, l3_reasses, l2_reasses],
     [l3_reasses, l3_reasses, l3_reasses, l3_reasses],
     [l3_reasses, l3_reasses, l3_reasses, l4_reasses]],
   
    [[l4_reasses, l4_reasses, l4_reasses, l1_reasses],
     [l4_reasses, l4_reasses, l4_reasses, l2_reasses],
     [l4_reasses, l4_reasses, l4_reasses, l3_reasses],
     [l4_reasses, l4_reasses, l4_reasses, l4_reasses]],
  ]

  row_options = [0, 1, 2, 3]
  col_options = [0, 1, 2, 3]
  arr_options = [0, 1, 2, 3]

  cur_row = row_options.sample
  cur_col = col_options.sample
  cur_arr = arr_options.sample

  current_reward_structure = reward_model[cur_row][cur_col][cur_arr]

  if    current_reward_structure == l1_reasses; reasses
  elsif current_reward_structure == l2_reasses; 2.times do reasses end
  elsif current_reward_structure == l3_reasses; 3.times do reasses end
  elsif current_reward_structure == l4_reasses; 4.times do reasses end
  else
    reconsider
  end
end

def dynamic_guillotine_allocation
  l1_reasses = "level one reasses"
  l2_reasses = "level two reasses"
  l3_reasses = "level tre reasses"
  l4_reasses = "level fro reasses"

  reward_model = [
    [[l1_reasses, l1_reasses, l1_reasses, l1_reasses],
     [l1_reasses, l1_reasses, l1_reasses, l2_reasses],
     [l1_reasses, l1_reasses, l1_reasses, l3_reasses],
     [l1_reasses, l1_reasses, l1_reasses, l4_reasses]],
   
    [[l2_reasses, l2_reasses, l2_reasses, l1_reasses],
     [l2_reasses, l2_reasses, l2_reasses, l2_reasses],
     [l2_reasses, l2_reasses, l2_reasses, l3_reasses],
     [l2_reasses, l2_reasses, l2_reasses, l4_reasses]],
   
    [[l3_reasses, l3_reasses, l3_reasses, l1_reasses],
     [l3_reasses, l3_reasses, l3_reasses, l2_reasses],
     [l3_reasses, l3_reasses, l3_reasses, l3_reasses],
     [l3_reasses, l3_reasses, l3_reasses, l4_reasses]],
   
    [[l4_reasses, l4_reasses, l4_reasses, l1_reasses],
     [l4_reasses, l4_reasses, l4_reasses, l2_reasses],
     [l4_reasses, l4_reasses, l4_reasses, l3_reasses],
     [l4_reasses, l4_reasses, l4_reasses, l4_reasses]],
  ]

  row_options = [0, 1, 2, 3]
  col_options = [0, 1, 2, 3]
  arr_options = [0, 1, 2, 3]

  cur_row = row_options.sample
  cur_col = col_options.sample
  cur_arr = arr_options.sample

  current_reward_structure = reward_model[cur_row][cur_col][cur_arr]

  if    current_reward_structure == l1_reasses; reconsider
  elsif current_reward_structure == l2_reasses; 2.times do reconsider end
  elsif current_reward_structure == l3_reasses; 3.times do reconsider end
  elsif current_reward_structure == l4_reasses; 4.times do reconsider end
  else
    reconsider
  end
end

def dynamic_mode_switcher
  modes = [
    [["deposit", "deposit"], ["deposit", "extract"]],
    [["extract", "deposit"], ["extract", "extract"]],
  ]
  
  row_options = [0, 1]
  col_options = [0, 1]
  arr_options = [0, 1]

  cur_row = row_options.sample
  cur_col = col_options.sample
  cur_arr = arr_options.sample

  current_mode = modes[cur_row][cur_col][cur_arr]

  if    current_mode == "deposit"; dynamic_reward_allocation
  elsif current_mode == "extract"; dynamic_guillotine_allocation
  else
    dynamic_guillotine_allocation
  end
end

def proximity_de_medusahoseki(a, b)
  maximum_distance     = b
  distance_probability = a
  
  calculation = maximum_distance - ( maximum_distance * distance_probability )
  calculation = calculation.round
  
  "Distance from Medusahoseki: #{calculation}"
end

def proximity_de_nemedusahoseki(a, b)
  maximum_distance     = b
  distance_probability = 1 - a
  
  calculation = maximum_distance - ( maximum_distance * distance_probability )
  calculation = calculation.round
  
  "Distance from Nemedusahoseki ( Salamander Riding Goat ): #{calculation}"
end

def proximity_de_memorie(a)
  year_period = 12
  
  calculation = 12 - ( 12 * a )
  calculation = calculation.round
  
  "This memory was from a prior #{calculation} year period"
end

## That time
def self.sore_float(condition)
  if condition
    yield
    
    return true
  end
  
  false
end

def self.shikashi_float(already_done, condition)
  return true if already_done
  
  if condition
    yield
    
    return true
  end
end

def self.sonota_float(already_done)
  yield unless already_done
  
  unless already_done
    #if defined?($otherwise)
      #puts "#{$otherwise_not[0]} is 'THAT'"
      #puts "#{$otherwise_not[1]} is 'WHAT'"
    #end
  end
end

## A place of many rivers flowing together.
def self.matawa_float(already_done)
  yield unless already_done
  
  unless already_done
    #if defined?($otherwise)
      #puts "#{$otherwise_not[0]} is 'THAT'"
      #puts "#{$otherwise_not[1]} is 'WHAT'"
    #end
  end
end

thermodynamic_states = [
  [ :level_tre,    "The room becomes silent, except for the low hum og gears.", 0.003920842 ],
  [ :level_two, "The floor is starting to lose friction, with fog in the air.", 0.082653950 ],
  [ :level_one,                       "Residuals of ice are starting to form.", 0.189747360 ],
], [
  [ :level_one,                    "Surface layer of sand is starting to turn to glass.", 0.010331745 ],
  [ :level_two, "The marble on the floor is starting to soften and fabrics icinerating.", 0.020663488 ],
  [ :level_tre,                 "The room currently feels like the center of the Earth.", 0.094873680 ],
]

## Ideal Coldness
level_one_ice = thermodynamic_states[0][2][2]
level_two_ice = thermodynamic_states[0][1][2]
level_tre_ice = thermodynamic_states[0][0][2]

## Ideal Heat
level_one_fir = thermodynamic_states[0][0][2]
level_two_fir = thermodynamic_states[0][1][2]
level_tre_fir = thermodynamic_states[0][2][2]

2.times do
  get_statistics(:level_one, "Residuals of ice are starting to form.",
                 :level_two, "The floor is starting to lose its friction, fog in the air.",
                 :level_tre, "The room becomes silent, except for the low hum of gears.")
                   
                 dynamic_mode_switcher
end

ideal_cold = ( level_one_ice + level_two_ice + level_tre_ice ) / $current_probability

print "The present cold status: "

## First Probability
active_state = sore_float($current_probability > ideal_cold) do
  puts "#{$current_definition}"
  
  puts proximity_de_medusahoseki(150, $current_probability)
end

active_state = shikashi_float(active_state, $current_probability < ideal_cold) do
  puts "#{$current_definition}"

  puts proximity_de_medusahoseki(150, $current_probability)
end

active_state = matawa_float(active_state) do
  puts "#{$current_definition}."

  puts proximity_de_medusahoseki(150, $current_probability)
end

2.times do
  get_statistics(:level_one, "Surface layer of sand is starting to turn to glass",
                 :level_two, "The marble on the floor is starting to soften and fabrics icinerating.",
                 :level_tre, "The room currently feels like the center of the Earth.")
                   
                 dynamic_mode_switcher
end

ideal_heat = ( level_one_fir + level_two_fir + level_tre_fir ) / $current_probability

print "The present heat status: "

## Second Probability
active_state = sore_float($current_probability > ideal_heat) do
  puts "#{$current_definition}"

  puts proximity_de_nemedusahoseki(150, $current_probability)
end

active_state = shikashi_float(active_state, $current_probability < ideal_heat) do
  puts "#{$current_definition}"

  puts proximity_de_nemedusahoseki(150, $current_probability)
end

active_state = matawa_float(active_state) do
  puts "#{$current_definition}."

  puts proximity_de_nemedusahoseki(150, $current_probability)
end
