//File for armored collars, should be identical in stats and cost to proper armor.


/obj/item/clothing/neck/roguetown/leather
	name = "hardened leather gorget"
	desc = "Sturdy. Durable. Will protect your neck from some good lumbering."
	icon_state = "lgorget"
	slot_flags = ITEM_SLOT_NECK
	blocksound = SOFTHIT
	body_parts_covered = NECK
	body_parts_inherent = NECK
	armor = ARMOR_LEATHER
	sewrepair = TRUE
	sellprice = 10
	max_integrity = ARMOR_INT_SIDE_HARDLEATHER + ARMOR_INT_SIDE_COVERAGE_BONUS
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1

