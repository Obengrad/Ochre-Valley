/mob/living/simple_animal/hostile/retaliate/rogue/dendor_touched
	icon = 'modular_ochrevalley/icons/roguetown/mob/dendor_touched.dmi'
	name = "mouse"
	desc = "A feral animal of some sorts!"
	icon_state = "mouse"
	icon_living = "mouse"
	icon_dead = "mouse_dead"
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 6
	move_to_delay = 3
	base_intents = list(/datum/intent/simple/bite/volf)
	botched_butcher_results = list()
	butcher_results = list()
	perfect_butcher_results = list()
	head_butcher = null
	faction = list("zombie")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = WOLF_HEALTH
	maxHealth = WOLF_HEALTH
	melee_damage_lower = 10
	melee_damage_upper = 15
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0
	milkies = FALSE
	food_type = list()
	pooptype = null
	STACON = 10
	STASTR = 10
	STASPD = 10
	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 40
	del_on_deaggro = null
	retreat_health = 0.3
	food = 0
	dodgetime = 30
	aggressive = 1
//	stat_attack = UNCONSCIOUS
	remains_type = null
	eat_forever = TRUE
	var/chomp_cd = 0
	var/chomp_roll = 0

/obj/effect/proc_holder/spell/targeted/shapeshift/dendor_touched
	name = "Animal Form"
	desc = ""
	overlay_state = ""
	gesture_required = TRUE
	chargetime = 5 SECONDS
	recharge_time = 5 MINUTES
	cooldown_min = 5 MINUTES
	die_with_shapeshifted_form = FALSE
	shapeshift_type = /mob/living/simple_animal/hostile/retaliate/rogue/dendor_touched
	convert_damage = FALSE
	do_gib = FALSE

/obj/shapeshift_holder/dendor_touched/Initialize(mapload,mob/living/caster)
	if(!caster)
		return ..()
	shape = loc
	if(!istype(shape))
		CRASH("shapeshift holder created outside mob/living")
	stored = caster
	if(stored.mind)
		stored.mind.transfer_to(shape)
	stored.forceMove(src)
	stored.notransform = TRUE
	shape.visible_message(span_warning("[stored] has twisted brutally into an animal form."),span_warningbig("Shrouded within the darkness, you have been forced to transform into your cursed animal form."))
	playsound(shape.loc, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
	slink = soullink(/datum/soullink/shapeshift, stored , shape)
	slink.source = src

/obj/shapeshift_holder/dendor_touched/restore(death=FALSE, knockout=0)
	if(restoring || QDELETED(src))
		return
	

	restoring = TRUE
	qdel(slink)
	if (stored)
		stored.forceMove(get_turf(src))
		stored.notransform = FALSE

		// leave a track to indicate something has shifted out here
		var/obj/effect/track/the_evidence = new(stored.loc)
		the_evidence.handle_creation(stored)
		the_evidence.track_type = "expanding animal tracks into humanoid footprints"
		the_evidence.ambiguous_track_type = "curious footprints"
		the_evidence.base_diff = 6
	if(ishuman(stored))
		var/mob/living/carbon/human/us = stored
		for(var/datum/charflaw/dendor_touched/touched in us.charflaws)
			touched.last_transform = world.time
	if(shape && shape.mind)
		shape.mind?.transfer_to(stored)
		stored.mind.RemoveSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/dendor_touched)
	to_chat(stored, span_notice("Bug notice: If you can no longer see emotes, move to a different z level and back (up/down a level). This is a known bug."))
	qdel(shape)
	shape = null

/datum/stressevent/dendor_touched
	timer = 6 MINUTES
	stressadd = 7
	desc = span_red("It has been daes since I turned! The beast is burning inside me, I must let it free!")

/datum/status_effect/debuff/dendor_touched
	id = "dendor_touched"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/dendor_touched
	effectedstats = list(STATKEY_WIL = -3,STATKEY_INT = -2)
	duration = 200

/atom/movable/screen/alert/status_effect/debuff/dendor_touched
	name = "Dendor Touched"
	desc = "You must unleash the beast!"
	icon_state = "debuff"
