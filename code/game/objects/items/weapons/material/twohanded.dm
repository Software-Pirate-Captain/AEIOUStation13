/* Two-handed Weapons
 * Contains:
 * 		Twohanded
 *		Fireaxe
 *		Double-Bladed Energy Swords
 *		Glass spears
 *		Sledgehammer
 *		Mjollnir
 *		God Bat
 */

/*##################################################################
##################### TWO HANDED WEAPONS BE HERE~ -Agouri :3 ########
####################################################################*/

//Rewrote TwoHanded weapons stuff and put it all here. Just copypasta fireaxe to make new ones ~Carn
//This rewrite means we don't have two variables for EVERY item which are used only by a few weapons.
//It also tidies stuff up elsewhere.

/*
 * Twohanded
 */
/obj/item/weapon/material/twohanded
	w_class = ITEMSIZE_LARGE
	var/wielded = 0
	var/force_wielded = 0
	var/force_unwielded
	var/wieldsound = null
	var/unwieldsound = null
	var/base_icon
	var/base_name
	var/unwielded_force_divisor = 0.25

/obj/item/weapon/material/twohanded/update_held_icon()
	var/mob/living/M = loc
	if(istype(M) && M.can_wield_item(src) && is_held_twohanded(M))
		wielded = 1
		force = force_wielded
		name = "[base_name] (wielded)"
		update_icon()
	else
		wielded = 0
		force = force_unwielded
		name = "[base_name]"
	update_icon()
	..()

/obj/item/weapon/material/twohanded/update_force()
	base_name = name
	if(sharp || edge)
		force_wielded = material.get_edge_damage()
	else
		force_wielded = material.get_blunt_damage()
	force_wielded = round(force_wielded*force_divisor)
	force_unwielded = round(force_wielded*unwielded_force_divisor)
	force = force_unwielded
	throwforce = round(force*thrown_force_divisor)
	//world << "[src] has unwielded force [force_unwielded], wielded force [force_wielded] and throwforce [throwforce] when made from default material [material.name]"

/obj/item/weapon/material/twohanded/New()
	..()
	update_icon()

//Allow a small chance of parrying melee attacks when wielded - maybe generalize this to other weapons someday
/obj/item/weapon/material/twohanded/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(wielded && default_parry_check(user, attacker, damage_source) && prob(15))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		playsound(user.loc, 'sound/weapons/punchmiss.ogg', 50, 1)
		return 1
	return 0

/obj/item/weapon/material/twohanded/update_icon()
	icon_state = "[base_icon][wielded]"
	item_state = icon_state

/obj/item/weapon/material/twohanded/dropped()
	..()
	if(wielded)
		spawn(0)
			update_held_icon()

/*
 * Fireaxe
 */
/obj/item/weapon/material/twohanded/fireaxe  // DEM AXES MAN, marker -Agouri
	icon_state = "fireaxe0"
	base_icon = "fireaxe"
	name = "fire axe"
	desc = "Truly, the weapon of a madman. Who would think to fight fire with an axe?"
	description_info = "This weapon can cleave, striking nearby lesser, hostile enemies close to the primary target.  It must be held in both hands to do this."
	unwielded_force_divisor = 0.25
	force_divisor = 0.7 // 10/42 with hardness 60 (steel) and 0.25 unwielded divisor
	dulled_divisor = 0.75	//Still metal on a stick
	sharp = 1
	edge = 1
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	force_wielded = 30
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	applies_material_colour = 0
	can_cleave = TRUE

/obj/item/weapon/material/twohanded/fireaxe/update_held_icon()
	var/mob/living/M = loc
	if(istype(M) && !issmall(M) && M.item_is_in_hands(src) && !M.hands_are_full())
		wielded = 1
		pry = 1
		force = force_wielded
		name = "[base_name] (wielded)"
		update_icon()
	else
		wielded = 0
		pry = 0
		force = force_unwielded
		name = "[base_name]"
	update_icon()
	..()

/obj/item/weapon/material/twohanded/fireaxe/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	if(!proximity) return
	..()
	if(A && wielded)
		if(istype(A,/obj/structure/window))
			var/obj/structure/window/W = A
			W.shatter()
		else if(istype(A,/obj/structure/grille))
			qdel(A)
		else if(istype(A,/obj/effect/plant))
			var/obj/effect/plant/P = A
			P.die_off()

/obj/item/weapon/material/twohanded/fireaxe/scythe
	icon_state = "scythe0"
	base_icon = "scythe"
	name = "scythe"
	desc = "A sharp and curved blade on a long fibremetal handle, this tool makes it easy to reap what you sow."
	force_divisor = 0.65
	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 2)
	attack_verb = list("chopped", "sliced", "cut", "reaped")

//spears, bay edition
/obj/item/weapon/material/twohanded/spear
	icon_state = "spearglass0"
	base_icon = "spearglass"
	name = "spear"
	desc = "A haphazardly-constructed yet still deadly weapon of ancient design."
	description_info = "This weapon can strike from two tiles away, and over certain objects such as tables, or other people."
	force = 10
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	force_divisor = 0.5 			// 15 when wielded with hardness 30 (glass)
	unwielded_force_divisor = 0.375
	thrown_force_divisor = 1.5 		// 22.5 when thrown with weight 15 (glass)
	throw_speed = 3
	edge = 0
	sharp = 1
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "poked", "jabbed", "torn", "gored")
	default_material = "glass"
	applies_material_colour = 0
	fragile = 1	//It's a haphazard thing of glass, wire, and steel
	reach = 2 // Spears are long.
	attackspeed = 14

/*
*
*Sledgehammer
*Mjollnir
*
*/


/obj/item/weapon/material/twohanded/sledgehammer  // a SLEGDGEHAMMER
	icon_state = "sledgehammer0"
	base_icon = "sledgehammer"
	name = "sledgehammer"
	desc = "A long, heavy hammer meant to be used with both hands. Typically used for breaking rocks and driving posts, it can also be used for breaking bones or driving points home."
	description_info = "This weapon can cleave, striking nearby lesser, hostile enemies close to the primary target.  It must be held in both hands to do this."
	unwielded_force_divisor = 0.25
	force = 15
	force_divisor = 0.9 // 10/42 with hardness 60 (steel) and 0.25 unwielded divisor
	hitsound = 'sound/weapons/heavysmash.ogg'
	icon = 'icons/obj/weapons_vr.dmi'
	w_class = ITEMSIZE_LARGE
	slowdown = 1
	dulled_divisor = 0.95	//Still metal on a stick
	sharp = 0
	edge = 0
	force_wielded = 35
	attack_verb = list("attacked", "smashed", "crushed", "wacked", "pounded")
	applies_material_colour = 0

/obj/item/weapon/material/twohanded/sledgehammer/update_held_icon()
	var/mob/living/M = loc
	if(istype(M) && !issmall(M) && M.item_is_in_hands(src) && !M.hands_are_full())
		wielded = 1
		pry = 1
		force = force_wielded
		name = "[base_name] (wielded)"
		update_icon()
	else
		wielded = 0
		pry = 0
		force = force_unwielded
		name = "[base_name]"
	update_icon()
	..()

/obj/item/weapon/material/twohanded/sledgehammer/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	if(!proximity) return
	..()
	if(A && wielded)
		if(istype(A,/obj/structure/window))
			var/obj/structure/window/W = A
			W.shatter()
		else if(istype(A,/obj/structure/grille))
			qdel(A)
		else if(istype(A,/obj/effect/plant))
			var/obj/effect/plant/P = A
			P.die_off()

// This cannot go into afterattack since some mobs delete themselves upon dying.
/obj/item/weapon/material/twohanded/sledgehammer/pre_attack(var/mob/living/target, var/mob/living/user)
	if(istype(target))
		cleave(user, target)

/obj/item/weapon/material/twohanded/sledgehammer/mjollnir
	icon_state = "mjollnir0"
	base_icon = "mjollnir"
	name = "Mjollnir"
	desc = "A long, heavy hammer. This weapons crackles with barely contained energy."
	force_divisor = 0.90 // 10/42 with hardness 60 (steel) and 0.25 unwielded divisor
	hitsound = 'sound/effects/lightningbolt.ogg'
	force_wielded = 65

/*
/obj/item/weapon/material/twohanded/sledgehammer/mjollnir/afterattack(var/atom/impacted)
	if(isliving(impacted))
		var/mob/living/L = impacted
		if(L.mind)
			var/nif
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				nif = H.nif
			SStranscore.m_backup(L.mind,nif,one_time = TRUE)
		L.gib()
*/

/obj/item/weapon/material/twohanded/sledgehammer/mjollnir/proc/shock(mob/living/target)
	target.Stun(60)
	target.visible_message("<span class='danger'>[target.name] was shocked by [src]!</span>", \
		"<span class='userdanger'>You feel a powerful shock course through your body sending you flying!</span>", \
		"<span class='italics'>You hear a heavy electrical crack!</span>")
	var/atom/throw_target = get_edge_target_turf(target, get_dir(src, get_step_away(target, src)))
	target.throw_at(throw_target, 200, 4)
	return

/obj/item/weapon/material/twohanded/sledgehammer/mjollnir/attack(mob/living/M, mob/user)
	..()
	if(wielded)
		playsound(src.loc, "sparks", 50, 1)
		shock(M)

/obj/item/weapon/material/twohanded/sledgehammer/mjollnir/throw_impact(atom/target)
	. = ..()
	if(isliving(target))
		shock(target)

/obj/item/weapon/material/twohanded/sledgehammer/mjollnir/update_icon()  //Currently only here to fuck with the on-mob icons.
	icon_state = "mjollnir[wielded]"
	return

