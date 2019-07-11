tool
extends Node2D

export (int, "WeakBasic", "StrongBasic", "MagicFlyer", "WeakArmored", "StrongArmored", "InvokerBoss") var NpcType
export (bool) var randomSpawn = false
export (PackedScene) var NPCs
export (float) var timeSpawn = 10

func _ready():
	timeSpawn /= Global.current_level
	$Vortex/AnimationPlayer.play("Vortex")

func _on_SpawnNPC_timeout():
	if randomSpawn:
		NpcType = randi() % 5
	
	var newNPC = NPCs.instance()
	newNPC.setup(NpcType, position + Vector2(0, 50))
	get_parent().add_child(newNPC)
	$SpawnNPC.start(timeSpawn)
	
	if NpcType == 5:
		newNPC.connect("spawn_invoked", self, "_spawn_invoked")

func _hurt(_hit):
	$SpawnSound.play()
	$Vortex/AnimationPlayer.play("Disappear")

func _on_VisibilityEnabler2D_screen_entered():
	$SpawnNPC.start(1)

func _on_VisibilityEnabler2D_screen_exited():
	$SpawnNPC.stop()

func _spawn_invoked(_position):
	var newInvoked_01 = NPCs.instance()
	newInvoked_01.setup(randi() % 2, _position - Vector2(150, 200))
	get_parent().add_child(newInvoked_01)
	
	var newInvoked_02 = NPCs.instance()
	newInvoked_02.setup(randi() % 2, _position - Vector2(-150, 200))
	get_parent().add_child(newInvoked_02)
	
	$SpawnSound.play()