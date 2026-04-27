GLOBAL_LIST_INIT(dendor_touched_animals, list(
	"mouse",
	"cat",
	"cabbit",
	"volf",
	"honeyspider",
	"rat",
	"rakkun",
	"venard",
	"cow",
	"bull",
	"chicken",
	"lynx",
	"badger"
))

/datum/charflaw/hemovore
	name = "Hemovore"
	desc = "Be it by birth or curse, I can only gain sustenance through the blood of the living"

/datum/charflaw/hemovore/on_mob_creation(mob/user)
	ADD_TRAIT(user, TRAIT_LYFE_DRINK, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_VAMPBITE, TRAIT_GENERIC)

/datum/charflaw/hemovore/flaw_on_moved(mob/user, atom/OldLoc, movement_dir) //THIS SEEMS VERY JANK AND MAY NEED TO BE CHANGED BUT NO OTHER FLAW PROC SEEMED TO WORK
	var/mob/living/carbon/human/H = user
	if(HAS_TRAIT_FROM(H, TRAIT_NOHUNGER, TRAIT_VIRTUE) || HAS_TRAIT_FROM(H, TRAIT_NOHUNGER, TRAIT_GENERIC)) //Coded NOHUNGER removal, so when combined with Deathless you still have the HUNGER
		REMOVE_TRAIT(H, TRAIT_NOHUNGER, TRAIT_VIRTUE)
		REMOVE_TRAIT(H, TRAIT_NOHUNGER, TRAIT_GENERIC)
		to_chat(H, span_danger("My hunger brays at the back of my mind."))

/datum/charflaw/dendor_touched
	name = "Dendor Touched"
	desc = "Cursed by Dendor, you transform into an animal every time you enter total darkness."
	var/starting_leeway = 5 MINUTES
	var/next_check = 0
	var/check_interval = 10 SECONDS
	var/animal_curse = "mouse"
	var/last_transform = 0
	var/time_since_transform = 0
	var/transform_stress_time = 60 MINUTES

/datum/charflaw/dendor_touched/on_mob_creation(mob/user)
	next_check = world.time + starting_leeway
	last_transform = world.time
	
/datum/charflaw/dendor_touched/flaw_on_life(mob/user)
	if(!user)
		return
	if(!ishuman(user))
		return
	if(user.stat || !isturf(user.loc))
		return
	if(world.time > next_check)
		next_check = world.time + check_interval
		var/turf/our_turf = get_turf(user)
		var/turf_light = our_turf.get_lumcount()
		if(turf_light > 0.04)
			time_since_transform = world.time - last_transform
			var/mob/living/L = user
			if(time_since_transform > transform_stress_time)
				L.add_stress(/datum/stressevent/dendor_touched)
				L.apply_status_effect(/datum/status_effect/debuff/dendor_touched)
			return
		var/mob/living/carbon/human/cursed = user
		var/obj/shapeshift_holder/dendor_touched/H = locate() in cursed
		last_transform = world.time
		time_since_transform = 0
		if(!H)
			cursed.drop_all_held_items()
			var/shapeshift_type = /mob/living/simple_animal/hostile/retaliate/rogue/dendor_touched
			var/mob/living/shape = new shapeshift_type(cursed.loc)
			cursed.remove_stress(/datum/stressevent/dendor_touched)
			cursed.remove_status_effect(/datum/status_effect/debuff/dendor_touched)

			H = new(shape,cursed)
			shape.name = "[animal_curse]"
			shape.icon_state = "[animal_curse]"
			
			shape.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/shapeshift/dendor_touched)
			for(var/obj/effect/proc_holder/spell/targeted/shapeshift/the_spell in shape.mind.spell_list)
				the_spell.charge_counter = 0
				the_spell.start_recharge()

			return

/datum/charflaw/dendor_touched/apply_post_equipment(mob/user)
	if(user.mind)
		if(user.client.prefs?.cursed_animal)
			animal_curse = user.client.prefs?.cursed_animal
