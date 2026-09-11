extends Node

# legit,
#  I think there's a bug with preloads
#  referencing scenes that some peers
#  haven't lazy loaded yet causes
#  an error in some unexplained spot
#  -- like 'invalid resource path/to/character_body_entity.gd'
# anyway for some reason this helps *shrugs*
const NPC = preload("uid://qbox8ja0a28g")
const PLAYER = preload("uid://co0dy4rvhwv5g")
