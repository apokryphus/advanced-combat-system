// Created and designed by error_noaccess, exclusive to the Wolven Workshop discord server and Github. 
// Not authorized to be distributed elsewhere, unless you ask me nicely.

statemachine abstract class W3ACSWatcher extends CEntity
{
	private var lastACSMovementDoubleTapName 																								: name;
	private var playerAttacker, playerVictim																								: CPlayer;
	private var movementAdjustor, victimMovementAdjustor																					: CMovementAdjustor; 
	private var ticket, victimTicket 																										: SMovementAdjustmentRequestTicket; 
	private var actor, pActor, npcactor_ANIMATION_CANCEL																					: CActor; 
	private var npc_ANIMATION_CANCEL																										: CNewNPC; 
	private var targetDistance, dist, distJump, distVampSpecialDash, distClawWhirl, sword_dmg												: float; 
	private var animatedComponent, animatedComponent_NPC_ANIMATION_CANCEL, animatedComponentA, NPCanimatedComponent, bowAnimatedComponent	: CAnimatedComponent;
	private var settings, settings_SMOOTH, settingsA, settings_interrupt, settingsWraith, settingsNPC, bowAnimSettings						: SAnimatedComponentSlotAnimationSettings;
	private var vACS_Shield_Summon 																											: cACS_Shield_Summon;
	private const var DOUBLE_TAP_WINDOW																										: float;
	private var ccomp																														: CComponent;
	private var ccompEnabled																												: bool;
	private var weapontype 																													: EPlayerWeapon;
	private var res 																														: bool;
	
	default DOUBLE_TAP_WINDOW = 0.4;
		
	//Fist Attack Vars
	private var claw_fist_attack_index_1																									: int;
	default claw_fist_attack_index_1 																										= -1;

	private var claw_fist_attack_index_2																									: int;
	default claw_fist_attack_index_2 																										= -1;

	private var claw_fist_attack_index_3																									: int;
	default claw_fist_attack_index_2 																										= -1;

	private var previous_claw_fist_attack_index_1																							: int;
	default previous_claw_fist_attack_index_1 																								= -1;

	private var previous_claw_fist_attack_index_2																							: int;
	default previous_claw_fist_attack_index_2 																								= -1;

	private var previous_claw_fist_attack_index_3																							: int;
	default previous_claw_fist_attack_index_3 																								= -1;

	private var heavy_fist_attack_index_1																									: int;
	default heavy_fist_attack_index_1 																										= -1;
	private var heavy_fist_attack_index_2																									: int;
	default heavy_fist_attack_index_2 																										= -1;
	private var heavy_fist_attack_index_3																									: int;
	default heavy_fist_attack_index_3 																										= -1;

	private var previous_heavy_fist_attack_index_1																							: int;
	default previous_heavy_fist_attack_index_1 																								= -1;
	private var previous_heavy_fist_attack_index_2																							: int;
	default previous_heavy_fist_attack_index_2 																								= -1;
	private var previous_heavy_fist_attack_index_3																							: int;
	default previous_heavy_fist_attack_index_3 																								= -1;
	
	private var fist_attack_index_1																											: int;
	default fist_attack_index_1 																											= -1;														
	private var fist_attack_index_2																											: int;
	default fist_attack_index_2 																											= -1;
	private var fist_attack_index_3																											: int;
	default fist_attack_index_3 																											= -1;
															
	private var previous_fist_attack_index_1																								: int;
	default previous_fist_attack_index_1 																									= -1;
	private var previous_fist_attack_index_2																								: int;
	default previous_fist_attack_index_2 																									= -1;
	private var previous_fist_attack_index_3																								: int;
	default previous_fist_attack_index_3 																									= -1;
	
	//Guard Attack Vars
	private var GuardAttackCallTime																											: float;
	private var GuardAttackDoubleTap 																										: bool;
	
	private var kick_index_1																												: int;
	default kick_index_1 																													= -1;
	private var kick_index_2																												: int;
	default kick_index_2 																													= -1;
	private var previous_kick_index_1																										: int;
	default previous_kick_index_1 																											= -1;
	private var previous_kick_index_2																										: int;
	default previous_kick_index_2 																											= -1;
	
	private var push_index_1																												: int;
	default push_index_1 																													= -1;
	private var push_index_2																												: int;
	default push_index_2 																													= -1;
	private var previous_push_index_1																										: int;
	default previous_push_index_1 																											= -1;
	private var previous_push_index_2																										: int;
	default previous_push_index_2 																											= -1;
	
	private var punch_index_1																												: int;
	default punch_index_1 																													= -1;
	private var punch_index_2																												: int;
	default punch_index_2 																													= -1;
	private var previous_punch_index_1																										: int;
	default previous_punch_index_1 																											= -1;
	private var previous_punch_index_2																										: int;
	default previous_punch_index_2 																											= -1;
	
	private var igni_counter_index_1																										: int;
	default igni_counter_index_1 																											= -1;
	private var igni_counter_index_2																										: int;
	default igni_counter_index_2 																											= -1;
	private var igni_counter_index_3																										: int;
	default igni_counter_index_3 																											= -1;
	private var previous_igni_counter_index_1																								: int;
	default previous_igni_counter_index_1 																									= -1;
	private var previous_igni_counter_index_2																								: int;
	default previous_igni_counter_index_2 																									= -1;
	private var previous_igni_counter_index_3																								: int;
	default previous_igni_counter_index_3 																									= -1;
	
	private var aard_counter_index_1																										: int;
	default aard_counter_index_1 																											= -1;
	private var aard_counter_index_2																										: int;
	default aard_counter_index_2 																											= -1;
	private var previous_aard_counter_index_1																								: int;
	default previous_aard_counter_index_1 																									= -1;
	private var previous_aard_counter_index_2																								: int;
	default previous_aard_counter_index_2 																									= -1;
	
	private var quen_counter_index_1																										: int;
	default quen_counter_index_1 																											= -1;
	private var quen_counter_index_2																										: int;
	default quen_counter_index_2 																											= -1;
	private var previous_quen_counter_index_1																								: int;
	default previous_quen_counter_index_1 																									= -1;
	private var previous_quen_counter_index_2																								: int;
	default previous_quen_counter_index_2 																									= -1;
	
	private var yrden_counter_index_1																										: int;
	default yrden_counter_index_1 																											= -1;
	private var yrden_counter_index_2																										: int;
	default yrden_counter_index_2 																											= -1;
	private var previous_yrden_counter_index_1																								: int;
	default previous_yrden_counter_index_1 																									= -1;
	private var previous_yrden_counter_index_2																								: int;
	default previous_yrden_counter_index_2 																									= -1;
	
	private var axii_counter_index_1																										: int;
	default axii_counter_index_1 																											= -1;
	private var axii_counter_index_2																										: int;
	default axii_counter_index_2 																											= -1;
	private var previous_axii_counter_index_1																								: int;
	default previous_axii_counter_index_1 																									= -1;
	private var previous_axii_counter_index_2																								: int;
	default previous_axii_counter_index_2 																									= -1;
	
	//Claw Attack Vars
	private var vamp_sound_names																											: array< string >;

	private var heavy_claw_attack_index																										: int;
	private var previous_heavy_claw_attack_index																							: int;

	default heavy_claw_attack_index 																										= -1;
	default previous_heavy_claw_attack_index 																								= -1;
	
	private var claw_attack_index_1																											: int;
	default claw_attack_index_1 																											= -1;
	private var claw_attack_index_2																											: int;
	default claw_attack_index_2 																											= -1;
	private var claw_attack_index_3																											: int;
	default claw_attack_index_3 																											= -1;
	
	private var previous_claw_attack_index_1																								: int;
	default previous_claw_attack_index_1 																									= -1;
	private var previous_claw_attack_index_2																								: int;
	default previous_claw_attack_index_2 																									= -1;
	private var previous_claw_attack_index_3																								: int;
	default previous_claw_attack_index_3 																									= -1;
	
	private var claw_combo_attack_index_1																									: int;
	default claw_combo_attack_index_1 																										= -1;
	private var claw_combo_attack_index_2																									: int;
	default claw_combo_attack_index_2 																										= -1;
	private var claw_combo_attack_index_3																									: int;
	default claw_combo_attack_index_3 																										= -1;
	
	private var previous_claw_combo_attack_index_1																							: int;
	default previous_claw_combo_attack_index_1 																								= -1;
	private var previous_claw_combo_attack_index_2																							: int;
	default previous_claw_combo_attack_index_2 																								= -1;
	private var previous_claw_combo_attack_index_3																							: int;
	default previous_claw_combo_attack_index_3 																								= -1;
	
	private var attack_special_dash_index_1																									: int;
	default attack_special_dash_index_1 																									= -1;
	
	private var previous_attack_special_dash_index_1																						: int;
	default previous_attack_special_dash_index_1																							= -1;
	
	//Olgierd Attack Vars
	private var olgierd_attack_index_1																										: int;
	default olgierd_attack_index_1 																											= -1;
	private var olgierd_attack_index_2																										: int;
	default olgierd_attack_index_2 																											= -1;
	private var olgierd_attack_index_3																										: int;
	default olgierd_attack_index_3 																											= -1;
	private var previous_olgierd_attack_index_1																								: int;
	default previous_olgierd_attack_index_1 																								= -1;
	private var previous_olgierd_attack_index_2																								: int;
	default previous_olgierd_attack_index_2 																								= -1;
	private var previous_olgierd_attack_index_3																								: int;
	default previous_olgierd_attack_index_3 																								= -1;


	private var olgierd_heavy_attack_index_1																								: int;
	default olgierd_heavy_attack_index_1 																									= -1;
	private var olgierd_heavy_attack_index_2																								: int;
	default olgierd_heavy_attack_index_2 																									= -1;
	private var olgierd_heavy_attack_index_3																								: int;
	default olgierd_heavy_attack_index_3 																									= -1;
	private var previous_olgierd_heavy_attack_index_1																						: int;
	default previous_olgierd_heavy_attack_index_1 																							= -1;
	private var previous_olgierd_heavy_attack_index_2																						: int;
	default previous_olgierd_heavy_attack_index_2 																							= -1;
	private var previous_olgierd_heavy_attack_index_3																						: int;
	default previous_olgierd_heavy_attack_index_3 																							= -1;

	private var olgierd_heavy_attack_alt_index_1																							: int;
	default olgierd_heavy_attack_alt_index_1 																								= -1;
	private var olgierd_heavy_attack_alt_index_2																							: int;
	default olgierd_heavy_attack_alt_index_2 																								= -1;
	private var olgierd_heavy_attack_alt_index_3																							: int;
	default olgierd_heavy_attack_alt_index_3 																								= -1;
	private var previous_olgierd_heavy_attack_alt_index_1																					: int;
	default previous_olgierd_heavy_attack_alt_index_1 																						= -1;
	private var previous_olgierd_heavy_attack_alt_index_2																					: int;
	default previous_olgierd_heavy_attack_alt_index_2 																						= -1;
	private var previous_olgierd_heavy_attack_alt_index_3																					: int;
	default previous_olgierd_heavy_attack_alt_index_3 																						= -1;

	private var olgierd_light_attack_index_1																								: int;
	default olgierd_light_attack_index_1 																									= -1;
	private var olgierd_light_attack_index_2																								: int;
	default olgierd_light_attack_index_2 																									= -1;
	private var olgierd_light_attack_index_3																								: int;
	default olgierd_light_attack_index_3 																									= -1;
	private var previous_olgierd_light_attack_index_1																						: int;
	default previous_olgierd_light_attack_index_1 																							= -1;
	private var previous_olgierd_light_attack_index_2																						: int;
	default previous_olgierd_light_attack_index_2 																							= -1;
	private var previous_olgierd_light_attack_index_3																						: int;
	default previous_olgierd_light_attack_index_3 																							= -1;

	private var olgierd_light_attack_alt_index_1																							: int;
	default olgierd_light_attack_alt_index_1 																								= -1;
	private var olgierd_light_attack_alt_index_2																							: int;
	default olgierd_light_attack_alt_index_2 																								= -1;
	private var olgierd_light_attack_alt_index_3																							: int;
	default olgierd_light_attack_alt_index_3 																								= -1;
	private var previous_olgierd_light_attack_alt_index_1																					: int;
	default previous_olgierd_light_attack_alt_index_1 																						= -1;
	private var previous_olgierd_light_attack_alt_index_2																					: int;
	default previous_olgierd_light_attack_alt_index_2 																						= -1;
	private var previous_olgierd_light_attack_alt_index_3																					: int;
	default previous_olgierd_light_attack_alt_index_3 																						= -1;
	
	private var olgierd_pirouette_index_1																									: int;
	default olgierd_pirouette_index_1 																										= -1;
	private var olgierd_pirouette_index_2																									: int;
	default olgierd_pirouette_index_2 																										= -1;
	private var previous_olgierd_pirouette_index_1																							: int;
	default previous_olgierd_pirouette_index_1 																								= -1;
	private var previous_olgierd_pirouette_index_2																							: int;
	default previous_olgierd_pirouette_index_2 																								= -1;
	
	private var olgierd_shadow_attack_index_1																								: int;	
	default olgierd_shadow_attack_index_1 																									= -1;
	private var olgierd_shadow_attack_index_2																								: int;
	default olgierd_shadow_attack_index_2 																									= -1;
	private var previous_olgierd_shadow_attack_index_1																						: int;	
	default previous_olgierd_shadow_attack_index_1 																							= -1;
	private var previous_olgierd_shadow_attack_index_2																						: int;
	default previous_olgierd_shadow_attack_index_2 																							= -1;

	private var olgierd_shadow_attack_part_2_index_1																						: int;	
	default olgierd_shadow_attack_part_2_index_1 																							= -1;
	private var olgierd_shadow_attack_part_2_index_2																						: int;
	default olgierd_shadow_attack_part_2_index_2 																							= -1;
	private var previous_olgierd_shadow_attack_part_2_index_1																				: int;	
	default previous_olgierd_shadow_attack_part_2_index_1 																					= -1;
	private var previous_olgierd_shadow_attack_part_2_index_2																				: int;
	default previous_olgierd_shadow_attack_part_2_index_2 																					= -1;
	
	private var olgierd_combo_attack_index_1																								: int;	
	default olgierd_combo_attack_index_1 																									= -1;
	private var olgierd_combo_attack_index_2																								: int;	
	default olgierd_combo_attack_index_2 																									= -1;
	private var previous_olgierd_combo_attack_index_1																						: int;	
	default previous_olgierd_combo_attack_index_1 																							= -1;
	private var previous_olgierd_combo_attack_index_2																						: int;	
	default previous_olgierd_combo_attack_index_2 																							= -1;
	
	//Eredin Attack Vars
	private var eredin_attack_index_1																										: int;
	default eredin_attack_index_1 																											= -1;
	private var eredin_attack_index_2																										: int;
	default eredin_attack_index_2 																											= -1;
	private var eredin_attack_index_3																										: int;
	default eredin_attack_index_3 																											= -1;
	private var previous_eredin_attack_index_1																								: int;
	default previous_eredin_attack_index_1 																									= -1;
	private var previous_eredin_attack_index_2																								: int;
	default previous_eredin_attack_index_2 																									= -1;
	private var previous_eredin_attack_index_3																								: int;
	default previous_eredin_attack_index_3 																									= -1;
	
	private var eredin_combo_attack_index_1																									: int;
	default eredin_combo_attack_index_1 																									= -1;
	private var eredin_combo_attack_index_2																									: int;
	default eredin_combo_attack_index_2 																									= -1;
	private var eredin_combo_attack_index_3																									: int;
	default eredin_combo_attack_index_3 																									= -1;
	private var previous_eredin_combo_attack_index_1																						: int;
	default previous_eredin_combo_attack_index_1 																							= -1;
	private var previous_eredin_combo_attack_index_2																						: int;
	default previous_eredin_combo_attack_index_2 																							= -1;
	private var previous_eredin_combo_attack_index_3																						: int;
	default previous_eredin_combo_attack_index_3 																							= -1;
	
	private var eredin_stab_index																											: int;
	default eredin_stab_index 																												= -1;
	private var previous_eredin_stab_index																									: int;
	default previous_eredin_stab_index 																										= -1;
	
	//Imlerith Attack Vars
	private var imlerith_attack_index_1																										: int;
	private var imlerith_attack_index_2																										: int;
	private var imlerith_attack_index_3																										: int;
	private var previous_imlerith_attack_index_1																							: int;
	private var previous_imlerith_attack_index_2																							: int;
	private var previous_imlerith_attack_index_3																							: int;

	default imlerith_attack_index_1 																										= -1;
	default imlerith_attack_index_2 																										= -1;
	default imlerith_attack_index_3 																										= -1;
	default previous_imlerith_attack_index_1 																								= -1;
	default previous_imlerith_attack_index_2 																								= -1;
	default previous_imlerith_attack_index_3 																								= -1;
	
	private var imlerith_berserk_attack_index_1																								: int;
	private var imlerith_berserk_attack_index_2																								: int;
	private var imlerith_berserk_attack_index_3																								: int;
	private var previous_imlerith_berserk_attack_index_1																					: int;
	private var previous_imlerith_berserk_attack_index_2																					: int;
	private var previous_imlerith_berserk_attack_index_3																					: int;

	default imlerith_berserk_attack_index_1 																								= -1;
	default imlerith_berserk_attack_index_2 																								= -1;
	default imlerith_berserk_attack_index_3 																								= -1;
	default previous_imlerith_berserk_attack_index_1 																						= -1;
	default previous_imlerith_berserk_attack_index_2 																						= -1;
	default previous_imlerith_berserk_attack_index_3 																						= -1;
	
	private var imlerith_walk_attack_index_1																								: int;
	private var imlerith_walk_attack_index_2																								: int;
	private var previous_imlerith_walk_attack_index_1																						: int;
	private var previous_imlerith_walk_attack_index_2																						: int;

	default imlerith_walk_attack_index_1 																									= -1;
	default imlerith_walk_attack_index_2 																									= -1;
	default previous_imlerith_walk_attack_index_1 																							= -1;
	default previous_imlerith_walk_attack_index_2 																							= -1;
	
	private var imlerith_combo_attack_index_1																								: int;
	private var imlerith_combo_attack_index_2																								: int;
	private var previous_imlerith_combo_attack_index_1																						: int;
	private var previous_imlerith_combo_attack_index_2																						: int;

	default imlerith_combo_attack_index_1 																									= -1;
	default imlerith_combo_attack_index_2 																									= -1;
	default previous_imlerith_combo_attack_index_1 																							= -1;
	default previous_imlerith_combo_attack_index_2 																							= -1;
	
	//Spear Attack Vars
	
	private var spear_attack_index_1																										: int;
	private var spear_attack_index_2																										: int;
	private var spear_attack_index_3																										: int;
	private var previous_spear_attack_index_1																								: int;
	private var previous_spear_attack_index_2																								: int;
	private var previous_spear_attack_index_3																								: int;

	default spear_attack_index_1 																											= -1;
	default spear_attack_index_2 																											= -1;
	default spear_attack_index_3 																											= -1;
	default previous_spear_attack_index_1 																									= -1;
	default previous_spear_attack_index_2 																									= -1;
	default previous_spear_attack_index_3 																									= -1;
	
	private var spear_special_attack_index_1																								: int;
	private var spear_special_attack_index_2																								: int;
	private var spear_special_attack_index_3																								: int;
	private var previous_spear_special_attack_index_1																						: int;
	private var previous_spear_special_attack_index_2																						: int;
	private var previous_spear_special_attack_index_3																						: int;

	default spear_special_attack_index_1 																									= -1;
	default spear_special_attack_index_2 																									= -1;
	default spear_special_attack_index_3 																									= -1;
	default previous_spear_special_attack_index_1 																							= -1;
	default previous_spear_special_attack_index_2 																							= -1;
	default previous_spear_special_attack_index_3 																							= -1;
	
	//Hammer Attack Vars
	
	private var hammer_attack_index_1																										: int;
	private var hammer_attack_index_2																										: int;
	private var previous_hammer_attack_index_1																								: int;
	private var previous_hammer_attack_index_2																								: int;

	default hammer_attack_index_1 																											= -1;
	default hammer_attack_index_2 																											= -1;
	default previous_hammer_attack_index_1 																									= -1;
	default previous_hammer_attack_index_2 																									= -1;
	
	private var hammer_special_attack_index_1																								: int;
	private var hammer_special_attack_index_2																								: int;
	private var previous_hammer_special_attack_index_1																						: int;	
	private var previous_hammer_special_attack_index_2																						: int;

	default hammer_special_attack_index_1 																									= -1;
	default hammer_special_attack_index_2 																									= -1;
	default previous_hammer_special_attack_index_1 																							= -1;
	default previous_hammer_special_attack_index_2 																							= -1;
	
	//Axe Attack Vars
	private var axe_attack_index_1																											: int;
	private var axe_attack_index_2																											: int;
	private var previous_axe_attack_index_1																									: int;
	private var previous_axe_attack_index_2																									: int;

	default axe_attack_index_1 																												= -1;
	default axe_attack_index_2 																												= -1;
	default previous_axe_attack_index_1 																									= -1;
	default previous_axe_attack_index_2 																									= -1;
	
	private var axe_special_attack_index_1																									: int;
	private var axe_special_attack_index_2																									: int;
	private var previous_axe_special_attack_index_1																							: int;
	private var previous_axe_special_attack_index_2																							: int;

	default axe_special_attack_index_1 																										= -1;
	default axe_special_attack_index_2 																										= -1;
	default previous_axe_special_attack_index_1 																							= -1;
	default previous_axe_special_attack_index_2 																							= -1;
	
	//Greg Attack Vars
	private var greg_attack_index_1																											: int;
	private var greg_attack_index_2																											: int;
	private var previous_greg_attack_index_1																								: int;
	private var previous_greg_attack_index_2																								: int;

	default greg_attack_index_1 																											= -1;
	default greg_attack_index_2 																											= -1;
	default previous_greg_attack_index_1 																									= -1;
	default previous_greg_attack_index_2 																									= -1;
	
	private var greg_special_attack_index_1																									: int;
	private var greg_special_attack_index_2																									: int;
	private var previous_greg_special_attack_index_1																						: int;
	private var previous_greg_special_attack_index_2																						: int;

	default greg_special_attack_index_1 																									= -1;
	default greg_special_attack_index_2 																									= -1;
	default previous_greg_special_attack_index_1 																							= -1;
	default previous_greg_special_attack_index_2 																							= -1;
	
	//Bruxa Bite Vars
	private var bruxa_bite_index_1																											: int; 
	private var previous_bruxa_bite_index_1																									: int;

	default bruxa_bite_index_1 																												= -1;
	default previous_bruxa_bite_index_1 																									= -1;
	
	private var bruxa_bite_repeat_index_1																									: int;
	private var previous_bruxa_bite_repeat_index_1																							: int;

	default bruxa_bite_repeat_index_1 																										= -1;
	default previous_bruxa_bite_repeat_index_1 																								= -1;
	
	private var victimPos, newVictimPos																										: Vector;
	private var victimRot 																													: EulerAngles;
	private var playerPos																													: Vector;
	private var playerRot 																													: EulerAngles;
	
	//Movement Vars
	private var BruxaDashCallTime																											: float;
	private var BruxaDashDoubleTap 																											: bool;
	
	private var bruxa_dash_index_1																											: int;	
	private var bruxa_dash_index_2																											: int;
	private var previous_bruxa_dash_index_1																									: int;	
	private var previous_bruxa_dash_index_2																									: int;

	default bruxa_dash_index_1 																												= -1;
	default bruxa_dash_index_2 																												= -1;
	default previous_bruxa_dash_index_1 																									= -1;
	default previous_bruxa_dash_index_2 																									= -1;
	
	//On-hit Vars
	private var heal, playerVitality 																										: float;
	private var maxAdrenaline																												: float;
	private var curAdrenaline																												: float;
	private var marks, marks_2 																												: array< CEntity >;
	private var mark       																													: CEntity;
	private var targetRotationNPC, npcRot																									: EulerAngles;
	private var npcPos																														: Vector;
	private var npc 																														: CActor;
	private var actors		    																											: array<CActor>;
	private var i         																													: int;
	private var actortarget					       																							: CActor;
	private var damage_action			 																									: W3Action_Attack;
	private var dmg																															: W3DamageAction;
	
	//Shield Anim Stuff
	private var shieldAnimatedComponent 																									: CAnimatedComponent;
	private var shieldAnimSettings																											: SAnimatedComponentSlotAnimationSettings;
	private var shieldMovementAdjustor																										: CMovementAdjustor; 
	private var shieldTicket 																												: SMovementAdjustmentRequestTicket; 

	private var acs_shield_attack_index_1																									: int;
	private var previous_acs_shield_attack_index_1																							: int;

	default acs_shield_attack_index_1 																										= -1;
	default previous_acs_shield_attack_index_1 																								= -1;

	private var curTargetVitality, maxTargetVitality, curTargetEssence, maxTargetEssence, damageMax, damageMin								: float;
	
	private var blood_fx		 																											: array<CName>;

	private var previous_player_comment_index_COMBAT_END																					: int;	
	private var player_comment_index_COMBAT_END																								: int;

	default previous_player_comment_index_COMBAT_END 																						= -1;
	default player_comment_index_COMBAT_END 																								= -1;

	// Fear Vars
	private var fear_index_1																												: int;
	private var previous_fear_index_1																										: int;

	default fear_index_1 																													= -1;
	default previous_fear_index_1 																											= -1;

	private var action 																														: W3DamageAction;
	private var curVitality, damage																											: float;
	
	// Wraith Vars
	private var dest1																														: Vector;	
	private var pRot 																														: EulerAngles;

	private var attach_vec, bone_vec																										: Vector;
	private var attach_rot, bone_rot																										: EulerAngles;

	private var steelID, silverID 																											: SItemUniqueId;
	private var steelsword, silversword																										: CDrawableComponent;

	// Camera Vars
	private var camera 																														: CCustomCamera;

	var previous_weapon_cutscene_index																										: int;
	var weapon_cutscene_index																												: int;

	default previous_weapon_cutscene_index 																									= -1;
	default weapon_cutscene_index 																											= -1;

	var previous_player_comment_index_EQUIP_TAUNT																							: int;	
	var player_comment_index_EQUIP_TAUNT																									: int;
	var previous_player_comment_index_COMBAT_TAUNT																							: int;	
	var player_comment_index_COMBAT_TAUNT																									: int;

	default previous_player_comment_index_EQUIP_TAUNT = -1;
	default player_comment_index_EQUIP_TAUNT 																								= -1;
	default previous_player_comment_index_COMBAT_TAUNT 																						= -1;
	default player_comment_index_COMBAT_TAUNT 																								= -1;

	var previous_claw_taunt_index																											: int;	
	var claw_taunt_index																													: int;

	var previous_olgierd_taunt_index																										: int;	
	var olgierd_taunt_index																													: int;

	var previous_regular_taunt_index																										: int;	
	var regular_taunt_index																													: int;

	var previous_imlerith_taunt_index																										: int;	
	var imlerith_taunt_index																												: int;

	var previous_eredin_taunt_index																											: int;	
	var eredin_taunt_index																													: int;

	var previous_olgierd_combat_taunt_index_1																								: int;
	var previous_olgierd_combat_taunt_index_2																								: int;

	var olgierd_combat_taunt_index_1																										: int;
	var olgierd_combat_taunt_index_2																										: int;

	var previous_eredin_combat_taunt_index_1																								: int;
	var previous_eredin_combat_taunt_index_2																								: int;

	var eredin_combat_taunt_index_1																											: int;
	var eredin_combat_taunt_index_2																											: int;

	var previous_imlerith_combat_taunt_index_1																								: int;
	var previous_imlerith_combat_taunt_index_2																								: int;

	var imlerith_combat_taunt_index_1																										: int;
	var imlerith_combat_taunt_index_2																										: int;

	var previous_normal_combat_taunt_index_1																								: int;
	var previous_normal_combat_taunt_index_2																								: int;

	var normal_combat_taunt_index_1																											: int;
	var normal_combat_taunt_index_2																											: int;

	default previous_claw_taunt_index 																										= -1;
	default claw_taunt_index 																												= -1;
	default previous_olgierd_taunt_index 																									= -1;
	default olgierd_taunt_index 																											= -1;
	default previous_regular_taunt_index 																									= -1;
	default regular_taunt_index 																											= -1;
	default previous_imlerith_taunt_index 																									= -1;
	default imlerith_taunt_index 																											= -1;
	default previous_eredin_taunt_index 																									= -1;
	default eredin_taunt_index 																												= -1;
	default previous_olgierd_combat_taunt_index_1 																							= -1;
	default previous_olgierd_combat_taunt_index_2 																							= -1;
	default olgierd_combat_taunt_index_1 																									= -1;
	default olgierd_combat_taunt_index_2 																									= -1;
	default previous_eredin_combat_taunt_index_1 																							= -1;
	default previous_eredin_combat_taunt_index_2 																							= -1;
	default eredin_combat_taunt_index_1 																									= -1;
	default eredin_combat_taunt_index_2 																									= -1;
	default previous_imlerith_combat_taunt_index_1 																							= -1;
	default previous_imlerith_combat_taunt_index_2 																							= -1;
	default imlerith_combat_taunt_index_1 																									= -1;
	default imlerith_combat_taunt_index_2 																									= -1;
	default previous_normal_combat_taunt_index_1																							= -1;
	default previous_normal_combat_taunt_index_2 																							= -1;
	default normal_combat_taunt_index_1 																									= -1;
	default normal_combat_taunt_index_2 																									= -1;

	var vACS_Cooldown_Manager																												: ACS_Cooldown_Manager; 
	var vACS_Manual_Sword_Drawing_Check																										: ACS_Manual_Sword_Drawing_Check;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		CreateAttachment( thePlayer );	
		
		AddTimer('ACS_BARADDUR', 0.000000000000000001f, true); 
		
		AddTimer( 'ACS_INIT_TIMER', 0.001f, false );
	}

	public timer function ACS_BARADDUR ( dt : float, id : int){ ACS_BARRADUR(); } 

	public timer function ACS_ResetAnimation ( dt: float, id : int){ thePlayer.ClearAnimationSpeedMultipliers(); } 
	
	public timer function ACS_dodge_timer ( dt : float, id : int) { dodge_timer_actual(); } 
	
	public timer function ACS_dodge_timer_slideback ( dt : float, id : int) { dodge_timer_slideback_actual();} 
	
	public timer function ACS_dodge_timer_wildhunt ( dt : float, id : int) { dodge_timer_wildhunt_actual(); } 
	
	public timer function ACS_hide_timer ( dt : float, id : int) { thePlayer.SetVisibility( false ); } 
	
	public timer function ACS_dodge_timer_attack ( dt : float, id : int) { dodge_timer_attack_actual(); } 
	
	public timer function ACS_dodge_timer_end ( dt : float, id : int) { dodge_timer_end_actual();} 
	
	public timer function ACS_bruxa_bite_delay ( dt : float, id : int) { bruxa_bite(); } 
	
	public timer function ACS_blood_suck_victim_paralyze ( dt : float, id : int) {blood_suck_victim_paralyze_actual();} 
	
	public timer function ACS_bruxa_blood_suck_repeat ( dt : float, id : int) {bruxa_blood_suck_repeat_actual();} 
	
	public timer function ACS_bruxa_tackle ( dt : float, id : int) { bruxa_tackle_actual(); } 
	
	public timer function ACS_alive_check ( dt : float, id : int) {alive_check_actual();} 
	
	public timer function ACS_shout ( dt: float, id : int) { thePlayer.PlayEffect('shout'); thePlayer.StopEffect('shout'); } 
	
	public timer function ACS_portable_aard ( dt : float, id : int){ACS_Giant_Shockwave();} 
	
	public timer function ACS_wraith ( dt : float, id : int){ wraith_actual(); } 
	
	public timer function ACS_collision_delay ( dt : float, id : int){ thePlayer.EnableCollisions(true); } 
	
	public timer function ACS_bruxa_camo_npc_reaction ( dt : float, id : int){ NPC_Fear_Reaction_Geralt(); } 
	
	public timer function ACS_npc_fear_reaction ( dt : float, id : int){ NPC_Fear_Reaction(); } 

	public timer function ACS_ShootBowMoving ( dt : float, id : int){ geraltShootBowMoving(); } 

	public timer function ACS_ShootBowStationary ( dt : float, id : int){ geraltShootBowStationary(); } 

	public timer function ACS_Arrow_Create_Delay ( dt : float, id : int){ ACS_Arrow_Create(); PlayBowAnim_Reset();} 

	public timer function ACS_Arrow_Shoot_Delay ( dt : float, id : int){ ACS_Shoot_Bow(); } 

	public timer function ACS_ShootBowToIdle ( dt : float, id : int){ PlayBowAnim_ShootToIdle(); } 

	public timer function ACS_ShootCrossbowToIdle ( dt : float, id : int){ PlayCrossbowAnim_ShootToIdle(); } 

	public timer function ACS_ShootCrossbowToAim ( dt : float, id : int){ PlayCrossbowAnim_ShootToAim(); } 
	
	public timer function ACS_HijackMoveForward(deltaTime : float , id : int){HijackMoveForwardActual();}
	
	public timer function ACS_Weapon_Summon_Delay(deltaTime : float , id : int){sword_summon_effect();}
	
	public timer function ACS_ExplorationDelay(deltaTime : float , id : int){ACS_ExplorationDelay_actual();}

	public timer function ACS_WeaponEquipDelay(deltaTime : float , id : int){ACS_RandomWeaponEquipInit();}

	public timer function ACS_HeadbuttDamage(deltaTime : float , id : int){HeadbuttDamageActual();}

	public timer function ACS_INIT_TIMER( deltaTime : float , id : int)
	{
		register_extra_inputs();

		if(!thePlayer.IsCiri())
		{
			ACS_Init_Attempt();
			
			if(ACS_Enabled())
			{
				ACS_BehSwitchINIT(); 
				
				ACSCheck();
			}
		}
	}

	function register_extra_inputs()
	{
		theInput.UnregisterListener( thePlayer.GetInputHandler(), 'MovementDoubleTapW' );

		theInput.UnregisterListener( thePlayer.GetInputHandler(), 'MovementDoubleTapS' ); 

		theInput.UnregisterListener( thePlayer.GetInputHandler(), 'MovementDoubleTapA' ); 

		theInput.UnregisterListener( thePlayer.GetInputHandler(), 'MovementDoubleTapD' ); 

		theInput.UnregisterListener( thePlayer.GetInputHandler(), 'Dodge' );

		theInput.RegisterListener( this, 'OnMovementDoubleTapW', 'MovementDoubleTapW' );

		theInput.RegisterListener( this, 'OnMovementDoubleTapS', 'MovementDoubleTapS' ); 

		theInput.RegisterListener( this, 'OnMovementDoubleTapA', 'MovementDoubleTapA' ); 

		theInput.RegisterListener( this, 'OnMovementDoubleTapD', 'MovementDoubleTapD' ); 

		theInput.RegisterListener( this, 'OnMoveForward', 'GI_AxisLeftY' );

		theInput.RegisterListener( this, 'OnCbtDodge', 'Dodge' );

		theInput.RegisterListener(this, 'OnBruxaBite', 'BruxaBite');

		///////////////////////////////////////////////////////////////////////////////////////////////////////////

		theInput.UnregisterListener( thePlayer.GetInputHandler(), 'AttackHeavy' );

		theInput.RegisterListener( this, 'OnCbtAttackHeavy', 'AttackHeavy' );

		theInput.UnregisterListener( thePlayer.GetInputHandler(), 'AttackWithAlternateLight' );

		theInput.RegisterListener( this, 'OnCbtAttackWithAlternateLight', 'AttackWithAlternateLight' );

		theInput.UnregisterListener( thePlayer.GetInputHandler(), 'AttackWithAlternateHeavy' );

		theInput.RegisterListener( this, 'OnCbtAttackWithAlternateHeavy', 'AttackWithAlternateHeavy' );

		theInput.UnregisterListener( thePlayer.GetInputHandler(), 'AttackLight' );

		theInput.RegisterListener( this, 'OnCbtAttackLight', 'AttackLight' );

		theInput.UnregisterListener( thePlayer.GetInputHandler(), 'SpecialAttackLight' );

		theInput.RegisterListener( this, 'OnCbtSpecialAttackLight', 'SpecialAttackLight' );

		theInput.UnregisterListener( thePlayer.GetInputHandler(), 'SpecialAttackWithAlternateLight' );

		theInput.RegisterListener( this, 'OnCbtSpecialAttackWithAlternateLight', 'SpecialAttackWithAlternateLight' );

		theInput.UnregisterListener( thePlayer.GetInputHandler(), 'SpecialAttackWithAlternateHeavy' );

		theInput.RegisterListener( this, 'OnCbtSpecialAttackWithAlternateHeavy', 'SpecialAttackWithAlternateHeavy' );

		theInput.UnregisterListener( thePlayer.GetInputHandler(), 'ToggleSigns' );

		theInput.RegisterListener( this, 'OnToggleSigns', 'ToggleSigns' );

		theInput.UnregisterListener( thePlayer.GetInputHandler(), 'SpecialAttackHeavy' );

		theInput.RegisterListener( this, 'OnCbtSpecialAttackHeavy', 'SpecialAttackHeavy' );

		theInput.UnregisterListener( thePlayer.GetInputHandler(), 'CbtRoll' );

		theInput.RegisterListener( this, 'OnCbtRoll', 'CbtRoll' );

		theInput.UnregisterListener( thePlayer.GetInputHandler(), 'LockAndGuard' );

		theInput.RegisterListener( this, 'OnCbtLockAndGuard', 'LockAndGuard' );
	}
	

	event OnCbtAttackWithAlternateLight( action : SInputAction )
	{
		CbtAttackPC( action, false);
	}
	
	event OnCbtAttackWithAlternateHeavy( action : SInputAction )
	{
		CbtAttackPC( action, true);
	}
	
	function CbtAttackPC( action : SInputAction, isHeavy : bool )
	{
		var switchAttackType : bool;
		
		switchAttackType = ShouldSwitchAttackType();
		
		if ( !theInput.LastUsedPCInput() )
		{
			return;
		}
		
		if ( thePlayer.IsCiri() )
		{
			if ( switchAttackType != isHeavy) 
			{
				thePlayer.GetInputHandler().OnCbtCiriAttackHeavy(action);
			}
			else
			{
				OnCbtAttackLight(action);
			}
		}
		else
		{
			if ( switchAttackType != isHeavy) 
			{
				OnCbtAttackHeavy(action);
			}
			else
			{
				OnCbtAttackLight(action);
			}
		}
	}

	private function ShouldSwitchAttackType():bool
	{
		var outKeys : array<EInputKey>;	
		
		if ( theInput.LastUsedPCInput() )
		{		
			theInput.GetPCKeysForAction('PCAlternate',outKeys);
			if ( outKeys.Size() > 0 )
			{
				if ( theInput.IsActionPressed('PCAlternate') )
				{
					return true;
				}
			}
		}
		return false;
	}

	event OnCommSprint( action : SInputAction )
	{
		if ( IsPressed( action ) && ACS_Enabled() ) { BruxaDash(); } //ACS
		if( IsPressed( action ) )
		{
			thePlayer.SetSprintActionPressed(true);
			
			if ( thePlayer.rangedWeapon )
				thePlayer.rangedWeapon.OnSprintHolster();
		}
	}

	event OnCbtAttackLight( action : SInputAction )
	{
		var allowed, checkedFists 			: bool;
		
		if( IsPressed(action) )
		{
			if( thePlayer.IsActionAllowed(EIAB_LightAttacks)  )
			{
				if (thePlayer.GetBIsInputAllowed())
				{
					allowed = false;					
					
					if( thePlayer.GetCurrentMeleeWeaponType() == PW_Fists || thePlayer.GetCurrentMeleeWeaponType() == PW_None )
					{
						if ( ACS_Enabled() ) { checkedFists = true; if(thePlayer.IsActionAllowed(EIAB_Fists)) {allowed = true;} ClawFistLightAttack(); return true; } //ACS
						checkedFists = true;
						if(thePlayer.IsActionAllowed(EIAB_Fists))
							allowed = true;
					}
					else if(thePlayer.IsActionAllowed(EIAB_SwordAttack))
					{
						checkedFists = false;
						allowed = true;
					}
					
					if(allowed)
					{
						if ( ACS_Enabled() ) { LightAttackSwitch(); return true; } //ACS
						thePlayer.SetupCombatAction( EBAT_LightAttack, BS_Pressed );
					}
					else
					{
						if(checkedFists)
							thePlayer.DisplayActionDisallowedHudMessage(EIAB_Fists);
						else
							thePlayer.DisplayActionDisallowedHudMessage(EIAB_SwordAttack);
					}
				}
			}
			else  if ( !thePlayer.IsActionBlockedBy(EIAB_LightAttacks,'interaction') )
			{
				thePlayer.DisplayActionDisallowedHudMessage(EIAB_LightAttacks);
			}
		}
	}

	event OnCbtSpecialAttackLight( action : SInputAction )
	{
		if ( IsReleased( action )  )
		{
			thePlayer.CancelHoldAttacks();
			return true;
		}
		
		if ( !IsPlayerAbleToPerformSpecialAttack() )
			return false;
		
		if( !thePlayer.IsActionAllowed(EIAB_LightAttacks) ) 
		{
			thePlayer.DisplayActionDisallowedHudMessage(EIAB_LightAttacks);
			return false;
		}
		if(!thePlayer.IsActionAllowed(EIAB_SpecialAttackLight) )
		{
			thePlayer.DisplayActionDisallowedHudMessage(EIAB_SpecialAttackLight);
			return false;
		}
		
		if( IsPressed(action) && thePlayer.CanUseSkill(S_Sword_s01) )	
		{
			if ( ACS_Enabled() ) { SpecialAttackSwitch(); return true; } //ACS
			thePlayer.PrepareToAttack();
			thePlayer.SetPlayedSpecialAttackMissingResourceSound(false);
			thePlayer.AddTimer( 'IsSpecialLightAttackInputHeld', 0.00001, true );
		}
	}

	event OnToggleSigns( action : SInputAction )
	{
		var tolerance : float;
		tolerance = 2.5f;
		
		if( action.value < -tolerance )
		{
			GetWitcherPlayer().TogglePreviousSign();
			if ( ACS_Enabled() ) { ACS_SignSwitchArsenalInit(); } //ACS
		}
		else if( action.value > tolerance )
		{
			GetWitcherPlayer().ToggleNextSign();
			if ( ACS_Enabled() ) { ACS_SignSwitchArsenalInit(); } //ACS
		}
	}

	event OnCbtAttackHeavy( action : SInputAction )
	{
		var allowed, checkedSword : bool;
		var outKeys : array<EInputKey>;
		
		if ( thePlayer.GetBIsInputAllowed() )
		{
			if( thePlayer.IsActionAllowed(EIAB_HeavyAttacks) )
			{
				allowed = false;
				
				if( thePlayer.GetCurrentMeleeWeaponType() == PW_Fists || thePlayer.GetCurrentMeleeWeaponType() == PW_None )
				{
					checkedSword = false;
					if(thePlayer.IsActionAllowed(EIAB_Fists))
						allowed = true;
				}
				else if(thePlayer.IsActionAllowed(EIAB_SwordAttack))
				{
					checkedSword = true;
					allowed = true;
				}
				
				if(allowed)
				{
					if ( ( thePlayer.GetCurrentMeleeWeaponType() == PW_Fists || thePlayer.GetCurrentMeleeWeaponType() == PW_None ) && IsPressed(action)  )
					{
						if ( ACS_Enabled() ) { ClawFistHeavyAttack(); return true; } //ACS
						thePlayer.SetupCombatAction( EBAT_HeavyAttack, BS_Released );				
					}
					else
					{
						if( IsReleased(action) && theInput.GetLastActivationTime( action.aName ) < 0.2 )
						{
							if ( ACS_Enabled() ) { HeavyAttackSwitch(); return true; } //ACS
							thePlayer.SetupCombatAction( EBAT_HeavyAttack, BS_Released );
						}
					}
				}
				else
				{
					if(checkedSword)
						thePlayer.DisplayActionDisallowedHudMessage(EIAB_SwordAttack);
					else					
						thePlayer.DisplayActionDisallowedHudMessage(EIAB_Fists);
				}
			}
			else if ( !thePlayer.IsActionBlockedBy(EIAB_HeavyAttacks,'interaction') )
			{
				thePlayer.DisplayActionDisallowedHudMessage(EIAB_HeavyAttacks);
			}
		}
	}

	event OnCbtSpecialAttackWithAlternateLight( action : SInputAction )
	{
		CbSpecialAttackPC( action, false);
	}
	
	event OnCbtSpecialAttackWithAlternateHeavy( action : SInputAction )
	{
		CbSpecialAttackPC( action, true);
	}
	
	function CbSpecialAttackPC( action : SInputAction, isHeavy : bool ) 
	{
		var switchAttackType : bool;
		
		switchAttackType = ShouldSwitchAttackType();
		
		if ( !theInput.LastUsedPCInput() )
		{
			return;
		}
		
		if ( IsPressed(action) )
		{
			if ( thePlayer.IsCiri() )
			{
				
				thePlayer.GetInputHandler().OnCbtCiriSpecialAttackHeavy(action);
			}
			else
			{
				if (switchAttackType != isHeavy) 
				{
					OnCbtSpecialAttackHeavy(action);
				}
				else
				{
					OnCbtSpecialAttackLight(action);
				}
			}
		}
		else if ( IsReleased( action ) )
		{
			if ( thePlayer.IsCiri() )
			{
				thePlayer.GetInputHandler().OnCbtCiriSpecialAttackHeavy(action);
			}
			else
			{
				
				OnCbtSpecialAttackHeavy(action);
				OnCbtSpecialAttackLight(action);
			}
		}
	}

	event OnCbtSpecialAttackHeavy( action : SInputAction )
	{
		if ( IsReleased( action )  )
		{
			thePlayer.CancelHoldAttacks();
			return true;
		}
		
		if ( !IsPlayerAbleToPerformSpecialAttack() )
			return false;
		
		if( !thePlayer.IsActionAllowed(EIAB_HeavyAttacks))
		{
			thePlayer.DisplayActionDisallowedHudMessage(EIAB_HeavyAttacks);
			return false;
		}		
		if(!thePlayer.IsActionAllowed(EIAB_SpecialAttackHeavy))
		{
			thePlayer.DisplayActionDisallowedHudMessage(EIAB_SpecialAttackHeavy);
			return false;
		}
		
		if( IsPressed(action) && thePlayer.CanUseSkill(S_Sword_s02) )	
		{	
			thePlayer.PrepareToAttack();
			thePlayer.SetPlayedSpecialAttackMissingResourceSound(false);
			if ( ACS_Enabled() ) { action_interrupt(); } //ACS
			thePlayer.AddTimer( 'IsSpecialHeavyAttackInputHeld', 0.00001, true );
		}
		else if ( IsPressed(action) )
		{
			if ( ACS_Enabled() ) { action_interrupt(); } //ACS
			if ( theInput.IsActionPressed('AttackHeavy') )
				theInput.ForceDeactivateAction('AttackHeavy');
			else if ( theInput.IsActionPressed('AttackWithAlternateHeavy') )
				theInput.ForceDeactivateAction('AttackWithAlternateHeavy');
		}
	}

	event OnCbtRoll( action : SInputAction )
	{
		if ( theInput.LastUsedPCInput() )
		{
			if ( IsPressed( action ) )
			{
				if ( ACS_Enabled() ) { ACS_WildHuntBlinkInit(); return true;} //ACS
				thePlayer.EvadePressed(EBAT_Roll);
			}
		}
		else
		{
			if ( IsPressed( action ) )
			{
				thePlayer.StartDodgeTimer();
			}
			else if ( IsReleased( action ) )
			{
				if ( thePlayer.IsDodgeTimerRunning() )
				{
					if ( ACS_Enabled() ) { thePlayer.StopDodgeTimer(); if ( !thePlayer.IsInsideInteraction() ) { ACS_WildHuntBlinkInit(); } return true; } //ACS
					thePlayer.StopDodgeTimer();
					if ( !thePlayer.IsInsideInteraction() )
						thePlayer.EvadePressed(EBAT_Roll);
				}
				
			}
		}
	}

	event OnCbtLockAndGuard( action : SInputAction )
	{
		if(thePlayer.IsCiri() && !GetCiriPlayer().HasSword())
			return false;
		
		
		if( IsReleased(action) )
		{
			thePlayer.SetGuarded(false);
			thePlayer.OnGuardedReleased();	
			if ( ACS_Enabled() ) { ACS_Shield_Destroy(); return true;} //ACS
		}
		
		if( (thePlayer.IsWeaponHeld('fists') || thePlayer.GetCurrentStateName() == 'CombatFists') && !thePlayer.IsActionAllowed(EIAB_Fists))
		{
			if ( ACS_Enabled() ) { GuardAttack(); return true;} //ACS
			thePlayer.DisplayActionDisallowedHudMessage(EIAB_Fists);
			return false;
		}
		
		if( IsPressed(action) )
		{
			if( !thePlayer.IsActionAllowed(EIAB_Parry) )
			{
				if ( thePlayer.IsActionBlockedBy(EIAB_Parry,'UsableItem') )
				{
					thePlayer.DisplayActionDisallowedHudMessage(EIAB_Parry);
				}
				return true;
			}
				
			if ( thePlayer.GetCurrentStateName() == 'Exploration' )
				thePlayer.GoToCombatIfNeeded();
				
			if ( thePlayer.bLAxisReleased )
				thePlayer.ResetRawPlayerHeading();
			
			if ( thePlayer.rangedWeapon && thePlayer.rangedWeapon.GetCurrentStateName() != 'State_WeaponWait' )
				thePlayer.OnRangedForceHolster( true, true );
			
			thePlayer.AddCounterTimeStamp(theGame.GetEngineTime());	
			thePlayer.SetGuarded(true);				
			thePlayer.OnPerformGuard();
			if ( ACS_Enabled() ) { GuardAttack(); } //ACS
		}	
	}

	private function IsPlayerAbleToPerformSpecialAttack() : bool
	{
		if( ( thePlayer.GetCurrentStateName() == 'Exploration' ) && !( thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ) ) )
		{
			return false;
		}
		return true;
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	event OnMovementDoubleTapW( action : SInputAction )
	{
		if ( IsPressed( action ) )
		{			
			if ( !thePlayer.IsDodgeTimerRunning() || action.aName != lastACSMovementDoubleTapName )
			{
				thePlayer.StartDodgeTimer();
				lastACSMovementDoubleTapName = action.aName;
			}
			else
			{
				thePlayer.StopDodgeTimer();
				if (!thePlayer.HasTag('dettlaff_enabled'))
				{	
					ACS_BruxaBiteInit();
				}
			}
		}
	}

	event OnBruxaBite( action : SInputAction )
	{
		if ( IsPressed( action ) )
		{				
			ACS_BruxaBiteInit();
		}
	}
	
	event OnMovementDoubleTapA( action : SInputAction )
	{
		if ( IsPressed( action ) )
		{			
			if ( !thePlayer.IsDodgeTimerRunning() || action.aName != lastACSMovementDoubleTapName )
			{
				thePlayer.StartDodgeTimer();
				lastACSMovementDoubleTapName = action.aName;
			}
			else
			{
				thePlayer.StopDodgeTimer();
				if (!thePlayer.HasTag('dettlaff_enabled'))
				{	
					ACS_BruxaDodgeBackLeftInit();
				}
			}
		}
	}
	
	event OnMovementDoubleTapS( action : SInputAction )
	{
		if ( IsPressed( action ) )
		{			
			if ( !thePlayer.IsDodgeTimerRunning() || action.aName != lastACSMovementDoubleTapName )
			{
				thePlayer.StartDodgeTimer();
				lastACSMovementDoubleTapName = action.aName;
			}
			else
			{
				thePlayer.StopDodgeTimer();
				if (!thePlayer.HasTag('dettlaff_enabled'))
				{				
					ACS_BruxaDodgeBackCenterInit();	
				}
			}
		}
	}
	
	event OnMovementDoubleTapD( action : SInputAction )
	{
		if ( IsPressed( action ) )
		{			
			if ( !thePlayer.IsDodgeTimerRunning() || action.aName != lastACSMovementDoubleTapName )
			{
				thePlayer.StartDodgeTimer();
				lastACSMovementDoubleTapName = action.aName;
			}
			else
			{
				thePlayer.StopDodgeTimer();
				if (!thePlayer.HasTag('dettlaff_enabled'))
				{	
					ACS_BruxaDodgeBackRightInit();
				}
			}
		}
	}	

	event OnMoveForward ( action : SInputAction )
	{
		if ( IsPressed( action ) )
		{	
			if (theInput.GetActionValue('Sprint') > 0.5 && theInput.GetActionValue('Jump') == 0)
			{
				BruxaDash();

				return true;
			}		

			ACS_Hijack_YAxis_Up_Forward();
		}
		else if ( IsReleased( action ) )
		{			
			RemoveTimer('ACS_HijackMoveForward');
		}
	}

	event OnCbtDodge( action : SInputAction )
	{
		if ( IsPressed(action) && ACS_Enabled() ) { ACS_BruxaDodgeSlideBackInit(); return true;}
		if ( IsPressed(action) )
			thePlayer.EvadePressed(EBAT_Dodge);
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	function ACS_INIT()
	{
		ACS_Init_Attempt();

		ACS_Load_Sound();

		actor = (CActor)( thePlayer.GetTarget() );	

		thePlayer.SetSlideTarget ( actor );

		targetDistance = VecDistanceSquared2D( thePlayer.GetWorldPosition(), actor.GetWorldPosition() ) ;
			
		//settings.blendIn = 0.2f;
		//settings.blendOut = 1.0f;
		//settings.blendIn = 0.25f;
		//settings.blendOut = 0.75f;

		settings.blendIn = 0.25f;
		settings.blendOut = 0.875f;
			
		dist = (((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
		+ ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent()).GetCapsuleRadius()) * 1.25;
		
		distJump = (((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
		+ ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent()).GetCapsuleRadius());
		
		distVampSpecialDash = (((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
		+ ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent()).GetCapsuleRadius()) * 2.25;

		distClawWhirl = (((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
		+ ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent()).GetCapsuleRadius()) * 1.5;
	
		//thePlayer.ActionCancelAll();

		//thePlayer.GetMovingAgentComponent().ResetMoveRequests();

		//thePlayer.GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		//thePlayer.ResetRawPlayerHeading();

		movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();
		
		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACS_Movement_Adjust' );
		
		if (thePlayer.HasTag('acs_bow_active') || thePlayer.HasTag('acs_crossbow_active'))
		{
			movementAdjustor.AdjustmentDuration( ticket, 0.01 );
		}
		else
		{
			if( targetDistance <= 1 ) 
			{
				movementAdjustor.AdjustmentDuration( ticket, 0.01 );
			}
			else if( targetDistance > 1 && targetDistance <= 1.5*1.5 ) 
			{
				movementAdjustor.AdjustmentDuration( ticket, 0.15 );
			}
			else
			{
				movementAdjustor.AdjustmentDuration( ticket, 0.5 );
			}
		}
		
		movementAdjustor.ShouldStartAt(ticket, thePlayer.GetWorldPosition());
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		theGame.GetBehTreeReactionManager().CreateReactionEvent( thePlayer, 'AttackAction', -1, 10.0f, -1.f, -1, true );
	}
	
	function MovementAdjustWraith()
	{		
		ACS_INIT();
		
		movementAdjustor.AdjustLocationVertically( ticket, true );
		movementAdjustor.ScaleAnimationLocationVertically( ticket, true );
	}
	
	function MovementAdjustBruxaDash()
	{
		ACS_INIT();

		movementAdjustor.AdjustmentDuration( ticket, 0.5 );

		if(!thePlayer.HasTag('ACS_Camo_Active'))
		{
			thePlayer.StopAllEffects();
		}
		
		if (thePlayer.HasTag('ember_particles_active'))
		{
			thePlayer.StopEffect('embers_particles');
			thePlayer.PlayEffect('embers_particles');
		}
	}
	
	function MovementAdjust()
	{
		MovementAdjustBruxaDash();
	
		movementAdjustor.AdjustLocationVertically( ticket, true );
		movementAdjustor.ScaleAnimationLocationVertically( ticket, true );
	}

	function UpdateHeading()
	{
		//thePlayer.UpdateCustomRotationHeading('ACS_Movement_Regular', VecHeading(actor.GetWorldPosition() - thePlayer.GetWorldPosition()));
		//thePlayer.SetCustomRotation('ACS_Movement_Regular', VecHeading(actor.GetWorldPosition() - thePlayer.GetWorldPosition()), 0.f, 0.2f, false);
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	function DeactivateThings()
	{
		if ( thePlayer.IsInCombat() || thePlayer.IsCombatMusicEnabled() )
		{
			if (!thePlayer.HasTag('blood_sucking'))
			{
				//thePlayer.SetImmortalityMode( AIM_None, AIC_Combat ); 

				//thePlayer.SetCanPlayHitAnim(true); 
				
				//thePlayer.EnableCharacterCollisions(true); 
				if( thePlayer.IsAlive() && thePlayer.IsInCombat() ){ thePlayer.SetVisibility( true ); }		 
				//thePlayer.RemoveBuffImmunity_AllNegative('acs_dodge'); 
				//thePlayer.SetIsCurrentlyDodging(false);

				if (thePlayer.HasTag('ACS_HideWeaponOnDodge') 
				//&& !thePlayer.HasTag('blood_sucking')
				)
				{
					if (!thePlayer.HasTag('aard_sword_equipped'))
					{
						ACS_Weapon_Respawn();
					}

					thePlayer.RemoveTag('ACS_HideWeaponOnDodge');

					thePlayer.RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
				}
			}
		}

		thePlayer.RemoveTimer('curio_script_watcher_whirl');

		thePlayer.UnblockAction(EIAB_SpecialAttackLight, 'curio_nowhirl_weapons');

		cancel_npc_animation();

		sword_destroy();

		if ( !thePlayer.HasTag('axii_sword_equipped') || !thePlayer.IsGuarded() )
		{
			ACS_Axii_Shield_Destroy_IMMEDIATE();
		}
		
		if ( !thePlayer.HasTag('quen_sword_equipped') )
		{
			Quen_Monsters_Despawn();
		}

		if ( !thePlayer.HasTag('aard_sword_equipped') )
		{
			AardPull_Deactivate();
		}

		if ( !thePlayer.HasTag('vampire_claws_equipped') || !thePlayer.HasTag('ACS_Camo_Active') )
		{
			Bruxa_Camo_Decoy_Deactivate();
		}

		thePlayer.StopEffect('mind_control');
	}

	function DeactivateThings_BruxaDash()
	{
		camera = (CCustomCamera)theCamera.GetTopmostCameraObject();

		camera.StopAnimation('camera_shake_loop_lvl1_1');

		theGame.GetGameCamera().StopAnimation( 'camera_shake_loop_lvl1_1' );

		camera.StopAnimation('camera_shake_loop_lvl1_5');

		theGame.GetGameCamera().StopAnimation( 'camera_shake_loop_lvl1_5' );

		if (thePlayer.IsInCombat() || thePlayer.IsCombatMusicEnabled() )
		{
			if (!thePlayer.HasTag('blood_sucking'))
			{
				if( thePlayer.IsAlive() && thePlayer.IsInCombat() ){ thePlayer.SetVisibility( true ); }		
			}
		}

		thePlayer.RemoveTimer('curio_script_watcher_whirl');

		thePlayer.UnblockAction(EIAB_SpecialAttackLight, 'curio_nowhirl_weapons');

		cancel_npc_animation();

		sword_destroy();

		if ( !thePlayer.HasTag('axii_sword_equipped') || !thePlayer.IsGuarded() )
		{
			ACS_Axii_Shield_Destroy_IMMEDIATE();
		}
		
		if ( !thePlayer.HasTag('quen_sword_equipped') )
		{
			Quen_Monsters_Despawn();
		}

		if ( !thePlayer.HasTag('aard_sword_equipped') )
		{
			AardPull_Deactivate();
		}

		if ( !thePlayer.HasTag('vampire_claws_equipped') || !thePlayer.HasTag('ACS_Camo_Active') )
		{
			Bruxa_Camo_Decoy_Deactivate();
		}

		thePlayer.StopEffect('mind_control');
	}

	function action_interrupt()
	{
		if ( thePlayer.HasTag('ACS_HideWeaponOnDodge') 
		//&& !thePlayer.HasTag('blood_sucking')
		)
		{
			if (!thePlayer.HasTag('aard_sword_equipped'))
			{
				ACS_Weapon_Respawn();
			}
			
			thePlayer.RemoveTag('ACS_HideWeaponOnDodge');

			thePlayer.RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
		}

		settings_interrupt.blendIn = 0;
		settings_interrupt.blendOut = 0;

		//thePlayer.RaiseEvent( 'AttackInterrupt' );

		if (thePlayer.IsInCombat())
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', settings_interrupt );
		}
	}

	function ACS_Finisher_PreAction()
	{
		actor = (CActor)( thePlayer.GetTarget() );	
		ccomp = actor.GetComponent("Finish");
		ccompEnabled = ccomp.IsEnabled();
	}
	
	function NPC_Animation_Cancel_At_Low_Health()
	{
		if (
		(npc.GetStat( BCS_Vitality ) <= npc.GetStatMax( BCS_Vitality ) * 0.05)
		&& npc.IsHuman() 
		&& !npc.HasTag('ACS_caretaker_shade')
		)
		{
			npc.StopAllEffects();

			npc.StopEffect('pee');
			npc.PlayEffect('pee');
						
			npc.StopEffect('puke');
			npc.PlayEffect('puke');

			cancel_npc_animation();
		}
	}
	
	function ACS_Finisher_Internal()
	{
		ccomp = npc.GetComponent("Finish");

		ccompEnabled = ccomp.IsEnabled();

		if (
		(npc.GetStat( BCS_Vitality ) <= npc.GetStatMax( BCS_Vitality ) * 0.01)
		//|| ccompEnabled)
		&& FinisherCheck() 
		&& npc.IsHuman()
		&& !npc.HasTag('ACS_caretaker_shade')
		)
		{	
			action_interrupt();

			npc.StopAllEffects();
			
			thePlayer.SetPlayerTarget( npc );

			//npc.SignalGameplayEvent( 'ForceFinisher' );

			ccomp.SetEnabled( true );
					
			npc.SignalGameplayEvent( 'Finisher' );

			if (ACS_AutoFinisher_Enabled())
			{
				cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}

			if( RandF() < 0.5 ) 
			{
				player_comment_index_COMBAT_END = RandDifferent(this.previous_player_comment_index_COMBAT_END , 2);

				switch (player_comment_index_COMBAT_END) 
				{				
					case 1:
					thePlayer.PlayBattleCry( 'BattleCryMonstersEnd', 1, true, false);
					break;	
								
					default:
					thePlayer.PlayBattleCry('BattleCryHumansEnd', 1, true, false);
					break;
				}

				this.previous_player_comment_index_COMBAT_END = player_comment_index_COMBAT_END;
			}
		}
	}
	
	function ACS_BARRADUR()
	{
		register_extra_inputs();

		vACS_Shield_Summon = new cACS_Shield_Summon in this;

		if ( !theGame.IsDialogOrCutscenePlaying() )
		{
			if ( !thePlayer.IsAnyWeaponHeld() || thePlayer.IsWeaponHeld('fist') )
			{
				if (thePlayer.HasTag('vampire_claws_equipped'))
				{
					thePlayer.SetBehaviorVariable( 'playerWeapon', (int) PW_Steel );
					thePlayer.SetBehaviorVariable( 'playerWeaponForOverlay', (int) PW_Steel );
				}
				else if (thePlayer.IsWeaponHeld('fist') && !thePlayer.HasTag('vampire_claws_equipped'))
				{
					thePlayer.SetBehaviorVariable( 'isHoldingWeaponR', 0.0, true );

					thePlayer.SetBehaviorVariable( 'playerWeapon', (int) PW_Fists );
					thePlayer.SetBehaviorVariable( 'playerWeaponForOverlay', (int) PW_Fists );
				}
				else
				{
					thePlayer.SetBehaviorVariable( 'isHoldingWeaponR', 0.0, true );

					thePlayer.SetBehaviorVariable( 'playerWeapon', (int) PW_None );
					thePlayer.SetBehaviorVariable( 'playerWeaponForOverlay', (int) PW_None );
				}

				/*
				if ( thePlayer.HasTag('vampire_claws_equipped') )
				{
					if ( thePlayer.GetIsSprinting() && !thePlayer.HasTag('ACS_Vampire_Claws_Despawn_Sprinting') )
					{
						ClawDestroy_NOTAG();

						thePlayer.RemoveTag('ACS_Vampire_Claws_Equip_Not_Sprinting');

						thePlayer.AddTag('ACS_Vampire_Claws_Despawn_Sprinting');
					}
					else if ( !thePlayer.GetIsSprinting() && thePlayer.HasTag('ACS_Vampire_Claws_Despawn_Sprinting') && !thePlayer.HasTag('ACS_Vampire_Claws_Equip_Not_Sprinting'))
					{
						ACS_ClawEquip_OnDodge();

						thePlayer.RemoveTag('ACS_Vampire_Claws_Despawn_Sprinting');

						thePlayer.AddTag('ACS_Vampire_Claws_Equip_Not_Sprinting');
					}
				}
				*/

				//if (thePlayer.HasTag('quen_sword_equipped'))
				//{
					QuenSwordDestroyIMMEDIATE();
				//}
				//else if (thePlayer.HasTag('axii_sword_equipped'))
				//{
					AxiiSwordDestroyIMMEDIATE();
				//}
				//else if (thePlayer.HasTag('aard_sword_equipped'))
				//{
					AardSwordDestroyIMMEDIATE();
				//}
				//else if (thePlayer.HasTag('yrden_sword_equipped'))
				//{
					YrdenSwordDestroyIMMEDIATE();
				//}
				//else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				//{
					QuenSecondarySwordDestroyIMMEDIATE();
				//}
				//else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				//{
					AxiiSecondarySwordDestroyIMMEDIATE();
				//}
				//else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				//{
					AardSecondarySwordDestroyIMMEDIATE();
				//}
				//else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				//{
					YrdenSecondarySwordDestroyIMMEDIATE();
				//}

					IgniBowDestroyIMMEDIATE();

					AxiiBowDestroyIMMEDIATE();

					AardBowDestroyIMMEDIATE();

					YrdenBowDestroyIMMEDIATE();

					QuenBowDestroyIMMEDIATE();

					IgniCrossbowDestroyIMMEDIATE();

					AxiiCrossbowDestroyIMMEDIATE();

					AardCrossbowDestroyIMMEDIATE();

					YrdenCrossbowDestroyIMMEDIATE();

					QuenCrossbowDestroyIMMEDIATE();

				if (thePlayer.HasTag('ACS_Holster_Sword_Effect'))
				{
					thePlayer.RemoveTag('ACS_Holster_Sword_Effect');
				}
			}
			else
			{
				if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
				{
					thePlayer.SetBehaviorVariable( 'playerWeapon', (int) PW_Steel );
					thePlayer.SetBehaviorVariable( 'playerWeaponForOverlay', (int) PW_Steel );
				}
				else if ( thePlayer.IsWeaponHeld( 'silversword' ) )
				{
					thePlayer.SetBehaviorVariable( 'playerWeapon', (int) PW_Silver );
					thePlayer.SetBehaviorVariable( 'playerWeaponForOverlay', (int) PW_Silver );
				}

				if (!thePlayer.HasTag('quen_sword_equipped'))
				{
					QuenSwordDestroyIMMEDIATE();
				}
				else if (!thePlayer.HasTag('axii_sword_equipped'))
				{
					AxiiSwordDestroyIMMEDIATE();
				}
				else if (!thePlayer.HasTag('aard_sword_equipped'))
				{
					AardSwordDestroyIMMEDIATE();
				}
				else if (!thePlayer.HasTag('yrden_sword_equipped'))
				{
					YrdenSwordDestroyIMMEDIATE();
				}
				else if (!thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					QuenSecondarySwordDestroyIMMEDIATE();
				}
				else if (!thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					AxiiSecondarySwordDestroyIMMEDIATE();
				}
				else if (!thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					AardSecondarySwordDestroyIMMEDIATE();
				}
				else if (!thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					YrdenSecondarySwordDestroyIMMEDIATE();
				}
				else if (!thePlayer.HasTag('igni_bow_equipped'))
				{
					IgniBowDestroyIMMEDIATE();
				}
				else if (!thePlayer.HasTag('axii_bow_equipped'))
				{
					AxiiBowDestroyIMMEDIATE();
				}
				else if (!thePlayer.HasTag('aard_bow_equipped'))
				{
					AardBowDestroyIMMEDIATE();
				}
				else if (!thePlayer.HasTag('yrden_bow_equipped'))
				{
					YrdenBowDestroyIMMEDIATE();
				}
				else if (!thePlayer.HasTag('quen_bow_equipped'))
				{
					QuenBowDestroyIMMEDIATE();
				}
				else if (!thePlayer.HasTag('igni_crossbow_equipped'))
				{
					IgniCrossbowDestroyIMMEDIATE();
				}
				else if (!thePlayer.HasTag('axii_crossbow_equipped'))
				{
					AxiiCrossbowDestroyIMMEDIATE();
				}
				else if (!thePlayer.HasTag('aard_crossbow_equipped'))
				{
					AardCrossbowDestroyIMMEDIATE();
				}
				else if (!thePlayer.HasTag('yrden_crossbow_equipped'))
				{
					YrdenCrossbowDestroyIMMEDIATE();
				}
				else if (!thePlayer.HasTag('quen_crossbow_equipped'))
				{
					QuenCrossbowDestroyIMMEDIATE();
				}
				else if (!thePlayer.HasTag('vampire_claws_equipped'))
				{
					//ClawDestroy();
				}

				if (thePlayer.HasTag('ACS_Holster_Sword_Effect'))
				{
					thePlayer.RemoveTag('ACS_Holster_Sword_Effect');
				}
			}
		}

		LangCheck();

		if ( 
		ACS_GetWeaponMode() == 0
		|| ACS_GetWeaponMode() == 1
		|| ACS_GetWeaponMode() == 2
		)
		{
			if (
			thePlayer.HasTag('axii_sword_equipped')	
			|| thePlayer.HasTag('aard_sword_equipped')	
			|| thePlayer.HasTag('yrden_sword_equipped')	
			|| thePlayer.HasTag('quen_sword_equipped')
			|| thePlayer.HasTag('axii_secondary_sword_equipped')
			|| thePlayer.HasTag('aard_secondary_sword_equipped')
			|| thePlayer.HasTag('yrden_secondary_sword_equipped')
			|| thePlayer.HasTag('quen_secondary_sword_equipped')
			)	
			{
				GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
				GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
				
				steelsword = (CDrawableComponent)((thePlayer.GetInventory().GetItemEntityUnsafe(steelID)).GetMeshComponent());
				silversword = (CDrawableComponent)((thePlayer.GetInventory().GetItemEntityUnsafe(silverID)).GetMeshComponent());
				
				if ( thePlayer.GetInventory().IsItemHeld(steelID) )
				{
					steelsword.SetVisible(false); 
				}
				else if( thePlayer.GetInventory().IsItemHeld(silverID) )
				{
					silversword.SetVisible(false); 
				}

				ACSGetEquippedSword().StopAllEffects();
			}
		}

		if (thePlayer.IsUsingHorse()
		|| thePlayer.IsUsingVehicle()
		|| !ACS_Enabled())
		{
			if (thePlayer.HasTag('vampire_claws_equipped'))
			{
				ClawDestroy();

				thePlayer.PlayEffect('claws_effect');
				thePlayer.StopEffect('claws_effect');
			}
		}

		if (thePlayer.IsInCombat())
		{
			if(thePlayer.HasTag('ACS_Shielded_Entity'))
			{
				thePlayer.StopEffect('third_teleport_out');
				thePlayer.PlayEffect('third_teleport_out');
			}

			if(thePlayer.HasTag('ACS_Camo_Active'))
			{
				if (theInput.GetActionValue('GI_AxisLeftX') == 0 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
				{
					thePlayer.ForceSetStat( BCS_Vitality,  thePlayer.GetStat( BCS_Vitality ) - (thePlayer.GetStat( BCS_Vitality ) * 0.00005) );
				}
				else
				{
					thePlayer.ForceSetStat( BCS_Vitality,  thePlayer.GetStat( BCS_Vitality ) - (thePlayer.GetStat( BCS_Vitality ) * 0.0005) );
				}
			}

			if(thePlayer.HasTag('ACS_AardPull_Active'))
			{
				if (thePlayer.GetStat( BCS_Stamina ) > 0.01)
				{
					ACS_Bat_Damage();
				}
				else
				{
					AardPull_Deactivate();
				}	
			}

			if
			(
			thePlayer.HasTag('axii_sword_equipped') 
			&& !thePlayer.IsPerformingFinisher() 
			&& thePlayer.HasTag('ACS_Shield_Destroyed') 
			&& !thePlayer.HasTag('ACS_Shield_Summoned') 
			&& !thePlayer.IsCurrentlyDodging()
			&& !thePlayer.HasTag('blood_sucking') 
			&& 
			(
				//thePlayer.IsInGuardedState()
				thePlayer.IsGuarded()
			)
			)
			{
				if (thePlayer.HasTag('ACS_Shield_Destroyed'))
				{
					thePlayer.RemoveTag('ACS_Shield_Destroyed');
				}

				vACS_Shield_Summon.Axii_Persistent_Shield_Summon();	

				//ACS_ThingsThatShouldBeRemoved();

				thePlayer.AddTag('ACS_Shield_Summoned');
			}
			else if 
			(
				!thePlayer.HasTag('ACS_Shield_Destroyed')
				&& thePlayer.HasTag('ACS_Shield_Summoned')
				&&
				(
					!thePlayer.IsGuarded()
					|| !thePlayer.HasTag('axii_sword_equipped') 
					|| thePlayer.IsPerformingFinisher()
					|| thePlayer.IsCurrentlyDodging()
				)
				
			)
			{
				ACS_Axii_Shield_Destroy_DELAY();
			}
		}
		else
		{
			if (thePlayer.HasTag ('summoned_shades'))
			{
				thePlayer.RemoveTag('summoned_shades');
			}
			
			if (thePlayer.HasTag ('ethereal_shout'))
			{
				thePlayer.RemoveTag('ethereal_shout');
			}
			
			if (thePlayer.HasTag('Swords_Ready'))
			{
				thePlayer.RemoveTag('Swords_Ready');
			}
			
			theGame.GetGameCamera().StopEffect( 'frost' );

			thePlayer.StopEffect('drain_energy');

			Remove_On_Hit_Tags();

			BerserkMarkDestroy();
		}

		if (thePlayer.HasTag('vampire_claws_equipped'))
		{
			theGame.GetBehTreeReactionManager().CreateReactionEvent( thePlayer, 'CastSignAction', -1, 5.0f, -1.f, -1, true );

			ACS_Vampire_Back_Claw_Get().PlayEffectSingle('blood_color');

			ACS_Vampire_Back_Claw_Get().StopEffect('blood_color');

			if (thePlayer.HasBuff(EET_BlackBlood))
			{
				thePlayer.StopEffect('blood_color');
				thePlayer.PlayEffect('blood_color');

				ACS_Vampire_Arms_1_Get().PlayEffectSingle('blood_color');

				ACS_Vampire_Arms_1_Get().StopEffect('blood_color');

				ACS_Vampire_Arms_2_Get().PlayEffectSingle('blood_color');

				ACS_Vampire_Arms_2_Get().StopEffect('blood_color');

				ACS_Vampire_Arms_3_Get().PlayEffectSingle('blood_color');

				ACS_Vampire_Arms_3_Get().StopEffect('blood_color');

				ACS_Vampire_Arms_4_Get().PlayEffectSingle('blood_color');

				ACS_Vampire_Arms_4_Get().StopEffect('blood_color');
				
				ACS_Vampire_Head_Get().PlayEffectSingle('blood_color');

				ACS_Vampire_Head_Get().StopEffect('blood_color');

				if (!thePlayer.HasTag('ACS_blood_armor'))
				{
					ACS_BloodArmorStandalone();
				}
			}
			else
			{
				ACS_Blood_Armor_Destroy_Without_Back_Claw_IMMEDIATE();
			}
		}
		else if (thePlayer.HasTag('aard_sword_equipped'))
		{
			aard_blade_1().PlayEffectSingle('blood_color');

			aard_blade_1().StopEffect('blood_color');

			aard_blade_2().PlayEffectSingle('blood_color');

			aard_blade_2().StopEffect('blood_color');

			aard_blade_3().PlayEffectSingle('blood_color');

			aard_blade_3().StopEffect('blood_color');

			aard_blade_4().PlayEffectSingle('blood_color');

			aard_blade_4().StopEffect('blood_color');

			aard_blade_5().PlayEffectSingle('blood_color');

			aard_blade_5().StopEffect('blood_color');

			aard_blade_6().PlayEffectSingle('blood_color');

			aard_blade_6().StopEffect('blood_color');

			aard_blade_7().PlayEffectSingle('blood_color');

			aard_blade_7().StopEffect('blood_color');

			aard_blade_8().PlayEffectSingle('blood_color');

			aard_blade_8().StopEffect('blood_color');
		}
		/*
		else if (!thePlayer.HasTag('vampire_claws_equipped'))
		{
			//ClawDestroy_NOTAG();
		}
		*/
	}

	function NPC_Fear_Reaction_Geralt()
	{
		if (thePlayer.HasTag('ACS_AardPull_Active'))
		{
			ACS_Bats_Summon();
		}	
	}

	function NPC_Fear_Reaction()
	{
		actors = thePlayer.GetNPCsAndPlayersInRange( 100, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];
				
				curTargetVitality = npc.GetStat( BCS_Vitality );

				maxTargetVitality = npc.GetStatMax( BCS_Vitality );

				curTargetEssence = npc.GetStat( BCS_Essence );

				maxTargetEssence = npc.GetStatMax( BCS_Essence );

				animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	
				
				settingsA.blendIn = 0.9f;
				settingsA.blendOut = 0.9f;
				
				if ( npc == thePlayer  )
					continue;
				
				if(!theGame.IsDialogOrCutscenePlaying()
				&& !thePlayer.IsUsingHorse() 
				&& !thePlayer.IsUsingVehicle()
				&& npc.IsHuman()
				)
				{				
					actor.RemoveBuffImmunity_AllNegative();

					actor.RemoveBuffImmunity_AllCritical();

					npc.RemoveBuffImmunity_AllNegative();

					npc.RemoveBuffImmunity_AllCritical();

					targetDistance = VecDistanceSquared2D( thePlayer.GetWorldPosition(), npc.GetWorldPosition() ) ;

					if( targetDistance <= 2 * 2 ) 
					{
						if (!npc.HasTag('fear_end'))
						{
							animatedComponentA.PlaySlotAnimationAsync ( ' ', 'NPC_ANIM_SLOT', settingsA);

							npc.AddTag('fear_end');
						}	
					}
					else if( targetDistance > 2 * 2 && targetDistance <= 100 * 100 ) 
					{
						npc.RemoveTag('fear_end');

						//((CNewNPC)npc).ForgetActor(thePlayer);
						
						if (curTargetVitality <= maxTargetVitality * 0.25)
						{
							animatedComponentA.PlaySlotAnimationAsync ( 'reaction_surrender_escape', 'NPC_ANIM_SLOT', settingsA);
						}
						else if (curTargetVitality > maxTargetVitality * 0.25 && curTargetVitality <= maxTargetVitality * 0.5)
						{
							fear_index_1 = RandDifferent(this.previous_fear_index_1 , 8);

							switch (fear_index_1) 
							{	
								case 7:
								animatedComponentA.PlaySlotAnimationAsync ( 'man_ex_scared_loop_turn_right_180_rp', 'NPC_ANIM_SLOT', settingsA);
								break;

								case 6:
								animatedComponentA.PlaySlotAnimationAsync ( 'man_ex_scared_loop_turn_right_180_lp', 'NPC_ANIM_SLOT', settingsA);
								break;

								case 5:
								animatedComponentA.PlaySlotAnimationAsync ( 'man_ex_scared_loop_turn_left_90_rp', 'NPC_ANIM_SLOT', settingsA);
								break;

								case 4:
								animatedComponentA.PlaySlotAnimationAsync ( 'man_ex_scared_loop_turn_left_90_lp', 'NPC_ANIM_SLOT', settingsA);
								break;

								case 3:
								animatedComponentA.PlaySlotAnimationAsync ( 'man_ex_scared_loop_turn_left_45_rp', 'NPC_ANIM_SLOT', settingsA);
								break;

								case 2:
								animatedComponentA.PlaySlotAnimationAsync ( 'man_ex_scared_loop_turn_left_45_lp', 'NPC_ANIM_SLOT', settingsA);
								break;

								case 1:
								animatedComponentA.PlaySlotAnimationAsync ( 'man_ex_scared_loop_2', 'NPC_ANIM_SLOT', settingsA);
								break;

								default:
								animatedComponentA.PlaySlotAnimationAsync ( 'man_ex_scared_loop_1', 'NPC_ANIM_SLOT', settingsA);
								break;		
							}
							
							this.previous_fear_index_1 = fear_index_1;
						}
						else
						{
							fear_index_1 = RandDifferent(this.previous_fear_index_1 , 5);

							switch (fear_index_1) 
							{	
								case 4:
								animatedComponentA.PlaySlotAnimationAsync ( 'man_work_standing_nervous_scarred_stop', 'NPC_ANIM_SLOT', settingsA);
								break;

								case 3:
								animatedComponentA.PlaySlotAnimationAsync ( 'man_work_standing_nervous_scarred_start', 'NPC_ANIM_SLOT', settingsA);
								break;

								case 2:
								animatedComponentA.PlaySlotAnimationAsync ( 'man_work_standing_nervous_scarred_loop_03', 'NPC_ANIM_SLOT', settingsA);
								break;

								case 1:
								animatedComponentA.PlaySlotAnimationAsync ( 'man_work_standing_nervous_scarred_loop_02', 'NPC_ANIM_SLOT', settingsA);
								break;

								default:
								animatedComponentA.PlaySlotAnimationAsync ( 'man_work_standing_nervous_scarred_loop_01', 'NPC_ANIM_SLOT', settingsA);
								break;		
							}
							
							this.previous_fear_index_1 = fear_index_1;
						}
					}
				}	
			}
		}
	}

	function ACS_Shout_Actual()
	{
		thePlayer.PlayEffect('shout'); 
		thePlayer.StopEffect('shout');
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	function go_plough_yourself()
	{
		MovementAdjust();
		
		movementAdjustor.RotateTowards( ticket, actor );    
		
		//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'high_standing_sad_gesture_go_plough_yourself', 'PLAYER_SLOT', settings);

		if ( !thePlayer.IsAnyWeaponHeld() )
		{
			if( RandF() < 0.5 ) 
			{
				if( RandF() < 0.5 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'high_standing_sad_gesture_go_plough_yourself', 'PLAYER_SLOT', settings);
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'locomotion_idle_proud_gesture_bend_forward', 'PLAYER_SLOT', settings);
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'locomotion_idle_proud_gesture_annouce', 'PLAYER_SLOT', settings);
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'locomotion_idle_proud_gesture_pound_chest', 'PLAYER_SLOT', settings);
				}
			}
		}
		else
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'locomotion_idle_proud_gesture_annouce', 'PLAYER_SLOT', settings);
		}
	}

	function cancel_npc_animation()
	{
		//actors = GetActorsInRange(thePlayer, 10, 10 );

		//actors = GetActorsInRange(thePlayer, 100, 100, 'ACS_taunted' );

		theGame.GetActorsByTag( 'ACS_taunted', actors );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc_ANIMATION_CANCEL = (CNewNPC)actors[i];

				npcactor_ANIMATION_CANCEL = (CActor)actors[i];

				animatedComponent_NPC_ANIMATION_CANCEL = (CAnimatedComponent)npcactor_ANIMATION_CANCEL.GetComponentByClassName( 'CAnimatedComponent' );	
				
				if ( npc_ANIMATION_CANCEL == thePlayer || npc_ANIMATION_CANCEL.HasTag('smokeman') )
					continue;
		
				if(
				//npc_ANIMATION_CANCEL.IsHuman()
				//&& ACS_AttitudeCheck( npcactor_ANIMATION_CANCEL )
				//&& thePlayer.IsInCombat()
				ACS_CombatTaunt_Enabled()
				//&& npc_ANIMATION_CANCEL.HasTag('ACS_taunted')
				)
				{	
					animatedComponent_NPC_ANIMATION_CANCEL.PlaySlotAnimationAsync ( ' ', 'NPC_ANIM_SLOT', settings_interrupt);
				}
			}
		}

		npc_notice_player();
	}

	function npc_notice_player()
	{
		actors = thePlayer.GetNPCsAndPlayersInRange( 20, 20, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{

			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = (CActor)actors[i];
				
				((CNewNPC)actor).NoticeActor(thePlayer);

				actor.ForceAIUpdate();
			}
		}
	}

	function taunted_npc_destroy()
	{
		//actors = GetActorsInRange(thePlayer, 10, 10 );

		//actors = GetActorsInRange(thePlayer, 100, 100, 'ACS_taunted' );

		theGame.GetActorsByTag( 'ACS_taunted', actors );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc_ANIMATION_CANCEL = (CNewNPC)actors[i];

				npcactor_ANIMATION_CANCEL = (CActor)actors[i];

				if ( npc_ANIMATION_CANCEL == thePlayer || npc_ANIMATION_CANCEL.HasTag('smokeman') )
					continue;
				
				if(
				//npc_ANIMATION_CANCEL.IsHuman()
				//&& ACS_AttitudeCheck( npcactor_ANIMATION_CANCEL )
				//&& thePlayer.IsInCombat()
				ACS_CombatTaunt_Enabled()
				//&& npc_ANIMATION_CANCEL.HasTag('ACS_taunted')
				)
				{	
					npc_ANIMATION_CANCEL.Destroy();
				}
			}
		}
	}

	function ACS_Hit_Reaction()
	{
		if ( CiriCheck()
		&& FinisherCheck() 
		&& HitAnimCheck()
		&& WraithModeCheck()
		&& BruxaBiteCheck())
		{
			thePlayer.StopAllEffects();

			if (
			thePlayer.HasTag('quen_sword_equipped')
			)
			{
				Olgierd_Hit_Reaction();
			}
			else if (
			(thePlayer.HasTag('aard_secondary_sword_equipped'))
			)
			{
				Axe_Hit_Reaction();
			}
			else if (
			(thePlayer.HasTag('quen_secondary_sword_equipped'))
			)
			{
				Spear_Hit_Reaction();
			}
			else if (
			(thePlayer.HasTag('axii_sword_equipped'))
			)
			{
				//ACS_Blink_Hit_Reaction();

				Gregoire_Hit_Reaction();
			}
			else if (
			(thePlayer.HasTag('axii_secondary_sword_equipped'))
			)
			{
				if (ACS_GetItem_Katana_Steel() || ACS_GetItem_Katana_Silver())
				{
					Axe_Hit_Reaction();
				}
				else
				{
					Gregoire_Hit_Reaction();
				}
			}
			else if (
			(thePlayer.HasTag('yrden_sword_equipped')
			|| thePlayer.HasTag('yrden_secondary_sword_equipped'))
			)
			{
				Imlerith_Hit_Reaction();
			}
			else if (
			(thePlayer.HasTag('vampire_claws_equipped')
			|| thePlayer.HasTag('aard_sword_equipped'))
			)
			{
				Dettlaff_Hit_Reaction();
			}
		}
	}

	function Olgierd_Hit_Reaction()
	{
		MovementAdjust();

		thePlayer.ClearAnimationSpeedMultipliers();	

		if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 2 / theGame.GetTimeScale() ); }
															
		AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}

			if (RandF() < 0.5)
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'full_hit_reaction_with_fast_shadow_attack_001_ACS', 'PLAYER_SLOT', settings);
			}
			else
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'full_hit_pirouette_reaction_with_fast_shadow_attack_001_ACS', 'PLAYER_SLOT', settings);
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			if (RandF() < 0.5)
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'full_hit_reaction_with_fast_shadow_attack_001_ACS', 'PLAYER_SLOT', settings);
			}
			else
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'full_hit_pirouette_reaction_with_fast_shadow_attack_001_ACS', 'PLAYER_SLOT', settings);
			}
		}
	}

	function Gregoire_Hit_Reaction()
	{
		MovementAdjust();

		thePlayer.ClearAnimationSpeedMultipliers();	

		if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 2 / theGame.GetTimeScale() ); }
															
		AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}

			if (RandF() < 0.5)
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_kick_ACS', 'PLAYER_SLOT', settings);
			}
			else
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			if (RandF() < 0.5)
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_kick_ACS', 'PLAYER_SLOT', settings);
			}
			else
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
			}
		}
	}

	function Spear_Hit_Reaction()
	{
		geraltRandomGiantHeavyAttackAlt();

		thePlayer.ClearAnimationSpeedMultipliers();	

		if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 3 / theGame.GetTimeScale() ); }
																
		AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
	}

	function Dettlaff_Hit_Reaction()
	{
		geraltClawWhirlReactionAttack();

		thePlayer.ClearAnimationSpeedMultipliers();	

		if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 2 / theGame.GetTimeScale() ); }
																
		AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
	}

	function Imlerith_Hit_Reaction()
	{
		geraltRandomGiantHeavyAttack();

		thePlayer.ClearAnimationSpeedMultipliers();	

		if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 3 / theGame.GetTimeScale() ); }
																
		AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
	}

	function Axe_Hit_Reaction()
	{
		geraltRandomAxeSpecialAttackAlt();

		thePlayer.ClearAnimationSpeedMultipliers();	

		if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 3 / theGame.GetTimeScale() ); }
															
		AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	function GetCurrentMeleeWeapon() : EPlayerWeapon
	{
		if (thePlayer.IsWeaponHeld('silversword'))
		{
			return PW_Silver;
		}
		else if (thePlayer.IsWeaponHeld('steelsword'))
		{
			return PW_Steel;
		}
		else if (thePlayer.IsWeaponHeld('fist'))
		{
			return PW_Fists;
		}
		else
		{
			return PW_None;
		}
	}

	function UpdateBehGraph( optional init : bool )
	{	
		weapontype = GetCurrentMeleeWeapon();
		
		if ( weapontype == PW_None )
		{
			weapontype = PW_Fists;
		}
		
		thePlayer.SetBehaviorVariable( 'WeaponType', 0);
		
		if ( thePlayer.HasTag('vampire_claws_equipped') && thePlayer.IsInCombat() )
		{
			thePlayer.SetBehaviorVariable( 'playerWeapon', (int) PW_Steel );
			thePlayer.SetBehaviorVariable( 'playerWeaponForOverlay', (int) PW_Steel );
		}
		else
		{
			thePlayer.SetBehaviorVariable( 'playerWeapon', (int) weapontype ); ACS_Theft_Prevention_9 ();
			thePlayer.SetBehaviorVariable( 'playerWeaponForOverlay', (int) weapontype );
		}
		
		if ( thePlayer.IsUsingHorse() )
		{
			thePlayer.SetBehaviorVariable( 'isOnHorse', 1.0 );
		}
		else
		{
			thePlayer.SetBehaviorVariable( 'isOnHorse', 0.0 );
		}
		
		switch ( weapontype )
		{
			case PW_Steel:
				thePlayer.SetBehaviorVariable( 'SelectedWeapon', 0, true);
				thePlayer.SetBehaviorVariable( 'isHoldingWeaponR', 1.0, true );
				if ( init )
					res = thePlayer.RaiseEvent('DrawWeaponInstant');
				break;
			case PW_Silver:
				thePlayer.SetBehaviorVariable( 'SelectedWeapon', 1, true);
				thePlayer.SetBehaviorVariable( 'isHoldingWeaponR', 1.0, true );
				if ( init )
					res = thePlayer.RaiseEvent('DrawWeaponInstant');
				break;
			default:
				thePlayer.SetBehaviorVariable( 'isHoldingWeaponR', 0.0, true );
				break;
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	function sword_destroy()
	{
		if ( !theGame.IsDialogOrCutscenePlaying() )
		{
			if ( !thePlayer.IsAnyWeaponHeld() || thePlayer.IsWeaponHeld('fist') )
			{
				//if (thePlayer.HasTag('quen_sword_equipped'))
				//{
					QuenSwordDestroyIMMEDIATE();
				//}
				//else if (thePlayer.HasTag('axii_sword_equipped'))
				//{
					AxiiSwordDestroyIMMEDIATE();
				//}
				//else if (thePlayer.HasTag('aard_sword_equipped'))
				//{
					AardSwordDestroyIMMEDIATE();
				//}
				//else if (thePlayer.HasTag('yrden_sword_equipped'))
				//{
					YrdenSwordDestroyIMMEDIATE();
				//}
				//else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				//{
					QuenSecondarySwordDestroyIMMEDIATE();
				//}
				//else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				//{
					AxiiSecondarySwordDestroyIMMEDIATE();
				//}
				//else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				//{
					AardSecondarySwordDestroyIMMEDIATE();
				//}
				//else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				//{
					YrdenSecondarySwordDestroyIMMEDIATE();
				//}

				IgniBowDestroyIMMEDIATE();

				AxiiBowDestroyIMMEDIATE();

				AardBowDestroyIMMEDIATE();

				YrdenBowDestroyIMMEDIATE();

				QuenBowDestroyIMMEDIATE();

				IgniCrossbowDestroyIMMEDIATE();

				AxiiCrossbowDestroyIMMEDIATE();

				AardCrossbowDestroyIMMEDIATE();

				YrdenCrossbowDestroyIMMEDIATE();

				QuenCrossbowDestroyIMMEDIATE();

				if (thePlayer.HasTag('ACS_Holster_Sword_Effect'))
				{
					thePlayer.RemoveTag('ACS_Holster_Sword_Effect');
				}
			}
		}
	}

	function sword_summon_effect()
	{
		if ( ACS_GetWeaponMode() == 0 
		|| ACS_GetWeaponMode() == 1
		|| ACS_GetWeaponMode() == 2 )
		{
			if (thePlayer.HasTag('quen_sword_equipped'))
			{
				quen_sword_summon();
			}
			else if (thePlayer.HasTag('axii_sword_equipped'))
			{
				axii_sword_summon();
			}
			else if (thePlayer.HasTag('aard_sword_equipped'))
			{
				aard_sword_summon();
			}
			else if (thePlayer.HasTag('yrden_sword_equipped'))
			{
				yrden_sword_summon();
			}
			else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
			{
				quen_secondary_sword_summon();
			}
			else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
			{
				axii_secondary_sword_summon();
			}
			else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
			{
				aard_secondary_sword_summon();
			}
			else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
			{
				yrden_secondary_sword_summon();
			}
			else if (
			thePlayer.HasTag('igni_secondary_sword_equipped')
			|| thePlayer.HasTag('igni_sword_equipped'))
			{
				if (!thePlayer.HasTag('igni_sword_effect_played'))
				{
					igni_sword_summon();
				}
			}
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			if (thePlayer.HasTag('aard_sword_equipped'))
			{
				aard_sword_summon();
			}
		}
	}

	function Weapon_Summon_Effect_Delay()
	{
		settings_interrupt.blendIn = 0.25;
		settings_interrupt.blendOut = 1;

		if (!thePlayer.HasTag('blood_sucking') )
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( ' ', 'PLAYER_SLOT', settings);
		}

		if(thePlayer.IsInCombat())
		{
			RemoveTimer('ACS_Weapon_Summon_Delay');
			AddTimer('ACS_Weapon_Summon_Delay', 0.25, false);
		}
		else
		{
			RemoveTimer('ACS_Weapon_Summon_Delay');
			AddTimer('ACS_Weapon_Summon_Delay', 0.75, false);
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	function blood_trail_effects()
	{
		blood_fx.Clear();
		blood_fx.PushBack('default_blood_trail');
		blood_fx.PushBack('cutscene_blood_trail');
		blood_fx.PushBack('cutscene_blood_trail_02');
		blood_fx.PushBack('blood_trail_horseriding');
		blood_fx.PushBack('blood_trail_finisher');
		blood_fx.PushBack('fast_trail_blood_fx');
		blood_fx.PushBack('weapon_blood');
		blood_fx.PushBack('weapon_blood_stage1');
		blood_fx.PushBack('weapon_blood_stage2'); 
	}
	
	function weapon_blood_fx()
	{
		blood_trail_effects();
		
		if (thePlayer.HasTag('axii_sword_equipped'))
		{
			if (ACS_GetWeaponMode() == 0
			|| ACS_GetWeaponMode() == 1
			|| ACS_GetWeaponMode() == 2
			)
			{
				ACSGetEquippedSword().StopAllEffects();

				axii_sword_1().StopEffect(blood_fx[blood_fx.Size()]);
				axii_sword_2().StopEffect(blood_fx[blood_fx.Size()]);
				axii_sword_3().StopEffect(blood_fx[blood_fx.Size()]);
				axii_sword_4().StopEffect(blood_fx[blood_fx.Size()]);
				axii_sword_5().StopEffect(blood_fx[blood_fx.Size()]);

				axii_sword_1().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				axii_sword_2().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				axii_sword_3().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				axii_sword_4().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				axii_sword_5().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
			}
			else if (ACS_GetWeaponMode() == 3)
			{
				ACSGetEquippedSword().StopEffect(blood_fx[blood_fx.Size()]);
				ACSGetEquippedSword().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
			}
		}
		else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
		{
			if (ACS_GetWeaponMode() == 0
			|| ACS_GetWeaponMode() == 1
			|| ACS_GetWeaponMode() == 2
			)
			{
				ACSGetEquippedSword().StopAllEffects();

				axii_secondary_sword_1().StopEffect(blood_fx[blood_fx.Size()]);
				axii_secondary_sword_2().StopEffect(blood_fx[blood_fx.Size()]);
				axii_secondary_sword_3().StopEffect(blood_fx[blood_fx.Size()]);

				axii_secondary_sword_1().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				axii_secondary_sword_2().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				axii_secondary_sword_3().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
			}
			else if (ACS_GetWeaponMode() == 3)
			{
				ACSGetEquippedSword().StopEffect(blood_fx[blood_fx.Size()]);
				ACSGetEquippedSword().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
			}
		}
		else if (thePlayer.HasTag('quen_sword_equipped'))
		{
			if (ACS_GetWeaponMode() == 0
			|| ACS_GetWeaponMode() == 1
			|| ACS_GetWeaponMode() == 2
			)
			{
				ACSGetEquippedSword().StopAllEffects();

				quen_sword_1().StopEffect(blood_fx[blood_fx.Size()]);
				quen_sword_2().StopEffect(blood_fx[blood_fx.Size()]);
				quen_sword_3().StopEffect(blood_fx[blood_fx.Size()]);

				quen_sword_1().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				quen_sword_2().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				quen_sword_3().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
			}
			else if (ACS_GetWeaponMode() == 3)
			{
				ACSGetEquippedSword().StopEffect(blood_fx[blood_fx.Size()]);
				ACSGetEquippedSword().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
			}
		}
		else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
		{
			if (ACS_GetWeaponMode() == 0
			|| ACS_GetWeaponMode() == 1
			|| ACS_GetWeaponMode() == 2
			)
			{
				ACSGetEquippedSword().StopAllEffects();

				quen_secondary_sword_1().StopEffect(blood_fx[blood_fx.Size()]);
				quen_secondary_sword_2().StopEffect(blood_fx[blood_fx.Size()]);
				quen_secondary_sword_3().StopEffect(blood_fx[blood_fx.Size()]);
				quen_secondary_sword_4().StopEffect(blood_fx[blood_fx.Size()]);
				quen_secondary_sword_5().StopEffect(blood_fx[blood_fx.Size()]);
				quen_secondary_sword_6().StopEffect(blood_fx[blood_fx.Size()]);

				quen_secondary_sword_1().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				quen_secondary_sword_2().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				quen_secondary_sword_3().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				quen_secondary_sword_4().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				quen_secondary_sword_5().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				quen_secondary_sword_6().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
			}
			else if (ACS_GetWeaponMode() == 3)
			{
				ACSGetEquippedSword().StopEffect(blood_fx[blood_fx.Size()]);
				ACSGetEquippedSword().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
			}
		}
		else if (thePlayer.HasTag('aard_sword_equipped'))
		{
			ACSGetEquippedSword().StopAllEffects();

			aard_blade_1().StopEffect(blood_fx[blood_fx.Size()]);
			aard_blade_2().StopEffect(blood_fx[blood_fx.Size()]);
			aard_blade_3().StopEffect(blood_fx[blood_fx.Size()]);
			aard_blade_4().StopEffect(blood_fx[blood_fx.Size()]);
			aard_blade_5().StopEffect(blood_fx[blood_fx.Size()]);
			aard_blade_6().StopEffect(blood_fx[blood_fx.Size()]);
			aard_blade_7().StopEffect(blood_fx[blood_fx.Size()]);
			aard_blade_8().StopEffect(blood_fx[blood_fx.Size()]);

			aard_blade_1().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
			aard_blade_2().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
			aard_blade_3().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
			aard_blade_4().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
			aard_blade_5().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
			aard_blade_6().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
			aard_blade_7().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
			aard_blade_8().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
		}
		else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
		{
			if (ACS_GetWeaponMode() == 0
			|| ACS_GetWeaponMode() == 1
			|| ACS_GetWeaponMode() == 2
			)
			{
				ACSGetEquippedSword().StopAllEffects();

				aard_secondary_sword_1().StopEffect(blood_fx[blood_fx.Size()]);
				aard_secondary_sword_2().StopEffect(blood_fx[blood_fx.Size()]);
				aard_secondary_sword_3().StopEffect(blood_fx[blood_fx.Size()]);
				aard_secondary_sword_4().StopEffect(blood_fx[blood_fx.Size()]);
				aard_secondary_sword_5().StopEffect(blood_fx[blood_fx.Size()]);
				aard_secondary_sword_6().StopEffect(blood_fx[blood_fx.Size()]);
				aard_secondary_sword_7().StopEffect(blood_fx[blood_fx.Size()]);
				aard_secondary_sword_8().StopEffect(blood_fx[blood_fx.Size()]);

				aard_secondary_sword_1().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				aard_secondary_sword_2().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				aard_secondary_sword_3().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				aard_secondary_sword_4().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				aard_secondary_sword_5().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				aard_secondary_sword_6().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				aard_secondary_sword_7().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				aard_secondary_sword_8().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
			}
			else if (ACS_GetWeaponMode() == 3)
			{
				ACSGetEquippedSword().StopEffect(blood_fx[blood_fx.Size()]);
				ACSGetEquippedSword().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
			}
		}
		else if (thePlayer.HasTag('yrden_sword_equipped'))
		{
			if (ACS_GetWeaponMode() == 0
			|| ACS_GetWeaponMode() == 1
			|| ACS_GetWeaponMode() == 2
			)
			{
				ACSGetEquippedSword().StopAllEffects();

				yrden_sword_1().StopEffect(blood_fx[blood_fx.Size()]);
				yrden_sword_2().StopEffect(blood_fx[blood_fx.Size()]);
				yrden_sword_3().StopEffect(blood_fx[blood_fx.Size()]);
				yrden_sword_4().StopEffect(blood_fx[blood_fx.Size()]);
				yrden_sword_5().StopEffect(blood_fx[blood_fx.Size()]);
				yrden_sword_6().StopEffect(blood_fx[blood_fx.Size()]);
				yrden_sword_7().StopEffect(blood_fx[blood_fx.Size()]);
				yrden_sword_8().StopEffect(blood_fx[blood_fx.Size()]);

				yrden_sword_1().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				yrden_sword_2().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				yrden_sword_3().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				yrden_sword_4().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				yrden_sword_5().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				yrden_sword_6().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				yrden_sword_7().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				yrden_sword_8().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
			}
			else if (ACS_GetWeaponMode() == 3)
			{
				ACSGetEquippedSword().StopEffect(blood_fx[blood_fx.Size()]);
				ACSGetEquippedSword().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
			}
		}
		else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
		{
			if (ACS_GetWeaponMode() == 0
			|| ACS_GetWeaponMode() == 1
			|| ACS_GetWeaponMode() == 2
			)
			{
				ACSGetEquippedSword().StopAllEffects();

				yrden_secondary_sword_1().StopEffect(blood_fx[blood_fx.Size()]);
				yrden_secondary_sword_2().StopEffect(blood_fx[blood_fx.Size()]);
				yrden_secondary_sword_3().StopEffect(blood_fx[blood_fx.Size()]);
				yrden_secondary_sword_4().StopEffect(blood_fx[blood_fx.Size()]);
				yrden_secondary_sword_5().StopEffect(blood_fx[blood_fx.Size()]);
				yrden_secondary_sword_6().StopEffect(blood_fx[blood_fx.Size()]);

				yrden_secondary_sword_1().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				yrden_secondary_sword_2().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				yrden_secondary_sword_3().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				yrden_secondary_sword_4().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				yrden_secondary_sword_5().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
				yrden_secondary_sword_6().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
			}
			else if (ACS_GetWeaponMode() == 3)
			{
				ACSGetEquippedSword().StopEffect(blood_fx[blood_fx.Size()]);
				ACSGetEquippedSword().PlayEffect(blood_fx[RandRange(blood_fx.Size())]);
			}
		}
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	function VampVoiceEffects_Effort()
	{
		if (thePlayer.HasBuff(EET_BlackBlood))
		{
			vamp_sound_names.Clear();
			vamp_sound_names.PushBack("monster_dettlaff_monster_voice_effort_quadruped");
			vamp_sound_names.PushBack("monster_dettlaff_monster_voice_taunt_claws");
			vamp_sound_names.PushBack("monster_dettlaff_monster_voice_effort_big");
			vamp_sound_names.PushBack("monster_dettlaff_monster_voice_effort_big_short");
			vamp_sound_names.PushBack("monster_dettlaff_monster_voice_taunt");
			vamp_sound_names.PushBack("monster_dettlaff_monster_voice_roar");
		}
		else
		{
			vamp_sound_names.Clear();
			vamp_sound_names.PushBack("monster_dettlaff_vampire_voice_effort");
			//vamp_sound_names.PushBack("monster_dettlaff_vampire_voice_snarl");
			vamp_sound_names.PushBack("monster_dettlaff_vampire_voice_hiss");
		}
		

		thePlayer.SoundEvent(vamp_sound_names[RandRange(vamp_sound_names.Size())]);
	}

	function VampVoiceEffects_Effort_Big()
	{
		if (thePlayer.HasBuff(EET_BlackBlood))
		{
			vamp_sound_names.Clear();
			vamp_sound_names.PushBack("monster_dettlaff_monster_voice_effort_quadruped");
			vamp_sound_names.PushBack("monster_dettlaff_monster_voice_taunt_claws");
			vamp_sound_names.PushBack("monster_dettlaff_monster_voice_effort_big");
			vamp_sound_names.PushBack("monster_dettlaff_monster_voice_effort_big_short");
			vamp_sound_names.PushBack("monster_dettlaff_monster_voice_taunt");
			vamp_sound_names.PushBack("monster_dettlaff_monster_voice_roar");
		}
		else
		{
			vamp_sound_names.Clear();
			vamp_sound_names.PushBack("monster_dettlaff_vampire_voice_effort_big");
			//vamp_sound_names.PushBack("monster_dettlaff_vampire_voice_snarl");
			vamp_sound_names.PushBack("monster_dettlaff_vampire_voice_hiss");
		}

		thePlayer.SoundEvent(vamp_sound_names[RandRange(vamp_sound_names.Size())]);
	}

	function VampVoiceEffects_Monster()
	{
		vamp_sound_names.Clear();
		vamp_sound_names.PushBack("monster_dettlaff_monster_voice_effort_quadruped");
		vamp_sound_names.PushBack("monster_dettlaff_monster_voice_taunt_claws");
		vamp_sound_names.PushBack("monster_dettlaff_monster_voice_effort_big");
		vamp_sound_names.PushBack("monster_dettlaff_monster_voice_effort_big_short");
		vamp_sound_names.PushBack("monster_dettlaff_monster_voice_taunt");
		vamp_sound_names.PushBack("monster_dettlaff_monster_voice_roar");

		thePlayer.SoundEvent(vamp_sound_names[RandRange(vamp_sound_names.Size())]);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	function Remove_On_Hit_Tags()
	{
		//actors = GetActorsInRange(thePlayer, 100, 100);

		actors = thePlayer.GetNPCsAndPlayersInRange( 100, 100);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actor = (CActor)actors[i];

				if (actor.HasTag('aard_light_attack_primer'))
				{
					actor.RemoveTag('aard_light_attack_primer');
				}
				else if (actor.HasTag('aard_heavy_attack_primer'))
				{
					actor.RemoveTag('aard_heavy_attack_primer');
				}
				else if (actor.HasTag('axii_light_attack_primer'))
				{
					actor.RemoveTag('axii_light_attack_primer');
				}
				else if (actor.HasTag('axii_heavy_attack_primer'))
				{
					actor.RemoveTag('axii_heavy_attack_primer');
				}
				else if (actor.HasTag('yrden_light_attack_primer'))
				{
					actor.RemoveTag('yrden_light_attack_primer');
				}
				else if (actor.HasTag('yrden_heavy_attack_primer'))
				{
					actor.RemoveTag('yrden_heavy_attack_primer');
				}
				else if (actor.HasTag('quen_light_attack_primer'))
				{
					actor.RemoveTag('quen_light_attack_primer');
				}
				else if (actor.HasTag('quen_heavy_attack_primer'))
				{
					actor.RemoveTag('quen_heavy_attack_primer');
				}
				else if (actor.HasTag('igni_light_attack_primer'))
				{
					actor.RemoveTag('igni_light_attack_primer');
				}
				else if (actor.HasTag('igni_heavy_attack_primer'))
				{
					actor.RemoveTag('igni_heavy_attack_primer');
				}	
			}
		}

		PrimerMarkDestroy();
	}

	function PrimerMarkDestroy()
	{
		marks.Clear();
			
		theGame.GetEntitiesByTag( 'PrimerMark', marks );
	
		for( i=0; i<marks.Size(); i+=1 )
		{	
			mark = (CEntity)marks[i];	
			mark.BreakAttachment();
			mark.Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -100) );
			mark.Destroy();
		}
	}

	function BerserkMarkDestroy()
	{
		marks_2.Clear();
			
		theGame.GetEntitiesByTag( 'BerserkMark', marks_2 );
	
		for( i=0; i<marks_2.Size(); i+=1 )
		{	
			mark = (CEntity)marks_2[i];	
			mark.BreakAttachment();
			mark.Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -100) );
			mark.Destroy();
		}
	}
	
	function ACS_On_Hit_Effects (action : W3DamageAction)
	{	
		NPC_Animation_Cancel_At_Low_Health();

		npc = (CActor)action.victim;

		playerAttacker = (CPlayer)action.attacker;

		npcPos = npc.GetWorldPosition();

		npcRot = npc.GetWorldRotation();
		
		curTargetVitality = npc.GetStat( BCS_Vitality );

		maxTargetVitality = npc.GetStatMax( BCS_Vitality );
		
		curTargetEssence = npc.GetStat( BCS_Essence );

		maxTargetEssence = npc.GetStatMax( BCS_Essence );

		maxAdrenaline = thePlayer.GetStatMax(BCS_Focus);
		
		curAdrenaline = thePlayer.GetStat(BCS_Focus);
		
		damage_action = (W3Action_Attack)action;

		sword_dmg = action.GetDamageDealt();
		
		targetRotationNPC = npc.GetWorldRotation();
		targetRotationNPC.Yaw = RandRangeF(360,1);
		targetRotationNPC.Pitch = RandRangeF(45,-45);
		
		playerVitality = thePlayer.GetStatMax( BCS_Vitality );
		
		heal = playerVitality * 0.025;

		if ( thePlayer.HasTag('ACS_Shadow_Dash_Empowered') && !action.WasDodged() && action.IsActionMelee() )
		{
			/*
			if (!npc.HasBuff( EET_HeavyKnockdown ) )
			{
				npc.AddEffectDefault( EET_HeavyKnockdown, npc, 'ACS_Shadow_Dash_Effect' );

				thePlayer.RemoveTag('ACS_Shadow_Dash_Empowered');
			}
			*/
			actors = thePlayer.GetNPCsAndPlayersInCone(2.5, VecHeading(thePlayer.GetHeadingVector()), 60, 20, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

			if( actors.Size() > 0 )
			{
				for( i = 0; i < actors.Size(); i += 1 )
				{
					actortarget = (CActor)actors[i];

					actortarget.SoundEvent("cmb_play_hit_heavy");

					//damageMax = maxTargetVitality * 0.30; 

					dmg = new W3DamageAction in theGame.damageMgr;
					
					dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
					
					dmg.SetProcessBuffsIfNoDamage(true);
					
					dmg.SetHitReactionType( EHRT_Heavy, true);
					
					//dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, damageMax );

					if( !npc.IsImmuneToBuff( EET_HeavyKnockdown ) ) 
					{ 
						if ( !npc.HasBuff( EET_HeavyKnockdown ) )
						{
							if (thePlayer.HasTag('ACS_Shadowstep_Long_Buff'))
							{
								dmg.AddEffectInfo( EET_HeavyKnockdown, 2);
							}
							else
							{
								dmg.AddEffectInfo( EET_HeavyKnockdown, 0.5 );
							}
						}
						else
						{
							if( !npc.IsImmuneToBuff( EET_Bleeding ) ) 
							{ 
								dmg.AddEffectInfo( EET_Bleeding, 3 );
							}
						}	
					}
						
					theGame.damageMgr.ProcessAction( dmg );
						
					delete dmg;	
				}
			}

			thePlayer.RemoveTag('ACS_Shadowstep_Long_Buff');

			thePlayer.RemoveTag('ACS_Shadow_Dash_Empowered');
		}

		if (playerAttacker && npc && ( thePlayer.HasTag('axii_sword_equipped') || thePlayer.HasTag('axii_secondary_sword_equipped') || thePlayer.HasTag('quen_sword_equipped') ) )
		{
			ACS_Finisher_Internal();
		}
		
		if (playerAttacker && npc && thePlayer.HasTag('aard_sword_equipped') && action.DealtDamage() && action.IsActionMelee()) 
		{ 
			thePlayer.IncreaseUninterruptedHitsCount();	

			npc.SoundEvent("cmb_play_hit_heavy");
			
			weapon_blood_fx();

			if (ACS_OnHitEffects_Enabled()
			&& ACS_GetWeaponMode() == 0)
			{
				if( curAdrenaline >= maxAdrenaline/3
				&& curAdrenaline < maxAdrenaline * 2/3
				&& npc.HasTag('aard_heavy_attack_primer') ) 
				{
					thePlayer.PlayEffect('blood_drain_fx2'); 
					thePlayer.StopEffect('blood_drain_fx2'); 
						
					if (thePlayer.IsGuarded())
					{
						thePlayer.GainStat( BCS_Vitality, heal * 2.5 ); 
					}
					else
					{
						thePlayer.GainStat( BCS_Vitality, heal * 5 ); 
					}

					ACS_Detonation_Weapon_Effects_Switch();
							
					actors = thePlayer.GetNPCsAndPlayersInRange( 1.5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
			
						dmg.AddEffectInfo( EET_Poison, 1 );
			
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
							
					Remove_On_Hit_Tags();
					npc.RemoveTag('aard_heavy_attack_primer');
					thePlayer.ForceSetStat( BCS_Focus, curAdrenaline * 0 );
				}
				else if( curAdrenaline >= maxAdrenaline * 2/3
				&& curAdrenaline < maxAdrenaline
				&& npc.HasTag('aard_heavy_attack_primer') ) 
				{
					thePlayer.PlayEffect('blood_drain_fx2'); 
					thePlayer.StopEffect('blood_drain_fx2'); 
							
					if (thePlayer.IsGuarded())
					{
						thePlayer.GainStat( BCS_Vitality, heal * 5 ); 
					}
					else
					{
						thePlayer.GainStat( BCS_Vitality, heal * 10 ); 
					}

					ACS_Detonation_Weapon_Effects_Switch();
							
					actors = thePlayer.GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
			
						dmg.AddEffectInfo( EET_Poison, 2 );
			
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
							
					Remove_On_Hit_Tags();
					npc.RemoveTag('aard_heavy_attack_primer');
					thePlayer.ForceSetStat( BCS_Focus, maxAdrenaline/3 );
				}
				else if( curAdrenaline == maxAdrenaline
				&& npc.HasTag('aard_heavy_attack_primer') ) 
				{
					thePlayer.PlayEffect('blood_drain_fx2'); 
					thePlayer.StopEffect('blood_drain_fx2'); 
							
					if (thePlayer.IsGuarded())
					{
						thePlayer.GainStat( BCS_Vitality, heal * 10 ); 
					}
					else
					{
						thePlayer.GainStat( BCS_Vitality, heal * 20 ); 
					}

					ACS_Detonation_Weapon_Effects_Switch();
							
					actors = thePlayer.GetNPCsAndPlayersInRange( 5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
			
						dmg.AddEffectInfo( EET_Poison, 3 );
			
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
							
					Remove_On_Hit_Tags();
					npc.RemoveTag('aard_heavy_attack_primer');
					thePlayer.ForceSetStat( BCS_Focus, maxAdrenaline * 2/3 );
				}
				else
				{	
					if( curAdrenaline >= maxAdrenaline/3
					&& curAdrenaline < maxAdrenaline * 2/3)
					{
						if (thePlayer.IsGuarded())
						{
							thePlayer.GainStat( BCS_Vitality, heal /4 ); 
						}
						else
						{
							thePlayer.GainStat( BCS_Vitality, heal/2 ); 
						}

						ACS_Passive_Weapon_Effects_Switch();
						aard_blade_trail();
					}
					else if( curAdrenaline >= maxAdrenaline * 2/3
					&& curAdrenaline < maxAdrenaline)
					{
						if (thePlayer.IsGuarded())
						{
							thePlayer.GainStat( BCS_Vitality, heal /2 ); 
						}
						else
						{
							thePlayer.GainStat( BCS_Vitality, heal ); 
						}

						ACS_Passive_Weapon_Effects_Switch();
						aard_blade_trail();
					}
					else if( curAdrenaline == maxAdrenaline ) 
					{
						if (thePlayer.IsGuarded())
						{
							thePlayer.GainStat( BCS_Vitality, heal ); 
						}
						else
						{
							thePlayer.GainStat( BCS_Vitality, heal * 2 ); 
						}

						ACS_Passive_Weapon_Effects_Switch();
						aard_blade_trail();
					}

					if( !npc.HasTag('aard_light_attack_primer') ) 
					{
						ACS_Marker_Switch();
						npc.AddTag('aard_light_attack_primer');
					}		
				}
			}
			else
			{
				ACS_Passive_Weapon_Effects_Switch();
			}
		}	
		
		if (playerAttacker && npc && thePlayer.HasTag('aard_secondary_sword_equipped') && action.DealtDamage() && action.IsActionMelee())
		{ 
			theSound.SoundEvent("cmb_play_hit_heavy");

			thePlayer.IncreaseUninterruptedHitsCount();	
			
			weapon_blood_fx();
			
			if (ACS_OnHitEffects_Enabled()
			&& ACS_GetWeaponMode() == 0)
			{
				if( curAdrenaline >= maxAdrenaline/3
				&& curAdrenaline < maxAdrenaline * 2/3
				&& npc.HasTag('aard_light_attack_primer') ) 
				{
					ACS_Detonation_Weapon_Effects_Switch();
						
					actors = thePlayer.GetNPCsAndPlayersInRange( 1.5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
			
						dmg.AddEffectInfo( EET_Confusion, 0.5 );
			
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
						
					Remove_On_Hit_Tags();
					npc.RemoveTag('aard_light_attack_primer');
					thePlayer.ForceSetStat( BCS_Focus, curAdrenaline * 0 );
				}
				else if( curAdrenaline >= maxAdrenaline * 2/3
				&& curAdrenaline < maxAdrenaline
				&& npc.HasTag('aard_light_attack_primer') ) 
				{
					ACS_Detonation_Weapon_Effects_Switch();
						
					actors = thePlayer.GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
			
						dmg.AddEffectInfo( EET_Confusion, 1 );
			
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
						
					Remove_On_Hit_Tags();
					npc.RemoveTag('aard_light_attack_primer');
					thePlayer.ForceSetStat( BCS_Focus, maxAdrenaline/3 );
				}
				else if( curAdrenaline == maxAdrenaline
				&& npc.HasTag('aard_light_attack_primer') ) 
				{
					ACS_Detonation_Weapon_Effects_Switch();
						
					actors = thePlayer.GetNPCsAndPlayersInRange( 5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
			
						dmg.AddEffectInfo( EET_Confusion, 1.5 );
			
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
						
					Remove_On_Hit_Tags();
					npc.RemoveTag('aard_light_attack_primer');
					thePlayer.ForceSetStat( BCS_Focus, maxAdrenaline * 2/3 );
				}
				else
				{			
					if( curAdrenaline >= maxAdrenaline/3
					&& curAdrenaline < maxAdrenaline * 2/3)
					{
						if( RandF() < 0.0625 ) 
						{ 
							if( !npc.IsImmuneToBuff( EET_Stagger ) && !npc.HasBuff( EET_Stagger ) ) 
							{ 	
								ACS_Passive_Weapon_Effects_Switch();
								aard_secondary_sword_trail();	
								//npc.AddEffectDefault( EET_Stagger, npc, 'acs_weapon_effects' );
								actors = thePlayer.GetNPCsAndPlayersInRange( 5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
								for( i = 0; i < actors.Size(); i += 1 )
								{
									actortarget = (CActor)actors[i];

									dmg = new W3DamageAction in theGame.damageMgr;
									dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
									dmg.SetProcessBuffsIfNoDamage(true);
						
									dmg.AddEffectInfo( EET_Stagger, 0.5 );
						
									theGame.damageMgr.ProcessAction( dmg );
											
									delete dmg;	
								} 							
							}
						}		
					}
					else if( curAdrenaline >= maxAdrenaline * 2/3
					&& curAdrenaline < maxAdrenaline)
					{
						if( RandF() < 0.125 ) 
						{ 
							if( !npc.IsImmuneToBuff( EET_Stagger ) && !npc.HasBuff( EET_Stagger ) ) 
							{ 	
								ACS_Passive_Weapon_Effects_Switch();
								aard_secondary_sword_trail();	
								//npc.AddEffectDefault( EET_Stagger, npc, 'acs_weapon_effects' );
								actors = thePlayer.GetNPCsAndPlayersInRange( 5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
								for( i = 0; i < actors.Size(); i += 1 )
								{
									actortarget = (CActor)actors[i];

									dmg = new W3DamageAction in theGame.damageMgr;
									dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
									dmg.SetProcessBuffsIfNoDamage(true);
						
									dmg.AddEffectInfo( EET_Stagger, 0.5 );
						
									theGame.damageMgr.ProcessAction( dmg );
											
									delete dmg;	
								} 							
							}
						}
					}
					else if( curAdrenaline == maxAdrenaline ) 
					{
						if( RandF() < 0.25 ) 
						{ 
							if( !npc.IsImmuneToBuff( EET_Stagger ) && !npc.HasBuff( EET_Stagger ) ) 
							{ 	
								ACS_Passive_Weapon_Effects_Switch();
								aard_secondary_sword_trail();	
								//npc.AddEffectDefault( EET_Stagger, npc, 'acs_weapon_effects' );
								actors = thePlayer.GetNPCsAndPlayersInRange( 5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
								for( i = 0; i < actors.Size(); i += 1 )
								{
									actortarget = (CActor)actors[i];

									dmg = new W3DamageAction in theGame.damageMgr;
									dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
									dmg.SetProcessBuffsIfNoDamage(true);
						
									dmg.AddEffectInfo( EET_Stagger, 0.5 );
						
									theGame.damageMgr.ProcessAction( dmg );
											
									delete dmg;	
								} 						
							}
						}
					}

					if ( ACS_GetWeaponMode() == 0 )
					{	
						if( !npc.HasTag('aard_heavy_attack_primer') ) 
						{
							ACS_Marker_Switch();
							npc.AddTag('aard_heavy_attack_primer');
						}
					}
				}
			}
			else
			{
				ACS_Passive_Weapon_Effects_Switch();
			}
		}	
		else if ( playerAttacker && npc && thePlayer.HasTag('yrden_sword_equipped') && action.DealtDamage() && action.IsActionMelee() ) 
		{ 
			thePlayer.IncreaseUninterruptedHitsCount();	

			if ( ACS_GetWeaponMode() == 0 )
			{
				if ( ACS_GetArmigerModeWeaponType() == 0 )
				{
					theSound.SoundEvent("cmb_play_hit_heavy");
				}
				else if ( ACS_GetArmigerModeWeaponType() == 1 )
				{
					npc.SoundEvent("monster_knight_giant_cmb_weapon_hit_add", 'head');
				}
			}
			else if ( ACS_GetWeaponMode() == 1 )
			{
				if ( ACS_GetFocusModeWeaponType() == 0 )
				{
					theSound.SoundEvent("cmb_play_hit_heavy");
				}
				else if ( ACS_GetFocusModeWeaponType() == 1 )
				{
					npc.SoundEvent("monster_knight_giant_cmb_weapon_hit_add", 'head');
				}
			}
			else if ( ACS_GetWeaponMode() == 2 )
			{
				if ( ACS_GetHybridModeWeaponType() == 0 )
				{
					theSound.SoundEvent("cmb_play_hit_heavy");
				}
				else if ( ACS_GetHybridModeWeaponType() == 1 )
				{
					npc.SoundEvent("monster_knight_giant_cmb_weapon_hit_add", 'head');
				}
			}
			else if ( ACS_GetWeaponMode() == 3 )
			{
				if ( ACS_GetItem_Imlerith_Steel_FOR_SLICING() )
				{
					theSound.SoundEvent("cmb_play_hit_heavy");
				}
				else if ( ACS_GetItem_Imlerith_Steel_FOR_THUNKING() )
				{
					npc.SoundEvent("monster_knight_giant_cmb_weapon_hit_add", 'head');
				}
			}
			
			weapon_blood_fx();
			
			if ( ACS_GetWeaponMode() == 0 )	
			{
				if( curAdrenaline >= maxAdrenaline/3
				&& curAdrenaline < maxAdrenaline * 2/3
				&& npc.HasTag('yrden_heavy_attack_primer') ) 
				{
					ACS_Detonation_Weapon_Effects_Switch();

					actors = thePlayer.GetNPCsAndPlayersInRange( 1.5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
			
						dmg.AddEffectInfo( EET_YrdenHealthDrain, 1 );
			
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
						
					ACS_AOE_Magic_Missiles_LVL_1();
						
					Remove_On_Hit_Tags();
					npc.RemoveTag('yrden_heavy_attack_primer');
					thePlayer.ForceSetStat( BCS_Focus, curAdrenaline * 0 );
				}
				else if( curAdrenaline >= maxAdrenaline * 2/3
				&& curAdrenaline < maxAdrenaline
				&& npc.HasTag('yrden_heavy_attack_primer') ) 
				{
					ACS_Detonation_Weapon_Effects_Switch();

					actors = thePlayer.GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
			
						dmg.AddEffectInfo( EET_YrdenHealthDrain, 2 );
			
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
						
					//ACS_AOE_Magic_Missiles_LVL_2();
					ACS_AOE_Magic_Missiles_LVL_1();

					Remove_On_Hit_Tags();
					npc.RemoveTag('yrden_heavy_attack_primer');
					thePlayer.ForceSetStat( BCS_Focus, maxAdrenaline/3 );
				}
				else if( curAdrenaline == maxAdrenaline
				&& npc.HasTag('yrden_heavy_attack_primer') ) 
				{
					ACS_Detonation_Weapon_Effects_Switch();

					actors = thePlayer.GetNPCsAndPlayersInRange( 5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
			
						dmg.AddEffectInfo( EET_YrdenHealthDrain, 3 );
			
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
						
					//ACS_AOE_Magic_Missiles_LVL_3();
					ACS_AOE_Magic_Missiles_LVL_2();

					Remove_On_Hit_Tags();
					npc.RemoveTag('yrden_heavy_attack_primer');
					thePlayer.ForceSetStat( BCS_Focus, maxAdrenaline * 2/3 );
				}
				else
				{								
					if( curAdrenaline >= maxAdrenaline/3
					&& curAdrenaline < maxAdrenaline * 2/3)
					{
						if( RandF() < 0.0625 ) 
						{ 
							if( !npc.IsImmuneToBuff( EET_Stagger ) && !npc.HasBuff( EET_Stagger ) ) 
							{ 	
								ACS_Passive_Weapon_Effects_Switch();
								yrden_sword_trail();	
								npc.AddEffectDefault( EET_Stagger, npc, 'acs_weapon_effects' ); 							
							}
						}
					}
					else if( curAdrenaline >= maxAdrenaline * 2/3
					&& curAdrenaline < maxAdrenaline)
					{
						if( RandF() < 0.125 ) 
						{ 
							if( !npc.IsImmuneToBuff( EET_Stagger ) && !npc.HasBuff( EET_Stagger ) ) 
							{ 	
								ACS_Passive_Weapon_Effects_Switch();
								yrden_sword_trail();	
								npc.AddEffectDefault( EET_Stagger, npc, 'acs_weapon_effects' ); 							
							}
						}
					}
					else if( curAdrenaline == maxAdrenaline ) 
					{
						if( RandF() < 0.25 ) 
						{ 
							if( !npc.IsImmuneToBuff( EET_Stagger ) && !npc.HasBuff( EET_Stagger ) ) 
							{ 	
								ACS_Passive_Weapon_Effects_Switch();
								yrden_sword_trail();	
								npc.AddEffectDefault( EET_Stagger, npc, 'acs_weapon_effects' ); 							
							}
						}
					}

					if ( ACS_GetWeaponMode() == 0 )
					{
						if( !npc.HasTag('yrden_light_attack_primer') ) 
						{
							ACS_Marker_Switch();
							npc.AddTag('yrden_light_attack_primer');
						}
					}
				}
			}
			else
			{
				ACS_Passive_Weapon_Effects_Switch();
			}
		}
		else if ( playerAttacker && npc && thePlayer.HasTag('yrden_secondary_sword_equipped') && action.DealtDamage() && action.IsActionMelee() ) 
		{ 
			thePlayer.IncreaseUninterruptedHitsCount();	

			npc.SoundEvent("monster_cloud_giant_cmb_weapon_hit_add", 'head');
			
			weapon_blood_fx();
			
			if (ACS_OnHitEffects_Enabled()
			&& ACS_GetWeaponMode() == 0)
			{
				if( curAdrenaline >= maxAdrenaline/3
				&& curAdrenaline < maxAdrenaline * 2/3
				&& npc.HasTag('yrden_light_attack_primer') ) 
				{	
					ACS_Detonation_Weapon_Effects_Switch();

					actors = thePlayer.GetNPCsAndPlayersInRange( 1.5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
			
						dmg.AddEffectInfo( EET_HeavyKnockdown, 1 );
			
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
						
					ACS_Yrden_Lightning_LVL_1();
						
					Remove_On_Hit_Tags();
					npc.RemoveTag('yrden_light_attack_primer');
					thePlayer.ForceSetStat( BCS_Focus, curAdrenaline * 0 );
				}
				else if( curAdrenaline >= maxAdrenaline * 2/3
				&& curAdrenaline < maxAdrenaline
				&& npc.HasTag('yrden_light_attack_primer') ) 
				{	
					ACS_Detonation_Weapon_Effects_Switch();

					actors = thePlayer.GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
			
						dmg.AddEffectInfo( EET_HeavyKnockdown, 2 );
			
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
						
					//ACS_Yrden_Lightning_LVL_2();
					ACS_Yrden_Lightning_LVL_1();

					Remove_On_Hit_Tags();
					npc.RemoveTag('yrden_light_attack_primer');
					thePlayer.ForceSetStat( BCS_Focus, maxAdrenaline/3 );
				}
				else if( curAdrenaline == maxAdrenaline
				&& npc.HasTag('yrden_light_attack_primer') ) 
				{	
					ACS_Detonation_Weapon_Effects_Switch();

					actors = thePlayer.GetNPCsAndPlayersInRange( 5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
			
						dmg.AddEffectInfo( EET_HeavyKnockdown, 3 );
			
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
						
					//ACS_Yrden_Lightning_LVL_3();
					ACS_Yrden_Lightning_LVL_2();

					Remove_On_Hit_Tags();
					npc.RemoveTag('yrden_light_attack_primer');
					thePlayer.ForceSetStat( BCS_Focus, maxAdrenaline * 2/3 );
				}
				else
				{						
					if( curAdrenaline >= maxAdrenaline/3
					&& curAdrenaline < maxAdrenaline * 2/3)
					{
						if( RandF() < 0.0625 ) 
						{ 
							if( !npc.IsImmuneToBuff( EET_HeavyKnockdown ) && !npc.HasBuff( EET_HeavyKnockdown ) ) 
							{ 
								ACS_Passive_Weapon_Effects_Switch();	
								yrden_secondary_sword_trail();	
								npc.AddEffectDefault( EET_HeavyKnockdown, npc, 'acs_weapon_effects' ); 							
							}
						}
					}
					else if( curAdrenaline >= maxAdrenaline * 2/3
					&& curAdrenaline < maxAdrenaline)
					{
						if( RandF() < 0.125 ) 
						{ 
							if( !npc.IsImmuneToBuff( EET_HeavyKnockdown ) && !npc.HasBuff( EET_HeavyKnockdown ) ) 
							{ 	
								ACS_Passive_Weapon_Effects_Switch();
								yrden_secondary_sword_trail();	
								npc.AddEffectDefault( EET_HeavyKnockdown, npc, 'acs_weapon_effects' ); 							
							}
						}
					}
					else if( curAdrenaline == maxAdrenaline ) 
					{
						if( RandF() < 0.25 ) 
						{ 
							if( !npc.IsImmuneToBuff( EET_HeavyKnockdown ) && !npc.HasBuff( EET_HeavyKnockdown ) ) 
							{ 	
								ACS_Passive_Weapon_Effects_Switch();
								yrden_secondary_sword_trail();	
								npc.AddEffectDefault( EET_HeavyKnockdown, npc, 'acs_weapon_effects' ); 							
							}
						}
					}
					
					if ( ACS_GetWeaponMode() == 0 )
					{
						if( !npc.HasTag('yrden_heavy_attack_primer') ) 
						{
							ACS_Marker_Switch();
							npc.AddTag('yrden_heavy_attack_primer');
						}
					}
				}
			}
			else
			{
				ACS_Passive_Weapon_Effects_Switch();
			}
		}
		else if ( playerAttacker && npc && thePlayer.HasTag('axii_sword_equipped') && action.DealtDamage() && action.IsActionMelee() )
		{ 
			//ACS_Finisher_Internal();

			thePlayer.IncreaseUninterruptedHitsCount();	

			npc.SoundEvent("cmb_play_hit_heavy");
			
			weapon_blood_fx();
			
			if (ACS_OnHitEffects_Enabled()
			&& ACS_GetWeaponMode() == 0)
			{
				if( curAdrenaline >= maxAdrenaline/3
				&& curAdrenaline < maxAdrenaline * 2/3
				&& npc.HasTag('axii_heavy_attack_primer') ) 
				{	
					ACS_Detonation_Weapon_Effects_Switch();

					actors = thePlayer.GetNPCsAndPlayersInRange( 1.5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
			
						dmg.AddEffectInfo( EET_SlowdownFrost, 1 );
			
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
						
					ACS_AOE_Ice_Spear_LVL_1();
						
					Remove_On_Hit_Tags();
					npc.RemoveTag('axii_heavy_attack_primer');
					thePlayer.ForceSetStat( BCS_Focus, curAdrenaline * 0 );
				}
				else if( curAdrenaline >= maxAdrenaline * 2/3
				&& curAdrenaline < maxAdrenaline
				&& npc.HasTag('axii_heavy_attack_primer') ) 
				{	
					ACS_Detonation_Weapon_Effects_Switch();

					actors = thePlayer.GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
			
						dmg.AddEffectInfo( EET_SlowdownFrost, 2 );
			
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
						
					//ACS_AOE_Ice_Spear_LVL_2();
					ACS_AOE_Ice_Spear_LVL_1();

					Remove_On_Hit_Tags();
					npc.RemoveTag('axii_heavy_attack_primer');
					thePlayer.ForceSetStat( BCS_Focus, maxAdrenaline/3 );
				}
				else if( curAdrenaline == maxAdrenaline
				&& npc.HasTag('axii_heavy_attack_primer') ) 
				{
					ACS_Detonation_Weapon_Effects_Switch();

					actors = thePlayer.GetNPCsAndPlayersInRange( 5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
			
						dmg.AddEffectInfo( EET_SlowdownFrost, 3 );
			
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
						
					//ACS_AOE_Ice_Spear_LVL_3();
					ACS_AOE_Ice_Spear_LVL_2();

					Remove_On_Hit_Tags();
					npc.RemoveTag('axii_heavy_attack_primer');
					thePlayer.ForceSetStat( BCS_Focus, maxAdrenaline * 2/3 );
				}
				else
				{		
					if( curAdrenaline >= maxAdrenaline/3
					&& curAdrenaline < maxAdrenaline * 2/3)
					{
						if( RandF() < 0.0625 ) 
						{ 
							if( !npc.IsImmuneToBuff( EET_SlowdownFrost ) && !npc.HasBuff( EET_SlowdownFrost ) ) 
							{
								ACS_Passive_Weapon_Effects_Switch();
								axii_sword_trail();		
								npc.AddEffectDefault( EET_SlowdownFrost, npc, 'acs_weapon_effects' ); 							
							}
						}
					}
					else if( curAdrenaline >= maxAdrenaline * 2/3
					&& curAdrenaline < maxAdrenaline)
					{
						if( RandF() < 0.125 ) 
						{ 
							if( !npc.IsImmuneToBuff( EET_SlowdownFrost ) && !npc.HasBuff( EET_SlowdownFrost ) ) 
							{
								ACS_Passive_Weapon_Effects_Switch();
								axii_sword_trail();		
								npc.AddEffectDefault( EET_SlowdownFrost, npc, 'acs_weapon_effects' ); 							
							}
						}
					}
					else if( curAdrenaline == maxAdrenaline ) 
					{
						if( RandF() < 0.25 ) 
						{ 
							if( !npc.IsImmuneToBuff( EET_SlowdownFrost ) && !npc.HasBuff( EET_SlowdownFrost ) ) 
							{
								ACS_Passive_Weapon_Effects_Switch();
								axii_sword_trail();		
								npc.AddEffectDefault( EET_SlowdownFrost, npc, 'acs_weapon_effects' ); 							
							}
						}
					}

					if ( ACS_GetWeaponMode() == 0 )
					{
						if( !npc.HasTag('axii_light_attack_primer') ) 
						{
							ACS_Marker_Switch();
							npc.AddTag('axii_light_attack_primer');
						}
					}
				}
			}
			else
			{
				ACS_Passive_Weapon_Effects_Switch();
			}
		} 
		else if ( playerAttacker && npc && thePlayer.HasTag('axii_secondary_sword_equipped') && action.DealtDamage() && action.IsActionMelee() )
		{
			//ACS_Finisher_Internal();

			thePlayer.IncreaseUninterruptedHitsCount();	

			npc.SoundEvent("cmb_play_hit_heavy");
			
			weapon_blood_fx();

			if (ACS_OnHitEffects_Enabled()
			&& ACS_GetWeaponMode() == 0)
			{
				if( curAdrenaline >= maxAdrenaline/3
				&& curAdrenaline < maxAdrenaline * 2/3
				&& npc.HasTag('axii_light_attack_primer') ) 
				{
					ACS_Detonation_Weapon_Effects_Switch();

					actors = thePlayer.GetNPCsAndPlayersInRange( 1.5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
				
						dmg.AddEffectInfo( EET_Frozen, 1 );
			
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
						
					ACS_AOE_Freeze_LVL_1();
						
					Remove_On_Hit_Tags();
					npc.RemoveTag('axii_light_attack_primer');
					thePlayer.ForceSetStat( BCS_Focus, curAdrenaline * 0 );
				}
				else if( curAdrenaline >= maxAdrenaline * 2/3
				&& curAdrenaline < maxAdrenaline
				&& npc.HasTag('axii_light_attack_primer') ) 
				{
					ACS_Detonation_Weapon_Effects_Switch();

					actors = thePlayer.GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
				
						dmg.AddEffectInfo( EET_Frozen, 2 );
			
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
						
					//ACS_AOE_Freeze_LVL_2();
					ACS_AOE_Freeze_LVL_1();
						
					Remove_On_Hit_Tags();
					npc.RemoveTag('axii_light_attack_primer');
					thePlayer.ForceSetStat( BCS_Focus, maxAdrenaline/3 );
				}
				else if( curAdrenaline == maxAdrenaline
				&& npc.HasTag('axii_light_attack_primer') ) 
				{
					ACS_Detonation_Weapon_Effects_Switch();

					actors = thePlayer.GetNPCsAndPlayersInRange( 5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
				
						dmg.AddEffectInfo( EET_Frozen, 3 );
			
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
						
					//ACS_AOE_Freeze_LVL_3();
					ACS_AOE_Freeze_LVL_2();
						
					Remove_On_Hit_Tags();
					npc.RemoveTag('axii_light_attack_primer');
					thePlayer.ForceSetStat( BCS_Focus, maxAdrenaline * 2/3 );
				}
				else
				{									
					if( curAdrenaline >= maxAdrenaline/3
					&& curAdrenaline < maxAdrenaline * 2/3)
					{
						if( RandF() < 0.0625 ) 
						{ 
							if( !npc.IsImmuneToBuff( EET_SlowdownFrost ) && !npc.HasBuff( EET_SlowdownFrost ) ) 
							{
								ACS_Passive_Weapon_Effects_Switch();
								axii_secondary_sword_trail();		
								npc.AddEffectDefault( EET_SlowdownFrost, npc, 'acs_weapon_effects' ); 							
							}
						}
					}
					else if( curAdrenaline >= maxAdrenaline * 2/3
					&& curAdrenaline < maxAdrenaline)
					{
						if( RandF() < 0.125 ) 
						{ 
							if( !npc.IsImmuneToBuff( EET_SlowdownFrost ) && !npc.HasBuff( EET_SlowdownFrost ) ) 
							{
								ACS_Passive_Weapon_Effects_Switch();
								axii_secondary_sword_trail();		
								npc.AddEffectDefault( EET_SlowdownFrost, npc, 'acs_weapon_effects' ); 							
							}
						}
					}
					else if( curAdrenaline == maxAdrenaline ) 
					{
						if( RandF() < 0.25 ) 
						{ 
							if( !npc.IsImmuneToBuff( EET_SlowdownFrost ) && !npc.HasBuff( EET_SlowdownFrost ) ) 
							{
								ACS_Passive_Weapon_Effects_Switch();
								axii_secondary_sword_trail();		
								npc.AddEffectDefault( EET_SlowdownFrost, npc, 'acs_weapon_effects' ); 							
							}
						}
					}
					
					if ( ACS_GetWeaponMode() == 0 )
					{
						if( !npc.HasTag('axii_heavy_attack_primer') ) 
						{
							ACS_Marker_Switch();
							npc.AddTag('axii_heavy_attack_primer');
						}
					}
				}
			}
			else
			{
				ACS_Passive_Weapon_Effects_Switch();
			}
		}
		else if ( playerAttacker && npc && thePlayer.HasTag('quen_sword_equipped') && action.DealtDamage() && action.IsActionMelee() )
		{ 
			//ACS_Finisher_Internal();

			thePlayer.IncreaseUninterruptedHitsCount();	

			npc.SoundEvent("cmb_play_hit_heavy");
			
			weapon_blood_fx();

			if (ACS_OnHitEffects_Enabled()
			&& ACS_GetWeaponMode() == 0)
			{
				if( curAdrenaline >= maxAdrenaline/3
				&& curAdrenaline < maxAdrenaline * 2/3
				&& npc.HasTag('quen_heavy_attack_primer') 
				) 
				{	
					ACS_Detonation_Weapon_Effects_Switch();

					actors = thePlayer.GetNPCsAndPlayersInRange( 1.5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
			
						dmg.AddEffectInfo( EET_Blindness, 1 );
			
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
						
					ACS_AOE_Sandstorm_LVL_1();
						
					Remove_On_Hit_Tags();
						
					npc.RemoveTag('quen_heavy_attack_primer');
					thePlayer.ForceSetStat( BCS_Focus, curAdrenaline * 0 );
				}
				else if( curAdrenaline >= maxAdrenaline * 2/3
				&& curAdrenaline < maxAdrenaline
				&& npc.HasTag('quen_heavy_attack_primer') 
				) 
				{	
					ACS_Detonation_Weapon_Effects_Switch();
						
					actors = thePlayer.GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
			
						dmg.AddEffectInfo( EET_Blindness, 2 );
			
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
						
					//ACS_AOE_Sandstorm_LVL_2();
					ACS_AOE_Sandstorm_LVL_1();

					Remove_On_Hit_Tags();
						
					npc.RemoveTag('quen_heavy_attack_primer');
					thePlayer.ForceSetStat( BCS_Focus, maxAdrenaline/3 );
				}
				else if( curAdrenaline == maxAdrenaline
				&& npc.HasTag('quen_heavy_attack_primer') 
				) 
				{	
					ACS_Detonation_Weapon_Effects_Switch();
						
					actors = thePlayer.GetNPCsAndPlayersInRange( 5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
			
						dmg.AddEffectInfo( EET_Blindness, 3 );
			
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
						
					//ACS_AOE_Sandstorm_LVL_3();
					ACS_AOE_Sandstorm_LVL_2();

					Remove_On_Hit_Tags();
						
					npc.RemoveTag('quen_heavy_attack_primer');
					thePlayer.ForceSetStat( BCS_Focus, maxAdrenaline * 2/3);
				}
				else
				{							
					if( curAdrenaline >= maxAdrenaline/3
					&& curAdrenaline < maxAdrenaline * 2/3)
					{
						if( RandF() < 0.0625 ) 
						{ 
							if( !npc.IsImmuneToBuff( EET_Blindness ) && !npc.HasBuff( EET_Blindness ) ) 
							{ 	
								ACS_Passive_Weapon_Effects_Switch();
								quen_sword_glow();	
								quen_sword_trail();
								npc.AddEffectDefault( EET_Blindness, npc, 'acs_weapon_effects' ); 						
							}
						}
					}
					else if( curAdrenaline >= maxAdrenaline * 2/3
					&& curAdrenaline < maxAdrenaline)
					{
						if( RandF() < 0.125 ) 
						{ 
							if( !npc.IsImmuneToBuff( EET_Blindness ) && !npc.HasBuff( EET_Blindness ) ) 
							{ 	
								ACS_Passive_Weapon_Effects_Switch();
								quen_sword_glow();	
								quen_sword_trail();
								npc.AddEffectDefault( EET_Blindness, npc, 'acs_weapon_effects' ); 						
							}
						}
					}
					else if( curAdrenaline == maxAdrenaline ) 
					{
						if( RandF() < 0.25 ) 
						{ 
							if( !npc.IsImmuneToBuff( EET_Blindness ) && !npc.HasBuff( EET_Blindness ) ) 
							{ 	
								ACS_Passive_Weapon_Effects_Switch();
								quen_sword_glow();	
								quen_sword_trail();
								npc.AddEffectDefault( EET_Blindness, npc, 'acs_weapon_effects' ); 						
							}
						}
					}

					if ( ACS_GetWeaponMode() == 0 )
					{	
						if( !npc.HasTag('quen_light_attack_primer') ) 
						{
							ACS_Marker_Switch();
							npc.AddTag('quen_light_attack_primer');
						}
					}
				}
			}
			else
			{
				ACS_Passive_Weapon_Effects_Switch();
			}
		}
		else if ( playerAttacker && npc && thePlayer.HasTag('quen_secondary_sword_equipped') && action.DealtDamage() && action.IsActionMelee() )
		{
			thePlayer.IncreaseUninterruptedHitsCount();	

			npc.SoundEvent("cmb_play_hit_heavy");
			
			weapon_blood_fx();

			if (ACS_OnHitEffects_Enabled()
			&& ACS_GetWeaponMode() == 0)
			{
				if( curAdrenaline >= maxAdrenaline/3
				&& curAdrenaline < maxAdrenaline * 2/3
				&& npc.HasTag('quen_light_attack_primer') ) 
				{	
					ACS_Detonation_Weapon_Effects_Switch();

					actors = thePlayer.GetNPCsAndPlayersInRange( 1.5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
			
						dmg.AddEffectInfo( EET_Paralyzed, 1 );
			
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
						
					ACS_AOE_Sandpillar_LVL_1();
						
					Remove_On_Hit_Tags();
						
					npc.RemoveTag('quen_light_attack_primer');
					thePlayer.ForceSetStat( BCS_Focus, curAdrenaline * 0 );
				}
				else if( curAdrenaline >= maxAdrenaline * 2/3
				&& curAdrenaline < maxAdrenaline
				&& npc.HasTag('quen_light_attack_primer') ) 
				{	
					ACS_Detonation_Weapon_Effects_Switch();

					actors = thePlayer.GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
			
						dmg.AddEffectInfo( EET_Paralyzed, 2 );
			
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
						
					//ACS_AOE_Sandpillar_LVL_2();
					ACS_AOE_Sandpillar_LVL_1();
						
					Remove_On_Hit_Tags();
						
					npc.RemoveTag('quen_light_attack_primer');
					thePlayer.ForceSetStat( BCS_Focus, maxAdrenaline/3 );
				}
				else if( curAdrenaline == maxAdrenaline
				&& npc.HasTag('quen_light_attack_primer') ) 
				{	
					ACS_Detonation_Weapon_Effects_Switch();

					actors = thePlayer.GetNPCsAndPlayersInRange( 5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
			
						dmg.AddEffectInfo( EET_Paralyzed, 3 );
			
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
						
					//ACS_AOE_Sandpillar_LVL_3();
					ACS_AOE_Sandpillar_LVL_2();
						
					Remove_On_Hit_Tags();
						
					npc.RemoveTag('quen_light_attack_primer');
					thePlayer.ForceSetStat( BCS_Focus, maxAdrenaline * 2/3 );
				}
				else
				{									
					if( curAdrenaline >= maxAdrenaline/3
					&& curAdrenaline < maxAdrenaline * 2/3)
					{
						if( RandF() < 0.0625 ) 
						{ 
							if( !npc.IsImmuneToBuff( EET_Slowdown ) && !npc.HasBuff( EET_Slowdown ) ) 
							{ 	
								ACS_Passive_Weapon_Effects_Switch();
								quen_secondary_sword_trail();	
								npc.AddEffectDefault( EET_Slowdown, npc, 'acs_weapon_effects' ); 						
							}
						}
					}
					else if( curAdrenaline >= maxAdrenaline * 2/3
					&& curAdrenaline < maxAdrenaline)
					{
						if( RandF() < 0.125 ) 
						{ 
							if( !npc.IsImmuneToBuff( EET_Slowdown ) && !npc.HasBuff( EET_Slowdown ) ) 
							{ 	
								ACS_Passive_Weapon_Effects_Switch();
								quen_secondary_sword_trail();	
								npc.AddEffectDefault( EET_Slowdown, npc, 'acs_weapon_effects' ); 						
							}
						}
					}
					else if( curAdrenaline == maxAdrenaline ) 
					{
						if( RandF() < 0.25 ) 
						{ 
							if( !npc.IsImmuneToBuff( EET_Slowdown ) && !npc.HasBuff( EET_Slowdown ) ) 
							{ 	
								ACS_Passive_Weapon_Effects_Switch();
								quen_secondary_sword_trail();	
								npc.AddEffectDefault( EET_Slowdown, npc, 'acs_weapon_effects' ); 						
							}
						}
					}

					if ( ACS_GetWeaponMode() == 0 )
					{	
						if( !npc.HasTag('quen_heavy_attack_primer') ) 
						{
							ACS_Marker_Switch();
							npc.AddTag('quen_heavy_attack_primer');
						}
					}
				}
			}
			else
			{
				ACS_Passive_Weapon_Effects_Switch();
			}
		}	
		else if ( playerAttacker && npc && thePlayer.HasTag('igni_sword_equipped_TAG') && action.DealtDamage() && action.IsActionMelee() ) 
		{ 
			actortarget.SoundEvent("cmb_play_hit_heavy");

			if (ACS_OnHitEffects_Enabled()
			&& ACS_GetWeaponMode() == 0)
			{
				if( !npc.HasTag('igni_light_attack_primer') ) 
				{
					ACS_Passive_Weapon_Effects_Switch();
					ACS_Marker_Switch();
					npc.AddTag('igni_light_attack_primer');
				}
			}
		}
		else if ( playerAttacker && npc && thePlayer.HasTag('igni_secondary_sword_equipped_TAG') && action.DealtDamage() && action.IsActionMelee() )
		{	
			actortarget.SoundEvent("cmb_play_hit_heavy");
			
			if (ACS_OnHitEffects_Enabled()
			&& ACS_GetWeaponMode() == 0)
			{
				if( curAdrenaline >= maxAdrenaline/3
				&& curAdrenaline < maxAdrenaline * 2/3
				&& npc.HasTag('igni_light_attack_primer'))
				{
					ACS_Detonation_Weapon_Effects_Switch();
							
					npc.OnIgniHit( NULL );
							
					actors = thePlayer.GetNPCsAndPlayersInRange( 1.5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
								
						dmg.SetForceExplosionDismemberment();
								
						dmg.AddEffectInfo( EET_Burning, 1 );
								
						dmg.AddEffectInfo( EET_Stagger, 1 );
								
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
							
					ACS_AOE_Igni_Blast_LVL_1();
							
					Remove_On_Hit_Tags();
					//PrimerMarkDestroy();
					npc.RemoveTag('igni_light_attack_primer');
						
					thePlayer.ForceSetStat( BCS_Focus, curAdrenaline * 0 );
				}
				else if (curAdrenaline >= maxAdrenaline * 2/3
				&& curAdrenaline < maxAdrenaline
				&& npc.HasTag('igni_light_attack_primer'))
				{
					ACS_Detonation_Weapon_Effects_Switch();
							
					npc.OnIgniHit( NULL );
							
					actors = thePlayer.GetNPCsAndPlayersInRange( 2.5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
								
						dmg.SetForceExplosionDismemberment();
								
						dmg.AddEffectInfo( EET_Burning, 2 );
								
						dmg.AddEffectInfo( EET_HeavyKnockdown, 2 );
								
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
							
					//ACS_AOE_Igni_Blast_LVL_2();
					ACS_AOE_Igni_Blast_LVL_1();

					Remove_On_Hit_Tags();
					//PrimerMarkDestroy();
					npc.RemoveTag('igni_light_attack_primer');
						
					thePlayer.ForceSetStat( BCS_Focus, maxAdrenaline/3 );
				}
				else if (curAdrenaline == maxAdrenaline 
				&& npc.HasTag('igni_light_attack_primer'))
				{
					ACS_Detonation_Weapon_Effects_Switch();
							
					npc.OnIgniHit( NULL );
							
					actors = thePlayer.GetNPCsAndPlayersInRange( 5, 100, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];

						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(thePlayer, actortarget, thePlayer, thePlayer.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
								
						dmg.SetForceExplosionDismemberment();
								
						dmg.AddEffectInfo( EET_Burning, 3 );
								
						dmg.AddEffectInfo( EET_HeavyKnockdown, 3 );
								
						theGame.damageMgr.ProcessAction( dmg );
								
						delete dmg;	
					}
							
					//ACS_AOE_Igni_Blast_LVL_3();
					ACS_AOE_Igni_Blast_LVL_2();

					Remove_On_Hit_Tags();
					//PrimerMarkDestroy();
					npc.RemoveTag('igni_light_attack_primer');
						
					thePlayer.ForceSetStat( BCS_Focus, maxAdrenaline * 2/3 );
				}
				/*
				else
				{
					ACS_Passive_Weapon_Effects_Switch();
				}
				*/
			}
		}
		else if ( playerAttacker && npc && thePlayer.HasTag('vampire_claws_equipped') && !action.WasDodged() && !(((W3Action_Attack)action).IsParried()) )
		{
			npc.StopEffect('focus_sound_red_fx');

			//thePlayer.StopEffect('blood_effect_claws_test');
			//thePlayer.PlayEffect('blood_effect_claws_test');

			ACS_Passive_Weapon_Effects_Switch();

			if (((CActor)npc).HasAbility('DisableDismemberment'))
			{
				((CActor)npc).RemoveAbility( 'DisableDismemberment');
			}
			
			thePlayer.SoundEvent("monster_dettlaff_vampire_movement_whoosh_claws_large");

			thePlayer.IncreaseUninterruptedHitsCount();	
			
			if (thePlayer.IsGuarded())
			{
				thePlayer.GainStat( BCS_Vitality, heal ); 
			}
			else
			{
				thePlayer.GainStat( BCS_Vitality, heal * 2 ); 
			}
			
			if ( thePlayer.HasBuff(EET_BlackBlood) )
			{
				ACS_Vampire_Arms_1_Get().PlayEffect('blood');

				ACS_Vampire_Arms_1_Get().StopEffect('blood');

				ACS_Vampire_Arms_2_Get().PlayEffect('blood');

				ACS_Vampire_Arms_2_Get().StopEffect('blood');

				ACS_Vampire_Arms_3_Get().PlayEffect('blood');

				ACS_Vampire_Arms_3_Get().StopEffect('blood');

				ACS_Vampire_Arms_4_Get().PlayEffect('blood');

				ACS_Vampire_Arms_4_Get().StopEffect('blood');

				thePlayer.StopEffect('blood_effect_claws');
				thePlayer.PlayEffect('blood_effect_claws');

				actors = thePlayer.GetNPCsAndPlayersInCone(2, VecHeading(thePlayer.GetHeadingVector()), 90, 20, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );
			}
			else
			{
				actors = thePlayer.GetNPCsAndPlayersInCone(1.25, VecHeading(thePlayer.GetHeadingVector()), 60, 20, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );
			}

			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				thePlayer.SoundEvent("cmb_play_dismemberment_gore");

				thePlayer.SoundEvent("monster_dettlaff_monster_vein_hit_blood");

				dmg = new W3DamageAction in theGame.damageMgr;
				
				dmg.Initialize(thePlayer, actortarget, NULL, thePlayer.GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
				
				dmg.SetProcessBuffsIfNoDamage(true);

				dmg.SetForceExplosionDismemberment();
				
				dmg.SetHitReactionType( EHRT_Heavy, true);

				dmg.SetIgnoreArmor(true);

				dmg.SetIgnoreImmortalityMode(true);
				
				//dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, RandRangeF(damageMax,damageMin) );

				if (actortarget.UsesVitality()) 
				{ 
					maxTargetVitality = actortarget.GetStatMax( BCS_Vitality );

					damageMax = maxTargetVitality * 0.10; 
					
					damageMin = maxTargetVitality * 0.075; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					maxTargetEssence = actortarget.GetStatMax( BCS_Essence );
					
					damageMax = maxTargetEssence * 0.125; 
					
					damageMin = maxTargetEssence * 0.075; 
				} 

				dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(damageMax,damageMin) );

				dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(damageMax,damageMin) );

				if (RandF() < 0.25 )
				{
					if( !npc.IsImmuneToBuff( EET_Stagger ) && !npc.HasBuff( EET_Stagger ) ) 
					{ 
						dmg.AddEffectInfo( EET_Stagger, 0.1 );
					}
				}

				if( !npc.IsImmuneToBuff( EET_Bleeding ) && !npc.HasBuff( EET_Bleeding ) ) 
				{ 
					dmg.AddEffectInfo( EET_Bleeding, 1 );
				}

				if( !npc.IsImmuneToBuff( EET_BleedingTracking ) && !npc.HasBuff( EET_BleedingTracking ) ) 
				{ 
					dmg.AddEffectInfo( EET_BleedingTracking, 3 );
				}
					
				theGame.damageMgr.ProcessAction( dmg );
					
				delete dmg;	
			}
		}
		else
		{
			thePlayer.ResetUninterruptedHitsCount();
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	function shield_play_anim()
	{
		shieldAnimatedComponent = (CAnimatedComponent)ACS_Shield_Entity().GetComponentByClassName( 'CAnimatedComponent' );	

		//shieldAnimSettings.blendIn = 0.2f;
		//shieldAnimSettings.blendOut = 0.5f;

		shieldAnimSettings.blendIn = 0.9f;
		shieldAnimSettings.blendOut = 1.0f;

		actor = (CActor)( thePlayer.GetDisplayTarget() );

		shieldMovementAdjustor = ((CMovingPhysicalAgentComponent)ACS_Shield_Entity().GetMovingAgentComponent()).GetMovementAdjustor();

		shieldMovementAdjustor.CancelAll();
		
		shieldTicket = shieldMovementAdjustor.CreateNewRequest( 'ACS_Shield_Movement_Adjust' );

		shieldMovementAdjustor.AdjustmentDuration( shieldTicket, 0.25 );
		//shieldMovementAdjustor.ShouldStartAt(shieldTicket, ACS_Shield_Entity().GetWorldPosition());
		shieldMovementAdjustor.MaxRotationAdjustmentSpeed( shieldTicket, 50000 );
		shieldMovementAdjustor.MaxLocationAdjustmentSpeed( shieldTicket, 50000 );
		//shieldMovementAdjustor.AdjustLocationVertically( shieldTicket, true );
		//shieldMovementAdjustor.ScaleAnimationLocationVertically( shieldTicket, true );

		shieldMovementAdjustor.RotateTo( shieldTicket, VecHeading(thePlayer.GetHeadingVector()) );

		acs_shield_attack_index_1 = RandDifferent(this.previous_acs_shield_attack_index_1 , 7);

		switch (acs_shield_attack_index_1) 
		{	
			case 6:
			shieldAnimatedComponent.PlaySlotAnimationAsync ( 'monster_lessun_counter_attack', 'NPC_ANIM_SLOT', shieldAnimSettings);
			break;

			case 5:
			shieldAnimatedComponent.PlaySlotAnimationAsync ( 'monster_lessun_attack_back', 'NPC_ANIM_SLOT', shieldAnimSettings);
			break;

			case 4:
			shieldAnimatedComponent.PlaySlotAnimationAsync ( 'monster_lessun_attack_right_swing', 'NPC_ANIM_SLOT', shieldAnimSettings);
			break;
				
			case 3:
			shieldAnimatedComponent.PlaySlotAnimationAsync ( 'monster_lessun_attack_right', 'NPC_ANIM_SLOT', shieldAnimSettings);
			break;

			case 2:
			shieldAnimatedComponent.PlaySlotAnimationAsync ( 'monster_lessun_attack_left_swing', 'NPC_ANIM_SLOT', shieldAnimSettings);
			break;	
				
			case 1:
			shieldAnimatedComponent.PlaySlotAnimationAsync ( 'monster_lessun_attack_left', 'NPC_ANIM_SLOT', shieldAnimSettings);
			break;

			default:
			shieldAnimatedComponent.PlaySlotAnimationAsync ( 'monster_lessun_attack_center', 'NPC_ANIM_SLOT', shieldAnimSettings);
			break;
		}
			
		this.previous_acs_shield_attack_index_1 = acs_shield_attack_index_1;

		ACS_Shield_Entity().StopEffect('yrden_shock');
		ACS_Shield_Entity().PlayEffect('yrden_shock');

		ACS_Shield_Entity().StopEffect('yrden_slowdown');
		ACS_Shield_Entity().PlayEffect('yrden_slowdown');

		ACS_Shield_Entity().StopEffect('yrden_paralysis');
		ACS_Shield_Entity().PlayEffect('yrden_paralysis');

		ACS_Shield_Entity().PlayEffect('demonic_possession');
		ACS_Shield_Entity().StopEffect('demonic_possession');
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	function FinisherCheck() : bool
	{
		if ( thePlayer.IsPerformingFinisher() 
		|| thePlayer.IsCrossbowHeld() 
		|| !ACS_BuffCheck())
		{
			return false;
		}
		else
		{
			return true;
		}
	}
	
	function CiriCheck() : bool
	{
		if ( thePlayer.IsCiri() )
		{
			return false;
		}
		else
		{
			return true;
		}
	}

	function WraithModeCheck() : bool
	{
		if ( thePlayer.HasTag('in_wraith') )
		{
			return false;
		}
		else
		{
			return true;
		}
	}

	function BruxaBiteCheck() : bool
	{
		if ( thePlayer.HasTag('blood_sucking') )
		{
			return false;
		}
		else
		{
			return true;
		}
	}

	function HitAnimCheck() : bool
	{
		if ( thePlayer.IsInHitAnim() )
		{
			return false;
		}
		else
		{
			return true;
		}
	}

	function StaminaCheck() : bool
	{
		if ( thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.15 )
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	function VampireClawsStaminaCheck() : bool
	{
		if ( thePlayer.GetStat( BCS_Stamina ) <= thePlayer.GetStatMax( BCS_Stamina ) * 0.05 )
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	function FinisherDistanceCheck() : bool
	{
		if ( VecDistance( thePlayer.GetWorldPosition(), actor.GetNearestPointInBothPersonalSpaces( thePlayer.GetWorldPosition() ) ) < 1.5f )
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	function ClawFistLightAttack()
	{
		DeactivateThings();

		ACS_ThingsThatShouldBeRemoved();

		ACS_ExplorationDelayHack();
		
		ACS_Finisher_PreAction();

		if (thePlayer.IsActionAllowed(EIAB_LightAttacks))
		{
			if (ACS_GetWeaponMode() == 0)
			{
				if (ACS_GetFistMode() == 0)
				{
					ACS_PrimaryWeaponSwitch();

					ACS_Setup_Combat_Action_Light();
				}
				else if (ACS_GetFistMode() == 1
				&& CiriCheck() 
				&& FinisherCheck()
				&& WraithModeCheck() 
				&& BruxaBiteCheck()
				&& HitAnimCheck()
				&& ACS_can_perform_light_attack())
				{
					VampClawLightAttack();
				}
				else if (ACS_GetFistMode() == 2
				&& FinisherCheck()
				&& WraithModeCheck() 
				&& BruxaBiteCheck()
				&& HitAnimCheck()
				)
				{
					ACS_PrimaryWeaponSwitch();

					ShockwaveFistLightAttack();
				}
			}
			else if (ACS_GetWeaponMode() == 1)
			{
				if (ACS_GetFistMode() == 0)
				{
					ACS_PrimaryWeaponSwitch();

					ACS_Setup_Combat_Action_Light();
				}
				else if (ACS_GetFistMode() == 1
				&& CiriCheck() 
				&& FinisherCheck()
				&& WraithModeCheck() 
				&& BruxaBiteCheck()
				&& HitAnimCheck()
				&& ACS_can_perform_light_attack())
				{
					VampClawLightAttack();
				}
				else if (ACS_GetFistMode() == 2
				&& FinisherCheck()
				&& WraithModeCheck() 
				&& BruxaBiteCheck()
				&& HitAnimCheck()
				)
				{
					ACS_PrimaryWeaponSwitch();

					ShockwaveFistLightAttack();
				}
			}
			else if (ACS_GetWeaponMode() == 2)
			{
				if (ACS_GetFistMode() == 0)
				{
					ACS_PrimaryWeaponSwitch();

					ACS_Setup_Combat_Action_Light();
				}
				else if (ACS_GetFistMode() == 1
				&& CiriCheck() 
				&& FinisherCheck()
				&& WraithModeCheck() 
				&& BruxaBiteCheck()
				&& HitAnimCheck()
				&& ACS_can_perform_light_attack())
				{
					VampClawLightAttack();
				}
				else if (ACS_GetFistMode() == 2
				&& FinisherCheck()
				&& WraithModeCheck() 
				&& BruxaBiteCheck()
				&& HitAnimCheck()
				)
				{
					ACS_PrimaryWeaponSwitch();

					ShockwaveFistLightAttack();
				}
			}
			else if (ACS_GetWeaponMode() == 3)
			{
				if ( (ACS_GetItem_VampClaw() || ACS_GetItem_VampClaw_Shades())
				&& CiriCheck() 
				&& FinisherCheck()
				&& WraithModeCheck() 
				&& BruxaBiteCheck()
				&& HitAnimCheck()
				&& ACS_can_perform_light_attack())
				{
					VampClawLightAttack();
				}
				else
				{
					ACS_PrimaryWeaponSwitch();

					ACS_Setup_Combat_Action_Light();
				}
			}
		}

		//thePlayer.SetBehaviorVariable( 'playerToTargetDistForOverlay', VecDistance( thePlayer.GetWorldPosition(), actor.GetNearestPointInPersonalSpace( thePlayer.GetWorldPosition() ) ) );

		DeactivateThings();
	}

	function ClawFistHeavyAttack()
	{
		DeactivateThings();

		ACS_ThingsThatShouldBeRemoved();

		ACS_ExplorationDelayHack();

		ACS_Finisher_PreAction();

		if (thePlayer.IsActionAllowed(EIAB_HeavyAttacks))
		{
			if (ACS_GetWeaponMode() == 0)
			{
				if (ACS_GetFistMode() == 0)
				{
					ACS_PrimaryWeaponSwitch();

					ACS_Setup_Combat_Action_Heavy();	
				}
				else if (ACS_GetFistMode() == 1
				&& CiriCheck() 
				&& FinisherCheck()
				&& WraithModeCheck() 
				&& BruxaBiteCheck()
				&& HitAnimCheck()
				&& ACS_can_perform_heavy_attack())
				{
					VampClawHeavyAttack();
				}
				else if (ACS_GetFistMode() == 2
				&& FinisherCheck()
				&& WraithModeCheck() 
				&& BruxaBiteCheck()
				&& HitAnimCheck()
				)
				{
					ACS_PrimaryWeaponSwitch();

					ShockwaveFistHeavyAttack();
				}
			}
			else if (ACS_GetWeaponMode() == 1)
			{
				if (ACS_GetFistMode() == 0)
				{
					ACS_PrimaryWeaponSwitch();

					ACS_Setup_Combat_Action_Heavy();	
				}
				else if (ACS_GetFistMode() == 1
				&& CiriCheck() 
				&& FinisherCheck()
				&& WraithModeCheck() 
				&& BruxaBiteCheck()
				&& HitAnimCheck()
				&& ACS_can_perform_heavy_attack())
				{
					VampClawHeavyAttack();
				}
				else if (ACS_GetFistMode() == 2
				&& FinisherCheck()
				&& WraithModeCheck() 
				&& BruxaBiteCheck()
				&& HitAnimCheck()
				)
				{
					ACS_PrimaryWeaponSwitch();

					ShockwaveFistHeavyAttack();
				}
			}
			else if (ACS_GetWeaponMode() == 2)
			{
				if (ACS_GetFistMode() == 0)
				{
					ACS_PrimaryWeaponSwitch();

					ACS_Setup_Combat_Action_Heavy();	
				}
				else if (ACS_GetFistMode() == 1
				&& CiriCheck() 
				&& FinisherCheck()
				&& WraithModeCheck() 
				&& BruxaBiteCheck()
				&& HitAnimCheck()
				&& ACS_can_perform_heavy_attack())
				{
					VampClawHeavyAttack();
				}
				else if (ACS_GetFistMode() == 2
				&& FinisherCheck()
				&& WraithModeCheck() 
				&& BruxaBiteCheck()
				&& HitAnimCheck()
				)
				{
					ACS_PrimaryWeaponSwitch();

					ShockwaveFistHeavyAttack();
				}
			}
			else if (ACS_GetWeaponMode() == 3)
			{
				if ( (ACS_GetItem_VampClaw() || ACS_GetItem_VampClaw_Shades())
				&& CiriCheck() 
				&& FinisherCheck()
				&& WraithModeCheck() 
				&& BruxaBiteCheck()
				&& HitAnimCheck()
				&& ACS_can_perform_light_attack())
				{
					VampClawHeavyAttack();
				}
				else
				{
					ACS_PrimaryWeaponSwitch();

					thePlayer.SetupCombatAction( EBAT_HeavyAttack, BS_Pressed );
				}
			}
		}

		//thePlayer.SetBehaviorVariable( 'playerToTargetDistForOverlay', VecDistance( thePlayer.GetWorldPosition(), actor.GetNearestPointInPersonalSpace( thePlayer.GetWorldPosition() ) ) );

		DeactivateThings();
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	function GuardAttack()
	{
		DeactivateThings();

		ACS_ThingsThatShouldBeRemoved();

		ACS_ExplorationDelayHack();

		ACS_Finisher_PreAction();

		vACS_Shield_Summon = new cACS_Shield_Summon in this;

		if( GuardAttackCallTime + DOUBLE_TAP_WINDOW >= theGame.GetEngineTimeAsSeconds() )
		{
			GuardAttackDoubleTap = true;
		}
		else
		{
			GuardAttackDoubleTap = false;	
		}

		if ( thePlayer.IsActionAllowed(EIAB_Parry) )
		{
			if (
			CiriCheck() 
			&& HitAnimCheck()
			&& FinisherCheck()
			&& BruxaBiteCheck()
			)
			{
				if ( WraithModeCheck() )
				{
					if (ACS_GetWeaponMode() == 0)
					{
						ACSGetEquippedSword().StopAllEffects();

						if ( ACS_StaminaBlockAction_Enabled() 
						&& StaminaCheck()
						)
						{							 
							thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
						}
						else
						{
							if (theInput.GetActionValue('GI_AxisLeftY') > 0.5 )
							{
								if( GuardAttackDoubleTap )
								{
									if 
									( 
										(thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax(BCS_Focus) * 0.9)
										&& ACS_can_perform_guard_doubletap_attack()
										&& ACS_SwordArray_Enabled() 
									)
									{
										ACS_refresh_guard_doubletap_attack_cooldown();
														
										ACS_Sword_Array();
									}
									else
									{
										RandomKickActual();
									}
								}
								else
								{	
									if ( !thePlayer.IsWeaponHeld( 'fist' ) )
									{
										if ( thePlayer.GetEquippedSign() == ST_Igni )
										{
											if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
											{
												IgniCounterActual();
											}
											else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
											{
												QuenCounterActual();
											}
											else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
											{
												AxiiCounterActual();
											}
											else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
											{
												AardCounterActual();
											}
											else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
											{
												YrdenCounterActual();
											}
										}
										else if ( thePlayer.GetEquippedSign() == ST_Axii )
										{
											if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
											{
												IgniCounterActual();
											}
											else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
											{
												QuenCounterActual();
											}
											else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
											{
												AxiiCounterActual();
											}
											else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
											{
												AardCounterActual();
											}
											else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
											{
												YrdenCounterActual();
											}
										}
										else if ( thePlayer.GetEquippedSign() == ST_Aard )
										{
											if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
											{
												IgniCounterActual();
											}
											else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
											{
												QuenCounterActual();
											}
											else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
											{
												AxiiCounterActual();
											}
											else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
											{
												AardCounterActual();
											}
											else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
											{
												YrdenCounterActual();
											}
										}
										else if ( thePlayer.GetEquippedSign() == ST_Quen )
										{
											if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
											{
												IgniCounterActual();
											}
											else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
											{
												QuenCounterActual();
											}
											else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
											{
												AxiiCounterActual();
											}
											else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
											{
												AardCounterActual();
											}
											else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
											{
												YrdenCounterActual();
											}
										}
										else if ( thePlayer.GetEquippedSign() == ST_Yrden )
										{
											if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
											{
												IgniCounterActual();
											}
											else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
											{
												QuenCounterActual();
											}
											else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
											{
												AxiiCounterActual();
											}
											else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
											{
												AardCounterActual();
											}
											else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
											{
												YrdenCounterActual();
											}
										}
									}
									else
									{	
										if (ACS_can_perform_guard_attack()
										&& ACS_GetFistMode() == 1)
										{
											ACS_refresh_guard_attack_cooldown();
																		
											geraltRandomAardCounter();
											
											thePlayer.DrainStamina(ESAT_LightAttack);
										}
									}
								}
													
								GuardAttackCallTime = theGame.GetEngineTimeAsSeconds();
							}
							else if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
							{		
								if( GuardAttackDoubleTap )
								{
									if (ACS_can_perform_guard_attack()
									&& ACS_SummonedShades_Enabled()
									)
									{
										ACS_refresh_guard_attack_cooldown();

										if (!thePlayer.HasTag('summoned_shades'))
										{
											thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_yrden_ground', 'PLAYER_SLOT', settings);	
																	
											if(thePlayer.IsInCombat()){ACS_Spawn_Shades();}
															
											thePlayer.AddTag('summoned_shades');
										}
									}
								}
								else
								{
									if (thePlayer.IsHardLockEnabled())
									{
										if (ACS_can_perform_beam_attack()
										&& ACS_BeamAttack_Enabled()
										)
										{
											ACS_refresh_beam_attack_cooldown();
																
											if(thePlayer.IsInCombat()){ACS_Beam_Attack();}
										}
									}	
								}
												
								GuardAttackCallTime = theGame.GetEngineTimeAsSeconds();
							}
							else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5 )
							{	
								if (ACS_can_perform_guard_attack())
								{
									ACS_refresh_guard_attack_cooldown();

									geraltRandomPunch();
									
									thePlayer.DrainStamina(ESAT_LightAttack);
								}	
							}
							else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5 )
							{		
								if (ACS_can_perform_guard_attack())
								{
									ACS_refresh_guard_attack_cooldown();

									geraltRandomPush();
									
									thePlayer.DrainStamina(ESAT_LightAttack);
								}	
							}
							else
							{
								if( GuardAttackDoubleTap )
								{
									if (ACS_can_perform_guard_doubletap_attack() && thePlayer.IsInCombat())
									{
										ACS_refresh_guard_doubletap_attack_cooldown();
														
										if(thePlayer.HasTag('axii_sword_equipped')
										&& ACS_ShieldEntity_Enabled()
										)
										{
											if(thePlayer.IsInCombat()){vACS_Shield_Summon.Axii_Shield_Summon();}
											vACS_Shield_Summon.Axii_Shield_Entity();
										}
										else if (thePlayer.HasTag('quen_sword_equipped')
										&& ACS_QuenMonsterSummon_Enabled()
										)
										{
											thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_yrden_ground', 'PLAYER_SLOT', settings);

											vACS_Shield_Summon.Quen_Monster_Summon();
										}
										else if (thePlayer.HasTag('yrden_sword_equipped')
										&& ACS_YrdenSkeleSummon_Enabled()
										)
										{
											thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_yrden_ground', 'PLAYER_SLOT', settings);	

											vACS_Shield_Summon.Yrden_Skele_Summon();
										}
										else if (thePlayer.HasTag('aard_sword_equipped')
										&& ACS_AardPull_Enabled()
										)
										{
											thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_yrden_ground', 'PLAYER_SLOT', settings);	

											vACS_Shield_Summon.Aard_Pull();

											AddTimer('ACS_bruxa_camo_npc_reaction', 0.5, true);
										}
										else if (thePlayer.HasTag('vampire_claws_equipped')
										&& ACS_BruxaCamoDecoy_Enabled()
										&& !thePlayer.HasBuff(EET_BlackBlood)
										)
										{
											vACS_Shield_Summon.BruxaCamoDecoy();

											AddTimer('ACS_npc_fear_reaction', 0.875, true);
										}
										else if (thePlayer.HasTag('quen_secondary_sword_equipped')
										|| thePlayer.HasTag('axii_secondary_sword_equipped')
										)
										{
											//thePlayer.AddTag('acs_crossbow_active');
											thePlayer.AddTag('acs_bow_active');
										}
										else if (thePlayer.HasTag('aard_secondary_sword_equipped')
										|| thePlayer.HasTag('yrden_secondary_sword_equipped')
										|| thePlayer.HasTag('igni_secondary_sword_equipped')
										)
										{
											thePlayer.AddTag('acs_bow_active');
										}
									}
								}
								else
								{
									if(thePlayer.HasTag('axii_sword_equipped'))
									{
										action_interrupt();
										if(thePlayer.IsInCombat()){vACS_Shield_Summon.Axii_Shield_Summon();}
									}
								}
												
								GuardAttackCallTime = theGame.GetEngineTimeAsSeconds();
							}
						}
					}
					else if (ACS_GetWeaponMode() == 1)
					{
						ACSGetEquippedSword().StopAllEffects();

						if ( ACS_StaminaBlockAction_Enabled() 
						&& StaminaCheck()
						)
						{
							thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
						}
						else
						{
							if (theInput.GetActionValue('GI_AxisLeftY') > 0.5 )
							{
								if( GuardAttackDoubleTap )
								{
									if 
									( 
										(thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax(BCS_Focus) * 0.9)
										&& ACS_can_perform_guard_doubletap_attack()
										&& ACS_SwordArray_Enabled() 
									)
									{
										ACS_refresh_guard_doubletap_attack_cooldown();
														
										ACS_Sword_Array();
									}
									else
									{
										RandomKickActual();
									}
								}
								else
								{	
									if ( !thePlayer.IsWeaponHeld( 'fist' ) )
									{
										if ( thePlayer.IsWeaponHeld( 'silversword' ) )
										{
											if ( ACS_GetFocusModeSilverWeapon() == 0 )
											{
												IgniCounterActual();
											}
											else if ( ACS_GetFocusModeSilverWeapon() == 1 )
											{
												HybridModeOlgierdCounterActual();
											}
											else if ( ACS_GetFocusModeSilverWeapon() == 2 )
											{
												HybridModeSpearCounterActual();
											}
											else if ( ACS_GetFocusModeSilverWeapon() == 3 )
											{
												HybridModeEredinShieldCounterActual();
											}
											else if ( ACS_GetFocusModeSilverWeapon() == 4 )
											{
												HybridModeGregCounterActual();
											}
											else if ( ACS_GetFocusModeSilverWeapon() == 5 )
											{
												HybridModeImlerithCounterActual();
											}
											else if ( ACS_GetFocusModeSilverWeapon() == 6 )
											{
												HybridModeGiantCounterActual();
											}
											else if ( ACS_GetFocusModeSilverWeapon() == 7 )
											{
												HybridModeClawCounterActual();
											}
											else if ( ACS_GetFocusModeSilverWeapon() == 8 )
											{
												HybridModeAxeCounterActual();
											}
										}
										else if ( thePlayer.IsWeaponHeld('steelsword') )
										{
											if ( ACS_GetFocusModeSteelWeapon() == 0 )
											{
												IgniCounterActual();
											}
											else if ( ACS_GetFocusModeSteelWeapon() == 1 )
											{
												HybridModeOlgierdCounterActual();
											}
											else if ( ACS_GetFocusModeSteelWeapon() == 2 )
											{
												HybridModeSpearCounterActual();
											}
											else if ( ACS_GetFocusModeSteelWeapon() == 3 )
											{
												HybridModeEredinShieldCounterActual();
											}
											else if ( ACS_GetFocusModeSteelWeapon() == 4 )
											{
												HybridModeGregCounterActual();
											}
											else if ( ACS_GetFocusModeSteelWeapon() == 5 )
											{
												HybridModeImlerithCounterActual();
											}
											else if ( ACS_GetFocusModeSteelWeapon() == 6 )
											{
												HybridModeGiantCounterActual();
											}
											else if ( ACS_GetFocusModeSteelWeapon() == 7 )
											{
												HybridModeClawCounterActual();
											}
											else if ( ACS_GetFocusModeSteelWeapon() == 8 )
											{
												HybridModeAxeCounterActual();
											}
										}
									}
									else
									{	
										if (ACS_can_perform_guard_attack()
										&& ACS_GetFistMode() == 1)
										{
											ACS_refresh_guard_attack_cooldown();
																		
											geraltRandomAardCounter();
											
											thePlayer.DrainStamina(ESAT_LightAttack);
										}
									}
								}
													
								GuardAttackCallTime = theGame.GetEngineTimeAsSeconds();
							}
							else if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
							{		
								if( GuardAttackDoubleTap )
								{
									if (ACS_can_perform_guard_attack()
									&& ACS_SummonedShades_Enabled()
									)
									{
										ACS_refresh_guard_attack_cooldown();

										if (!thePlayer.HasTag('summoned_shades'))
										{
											thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_yrden_ground', 'PLAYER_SLOT', settings);	
																	
											if(thePlayer.IsInCombat()){ACS_Spawn_Shades();}
															
											thePlayer.AddTag('summoned_shades');
										}
									}
								}
								else
								{
									if (thePlayer.IsHardLockEnabled())
									{
										if (ACS_can_perform_beam_attack()
										&& ACS_BeamAttack_Enabled()
										)
										{
											ACS_refresh_beam_attack_cooldown();
																
											if(thePlayer.IsInCombat()){ACS_Beam_Attack();}
										}
									}	
								}
												
								GuardAttackCallTime = theGame.GetEngineTimeAsSeconds();
							}
							else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5 )
							{	
								if (ACS_can_perform_guard_attack())
								{
									ACS_refresh_guard_attack_cooldown();

									geraltRandomPunch();
									
									thePlayer.DrainStamina(ESAT_LightAttack);
								}	
							}
							else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5 )
							{		
								if (ACS_can_perform_guard_attack())
								{
									ACS_refresh_guard_attack_cooldown();

									geraltRandomPush();
									
									thePlayer.DrainStamina(ESAT_LightAttack);
								}	
							}
							else
							{
								if( GuardAttackDoubleTap )
								{
									if (ACS_can_perform_guard_doubletap_attack() && thePlayer.IsInCombat())
									{
										ACS_refresh_guard_doubletap_attack_cooldown();
														
										if(thePlayer.HasTag('axii_sword_equipped')
										&& ACS_ShieldEntity_Enabled()
										)
										{
											if(thePlayer.IsInCombat()){vACS_Shield_Summon.Axii_Shield_Summon();}
											vACS_Shield_Summon.Axii_Shield_Entity();
										}
										else if (thePlayer.HasTag('quen_sword_equipped')
										&& ACS_QuenMonsterSummon_Enabled()
										)
										{
											thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_yrden_ground', 'PLAYER_SLOT', settings);

											vACS_Shield_Summon.Quen_Monster_Summon();
										}
										else if (thePlayer.HasTag('yrden_sword_equipped')
										&& ACS_YrdenSkeleSummon_Enabled()
										)
										{
											thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_yrden_ground', 'PLAYER_SLOT', settings);

											vACS_Shield_Summon.Yrden_Skele_Summon();
										}
										else if (thePlayer.HasTag('aard_sword_equipped')
										&& ACS_AardPull_Enabled()
										)
										{
											thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_yrden_ground', 'PLAYER_SLOT', settings);

											vACS_Shield_Summon.Aard_Pull();

											AddTimer('ACS_bruxa_camo_npc_reaction', 0.5, true);
										}
										else if (thePlayer.HasTag('vampire_claws_equipped')
										&& ACS_BruxaCamoDecoy_Enabled() 
										&& !thePlayer.HasBuff(EET_BlackBlood)
										)
										{
											vACS_Shield_Summon.BruxaCamoDecoy();

											AddTimer('ACS_npc_fear_reaction', 0.875, true);
										}
										else if (thePlayer.HasTag('quen_secondary_sword_equipped')
										|| thePlayer.HasTag('axii_secondary_sword_equipped')
										)
										{
											//thePlayer.AddTag('acs_crossbow_active');
											thePlayer.AddTag('acs_bow_active');
										}
										else if (thePlayer.HasTag('aard_secondary_sword_equipped')
										|| thePlayer.HasTag('yrden_secondary_sword_equipped')
										|| thePlayer.HasTag('igni_secondary_sword_equipped')
										)
										{
											thePlayer.AddTag('acs_bow_active');
										}
									}
								}
								else
								{
									if(thePlayer.HasTag('axii_sword_equipped'))
									{
										action_interrupt();
										if(thePlayer.IsInCombat()){vACS_Shield_Summon.Axii_Shield_Summon();}
									}
								}
												
								GuardAttackCallTime = theGame.GetEngineTimeAsSeconds();
							}
						}
					}
					else if (ACS_GetWeaponMode() == 2)
					{
						ACSGetEquippedSword().StopAllEffects();

						if ( ACS_StaminaBlockAction_Enabled() 
						&& StaminaCheck()
						)
						{
							thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
						}
						else
						{
							if (theInput.GetActionValue('GI_AxisLeftY') > 0.5 )
							{
								if( GuardAttackDoubleTap )
								{
									if 
									( 
										(thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax(BCS_Focus) * 0.9)
										&& ACS_can_perform_guard_doubletap_attack()
										&& ACS_SwordArray_Enabled() 
									)
									{
										ACS_refresh_guard_doubletap_attack_cooldown();
														
										ACS_Sword_Array();
									}
									else
									{
										RandomKickActual();
									}
								}
								else
								{	
									if ( !thePlayer.IsWeaponHeld( 'fist' ) )
									{
										if ( thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld('steelsword') )
										{
											if ( ACS_GetHybridModeCounterAttack() == 0 )
											{
												if (!thePlayer.HasTag('HybridDefaultWeaponTicket')){thePlayer.AddTag('HybridDefaultWeaponTicket');}

												IgniCounterActual();
											}
											else if ( ACS_GetHybridModeCounterAttack() == 1 )
											{
												if (!thePlayer.HasTag('HybridOlgierdWeaponTicket')){thePlayer.AddTag('HybridOlgierdWeaponTicket');}

												HybridModeOlgierdCounterActual();
											}
											else if ( ACS_GetHybridModeCounterAttack() == 2 )
											{
												if (!thePlayer.HasTag('HybridEredinWeaponTicket')){thePlayer.AddTag('HybridEredinWeaponTicket');}

												HybridModeEredinShieldCounterActual();
											}
											else if ( ACS_GetHybridModeCounterAttack() == 3 )
											{
												if (!thePlayer.HasTag('HybridClawWeaponTicket')){thePlayer.AddTag('HybridClawWeaponTicket');}

												HybridModeClawCounterActual();
											}
											else if ( ACS_GetHybridModeCounterAttack() == 4 )
											{
												if (!thePlayer.HasTag('HybridImlerithWeaponTicket')){thePlayer.AddTag('HybridImlerithWeaponTicket');}

												HybridModeImlerithCounterActual();
											}
											else if ( ACS_GetHybridModeCounterAttack() == 5 )
											{
												if (!thePlayer.HasTag('HybridSpearWeaponTicket')){thePlayer.AddTag('HybridSpearWeaponTicket');}

												HybridModeSpearCounterActual();
											}
											else if ( ACS_GetHybridModeCounterAttack() == 6 )
											{
												if (!thePlayer.HasTag('HybridGregWeaponTicket')){thePlayer.AddTag('HybridGregWeaponTicket');}

												HybridModeGregCounterActual();
											}
											else if ( ACS_GetHybridModeCounterAttack() == 7 )
											{
												if (!thePlayer.HasTag('HybridAxeWeaponTicket')){thePlayer.AddTag('HybridAxeWeaponTicket');}

												HybridModeAxeCounterActual();
											}
											else if ( ACS_GetHybridModeCounterAttack() == 8 )
											{
												if (!thePlayer.HasTag('HybridGiantWeaponTicket')){thePlayer.AddTag('HybridGiantWeaponTicket');}

												HybridModeGiantCounterActual();
											}
										}
									}
									else
									{	
										if (ACS_can_perform_guard_attack()
										&& ACS_GetFistMode() == 1)
										{
											ACS_refresh_guard_attack_cooldown();
																		
											geraltRandomAardCounter();
											
											thePlayer.DrainStamina(ESAT_LightAttack);
										}
									}
								}
													
								GuardAttackCallTime = theGame.GetEngineTimeAsSeconds();
							}
							else if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
							{		
								if( GuardAttackDoubleTap )
								{
									if (ACS_can_perform_guard_attack()
									&& ACS_SummonedShades_Enabled()
									)
									{
										ACS_refresh_guard_attack_cooldown();

										if (!thePlayer.HasTag('summoned_shades'))
										{
											thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_yrden_ground', 'PLAYER_SLOT', settings);	
																	
											if(thePlayer.IsInCombat()){ACS_Spawn_Shades();}
															
											thePlayer.AddTag('summoned_shades');
										}
									}
								}
								else
								{
									if (thePlayer.IsHardLockEnabled())
									{
										if (ACS_can_perform_beam_attack()
										&& ACS_BeamAttack_Enabled()
										)
										{
											ACS_refresh_beam_attack_cooldown();
																
											if(thePlayer.IsInCombat()){ACS_Beam_Attack();}
										}
									}	
								}
												
								GuardAttackCallTime = theGame.GetEngineTimeAsSeconds();
							}
							else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5 )
							{	
								if (ACS_can_perform_guard_attack())
								{
									ACS_refresh_guard_attack_cooldown();

									geraltRandomPunch();
									
									thePlayer.DrainStamina(ESAT_LightAttack);
								}	
							}
							else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5 )
							{		
								if (ACS_can_perform_guard_attack())
								{
									ACS_refresh_guard_attack_cooldown();

									geraltRandomPush();
									
									thePlayer.DrainStamina(ESAT_LightAttack);
								}	
							}
							else
							{
								if( GuardAttackDoubleTap )
								{
									if (ACS_can_perform_guard_doubletap_attack() && thePlayer.IsInCombat())
									{
										ACS_refresh_guard_doubletap_attack_cooldown();
														
										if(thePlayer.HasTag('axii_sword_equipped')
										&& ACS_ShieldEntity_Enabled()
										)
										{
											if(thePlayer.IsInCombat()){vACS_Shield_Summon.Axii_Shield_Summon();}
											vACS_Shield_Summon.Axii_Shield_Entity();
										}
										else if (thePlayer.HasTag('quen_sword_equipped')
										&& ACS_QuenMonsterSummon_Enabled()
										)
										{
											thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_yrden_ground', 'PLAYER_SLOT', settings);

											vACS_Shield_Summon.Quen_Monster_Summon();
										}
										else if (thePlayer.HasTag('yrden_sword_equipped')
										&& ACS_YrdenSkeleSummon_Enabled()
										)
										{
											thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_yrden_ground', 'PLAYER_SLOT', settings);

											vACS_Shield_Summon.Yrden_Skele_Summon();
										}
										else if (thePlayer.HasTag('aard_sword_equipped')
										&& ACS_AardPull_Enabled()
										)
										{
											thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_yrden_ground', 'PLAYER_SLOT', settings);

											vACS_Shield_Summon.Aard_Pull();

											AddTimer('ACS_bruxa_camo_npc_reaction', 0.5, true);
										}
										else if (thePlayer.HasTag('vampire_claws_equipped')
										&& ACS_BruxaCamoDecoy_Enabled() 
										&& !thePlayer.HasBuff(EET_BlackBlood)
										)
										{
											vACS_Shield_Summon.BruxaCamoDecoy();

											AddTimer('ACS_npc_fear_reaction', 0.875, true);
										}
										else if (thePlayer.HasTag('quen_secondary_sword_equipped')
										|| thePlayer.HasTag('axii_secondary_sword_equipped')
										)
										{
											//thePlayer.AddTag('acs_crossbow_active');
											thePlayer.AddTag('acs_bow_active');
										}
										else if (thePlayer.HasTag('aard_secondary_sword_equipped')
										|| thePlayer.HasTag('yrden_secondary_sword_equipped')
										|| thePlayer.HasTag('igni_secondary_sword_equipped')
										)
										{
											thePlayer.AddTag('acs_bow_active');
										}
									}
								}
								else
								{
									if(thePlayer.HasTag('axii_sword_equipped'))
									{
										action_interrupt();
										if(thePlayer.IsInCombat()){vACS_Shield_Summon.Axii_Shield_Summon();}
									}
								}
												
								GuardAttackCallTime = theGame.GetEngineTimeAsSeconds();
							}
						}
					}
					else if (ACS_GetWeaponMode() == 3)
					{
						if ( ACS_StaminaBlockAction_Enabled() 
						&& StaminaCheck()
						)
						{
							thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
						}
						else
						{
							if (theInput.GetActionValue('GI_AxisLeftY') > 0.5 )
							{
								if( GuardAttackDoubleTap )
								{
									if 
									( 
										(thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax(BCS_Focus) * 0.9)
										&& ACS_can_perform_guard_doubletap_attack()
										&& ACS_SwordArray_Enabled() 
									)
									{
										ACS_refresh_guard_doubletap_attack_cooldown();
														
										ACS_Sword_Array();
									}
									else
									{
										RandomKickActual();
									}
								}
								else
								{	
									if ( !thePlayer.IsWeaponHeld( 'fist' ) )
									{
										if ( thePlayer.IsWeaponHeld( 'silversword' ) )
										{
											if ( ACS_GetItem_Eredin_Silver() || ACS_GetItem_Greg_Silver() )
											{
												AxiiCounterActual();
											}
											else if ( ACS_GetItem_Claws_Silver() || ACS_GetItem_Axe_Silver() )
											{
												AardCounterActual();
											}
											else if ( ACS_GetItem_Olgierd_Silver() || ACS_GetItem_Spear_Silver() )
											{
												QuenCounterActual();
											}
											else if ( ACS_GetItem_Imlerith_Silver() || ACS_GetItem_Hammer_Silver() )
											{
												YrdenCounterActual();
											}
											else if (ACS_GetItem_Katana_Silver() )
											{
												AxeCounter();
											}
											else
											{
												IgniCounterActual();
											}
										}
										else if ( thePlayer.IsWeaponHeld( 'steelsword' ) )
										{
											if ( ACS_GetItem_Eredin_Steel() || ACS_GetItem_Greg_Steel() )
											{
												AxiiCounterActual();
											}
											else if ( ACS_GetItem_Claws_Steel() || ACS_GetItem_Axe_Steel() )
											{
												AardCounterActual();
											}
											else if ( ACS_GetItem_Olgierd_Steel() || ACS_GetItem_Spear_Steel() )
											{
												QuenCounterActual();
											}
											else if ( ACS_GetItem_Imlerith_Steel() || ACS_GetItem_Hammer_Steel() )
											{
												YrdenCounterActual();
											}
											else if (ACS_GetItem_Katana_Steel() )
											{
												AxeCounter();
											}
											else
											{
												IgniCounterActual();
											}
										}
									}
									else
									{	
										if (ACS_can_perform_guard_attack()
										&& (ACS_GetItem_VampClaw() || ACS_GetItem_VampClaw_Shades())
										)
										{
											ACS_refresh_guard_attack_cooldown();
																		
											geraltRandomAardCounter();
											
											thePlayer.DrainStamina(ESAT_LightAttack);
										}
									}
								}
													
								GuardAttackCallTime = theGame.GetEngineTimeAsSeconds();
							}
							else if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
							{		
								if( GuardAttackDoubleTap )
								{
									if (ACS_can_perform_guard_attack()
									&& ACS_SummonedShades_Enabled()
									)
									{
										ACS_refresh_guard_attack_cooldown();

										if (!thePlayer.HasTag('summoned_shades'))
										{
											thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_yrden_ground', 'PLAYER_SLOT', settings);	
																	
											if(thePlayer.IsInCombat()){ACS_Spawn_Shades();}
															
											thePlayer.AddTag('summoned_shades');
										}
									}
								}
								else
								{
									if (thePlayer.IsHardLockEnabled())
									{
										if (ACS_can_perform_beam_attack()
										&& ACS_BeamAttack_Enabled()
										)
										{
											ACS_refresh_beam_attack_cooldown();
																
											if(thePlayer.IsInCombat()){ACS_Beam_Attack();}
										}
									}	
								}
												
								GuardAttackCallTime = theGame.GetEngineTimeAsSeconds();
							}
							else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5 )
							{	
								if (ACS_can_perform_guard_attack())
								{
									ACS_refresh_guard_attack_cooldown();

									geraltRandomPunch();
									
									thePlayer.DrainStamina(ESAT_LightAttack);
								}	
							}
							else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5 )
							{		
								if (ACS_can_perform_guard_attack())
								{
									ACS_refresh_guard_attack_cooldown();

									geraltRandomPush();
									
									thePlayer.DrainStamina(ESAT_LightAttack);
								}	
							}
							else
							{
								if( GuardAttackDoubleTap )
								{
									if (ACS_can_perform_guard_doubletap_attack() && thePlayer.IsInCombat())
									{
										ACS_refresh_guard_doubletap_attack_cooldown();
														
										if(thePlayer.HasTag('axii_sword_equipped')
										&& ACS_ShieldEntity_Enabled()
										)
										{
											if(thePlayer.IsInCombat()){vACS_Shield_Summon.Axii_Shield_Summon();}
											vACS_Shield_Summon.Axii_Shield_Entity();
										}
										else if (thePlayer.HasTag('quen_sword_equipped')
										&& ACS_QuenMonsterSummon_Enabled()
										)
										{
											thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_yrden_ground', 'PLAYER_SLOT', settings);

											vACS_Shield_Summon.Quen_Monster_Summon();
										}
										else if (thePlayer.HasTag('yrden_sword_equipped')
										&& ACS_YrdenSkeleSummon_Enabled()
										)
										{
											thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_yrden_ground', 'PLAYER_SLOT', settings);

											vACS_Shield_Summon.Yrden_Skele_Summon();
										}
										else if (thePlayer.HasTag('aard_sword_equipped')
										&& ACS_AardPull_Enabled()
										)
										{
											thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_yrden_ground', 'PLAYER_SLOT', settings);

											vACS_Shield_Summon.Aard_Pull();

											AddTimer('ACS_bruxa_camo_npc_reaction', 0.5, true);
										}
										else if (thePlayer.HasTag('vampire_claws_equipped')
										&& ACS_BruxaCamoDecoy_Enabled() 
										&& !thePlayer.HasBuff(EET_BlackBlood)
										)
										{
											vACS_Shield_Summon.BruxaCamoDecoy();

											AddTimer('ACS_npc_fear_reaction', 0.875, true);
										}
										else if (thePlayer.HasTag('quen_secondary_sword_equipped')
										|| thePlayer.HasTag('axii_secondary_sword_equipped')
										)
										{
											//thePlayer.AddTag('acs_crossbow_active');
											thePlayer.AddTag('acs_bow_active');
										}
										else if (thePlayer.HasTag('aard_secondary_sword_equipped')
										|| thePlayer.HasTag('yrden_secondary_sword_equipped')
										|| thePlayer.HasTag('igni_secondary_sword_equipped')
										)
										{
											thePlayer.AddTag('acs_bow_active');
										}
									}
								}
								else
								{
									if(thePlayer.HasTag('axii_sword_equipped'))
									{
										action_interrupt();
										if(thePlayer.IsInCombat()){vACS_Shield_Summon.Axii_Shield_Summon();}
									}
									else if (thePlayer.HasTag('quen_secondary_sword_equipped')
									|| thePlayer.HasTag('axii_secondary_sword_equipped')
									)
									{
										//thePlayer.AddTag('acs_crossbow_active');
										thePlayer.AddTag('acs_bow_active');
									}
									else if (thePlayer.HasTag('aard_secondary_sword_equipped')
									|| thePlayer.HasTag('yrden_secondary_sword_equipped')
									|| thePlayer.HasTag('igni_secondary_sword_equipped')
									)
									{
										thePlayer.AddTag('acs_bow_active');
									}
								}
												
								GuardAttackCallTime = theGame.GetEngineTimeAsSeconds();
							}
						}
					}
				}
				else
				{
					if ( ACS_BeamAttack_Enabled() )
					{
						if ( ACS_StaminaBlockAction_Enabled() 
						&& StaminaCheck()
						)
						{ 
							thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
						}
						else
						{
							if (ACS_can_perform_beam_attack())
							{
								ACS_refresh_beam_attack_cooldown();
																
								ACS_Beam_Attack();
							}
						}
					}
				}
			}
		}

		//thePlayer.SetBehaviorVariable( 'playerToTargetDistForOverlay', VecDistance( thePlayer.GetWorldPosition(), actor.GetNearestPointInPersonalSpace( thePlayer.GetWorldPosition() ) ) );

		DeactivateThings();
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	function LightAttackSwitch()
	{
		DeactivateThings();

		ACS_ThingsThatShouldBeRemoved();

		ACS_ExplorationDelayHack();

		ACS_Finisher_PreAction();

		if ( thePlayer.IsActionAllowed(EIAB_LightAttacks) )
		{
			if ( CiriCheck() )
			{
				if ( HitAnimCheck() 
				&& FinisherCheck()
				&& WraithModeCheck()
				&& BruxaBiteCheck() 
				&& thePlayer.IsAnyWeaponHeld()
				&& !thePlayer.IsWeaponHeld( 'fist' )
				)
				{
					if (ACS_GetWeaponMode() == 0 )
					{
						ACSGetEquippedSword().StopAllEffects();

						if ( thePlayer.GetEquippedSign() == ST_Quen )
						{	
							if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
							{
								ACS_PrimaryWeaponSwitch();

								thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');	
								thePlayer.AddTag('igni_sword_equipped_TAG');	

								ACS_Setup_Combat_Action_Light();
							}
							else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
							{
								ArmigerModeOlgierdLightAttack();
							}
							else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
							{
								ArmigerModeEredinLightAttack();
							}
							else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
							{
								ArmigerModeClawLightAttack();
							}
							else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
							{
								ArmigerModeImlerithLightAttack();
							}
						}
						else if ( thePlayer.GetEquippedSign() == ST_Aard )
						{
							if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
							{
								ACS_PrimaryWeaponSwitch();

								thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');	
								thePlayer.AddTag('igni_sword_equipped_TAG');
														
								ACS_Setup_Combat_Action_Light();
							}
							else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
							{
								ArmigerModeOlgierdLightAttack();
							}
							else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
							{
								ArmigerModeEredinLightAttack();
							}
							else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
							{
								ArmigerModeClawLightAttack();
							}
							else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
							{
								ArmigerModeImlerithLightAttack();
							}
						}
						else if ( thePlayer.GetEquippedSign() == ST_Axii )
						{
							if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
							{
								ACS_PrimaryWeaponSwitch();

								thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');	
								thePlayer.AddTag('igni_sword_equipped_TAG');
														
								ACS_Setup_Combat_Action_Light();
							}
							else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
							{
								ArmigerModeOlgierdLightAttack();
							}
							else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
							{
								ArmigerModeEredinLightAttack();
							}
							else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
							{
								ArmigerModeClawLightAttack();
							}
							else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
							{
								ArmigerModeImlerithLightAttack();
							}
						}
						else if ( thePlayer.GetEquippedSign() == ST_Yrden )
						{
							if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
							{
								ACS_PrimaryWeaponSwitch();

								thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');	
								thePlayer.AddTag('igni_sword_equipped_TAG');
														
								ACS_Setup_Combat_Action_Light();
							}
							else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
							{
								ArmigerModeOlgierdLightAttack();
							}
							else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
							{
								ArmigerModeEredinLightAttack();
							}
							else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
							{
								ArmigerModeClawLightAttack();
							}
							else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
							{
								ArmigerModeImlerithLightAttack();
							}
						}
						else if ( thePlayer.GetEquippedSign() == ST_Igni )
						{
							if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
							{
								ACS_PrimaryWeaponSwitch();

								thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');	
								thePlayer.AddTag('igni_sword_equipped_TAG');
														
								ACS_Setup_Combat_Action_Light();
							}
							else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
							{
								ArmigerModeOlgierdLightAttack();
							}
							else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
							{
								ArmigerModeEredinLightAttack();
							}
							else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
							{
								ArmigerModeClawLightAttack();
							}
							else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
							{
								ArmigerModeImlerithLightAttack();
							}
						}
					}
					else if (ACS_GetWeaponMode() == 1)
					{
						ACSGetEquippedSword().StopAllEffects();

						if (thePlayer.IsWeaponHeld('silversword'))
						{
							if ( ACS_GetFocusModeSilverWeapon() == 0 )
							{
								ACS_PrimaryWeaponSwitch();

								thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');	
								thePlayer.AddTag('igni_sword_equipped_TAG');
															
								ACS_Setup_Combat_Action_Light();
							}
							else if ( ACS_GetFocusModeSilverWeapon() == 1 )
							{	
								FocusModeOlgierdLightAttack();
							}
							else if ( ACS_GetFocusModeSilverWeapon() == 2 )
							{
								FocusModeSpearLightAttack();
							}
							else if ( ACS_GetFocusModeSilverWeapon() == 3 )
							{
								FocusModeEredinShieldLightAttack();
							}
							else if ( ACS_GetFocusModeSilverWeapon() == 4 )
							{
								FocusModeGregLightAttack();
							}
							else if ( ACS_GetFocusModeSilverWeapon() == 5 )
							{
								FocusModeImlerithLightAttack();
							}
							else if ( ACS_GetFocusModeSilverWeapon() == 6 )
							{
								FocusModeGiantLightAttack();
							}
							else if ( ACS_GetFocusModeSilverWeapon() == 7 )
							{
								FocusModeClawLightAttack();
							}
							else if ( ACS_GetFocusModeSilverWeapon() == 8 )
							{
								FocusModeAxeLightAttack();
							}
						}
						else if (thePlayer.IsWeaponHeld('steelsword'))
						{
							if ( ACS_GetFocusModeSteelWeapon() == 0 )
							{
								ACS_PrimaryWeaponSwitch();

								thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');	
								thePlayer.AddTag('igni_sword_equipped_TAG');
															
								ACS_Setup_Combat_Action_Light();
							}
							else if ( ACS_GetFocusModeSteelWeapon() == 1 )
							{	
								FocusModeOlgierdLightAttack();
							}
							else if ( ACS_GetFocusModeSteelWeapon() == 2 )
							{
								FocusModeSpearLightAttack();
							}
							else if ( ACS_GetFocusModeSteelWeapon() == 3 )
							{
								FocusModeEredinShieldLightAttack();
							}
							else if ( ACS_GetFocusModeSteelWeapon() == 4 )
							{
								FocusModeGregLightAttack();
							}
							else if ( ACS_GetFocusModeSteelWeapon() == 5 )
							{
								FocusModeImlerithLightAttack();
							}
							else if ( ACS_GetFocusModeSteelWeapon() == 6 )
							{
								FocusModeGiantLightAttack();
							}
							else if ( ACS_GetFocusModeSteelWeapon() == 7 )
							{
								FocusModeClawLightAttack();
							}
							else if ( ACS_GetFocusModeSteelWeapon() == 8 )
							{
								FocusModeAxeLightAttack();
							}
						}
					}
					else if (ACS_GetWeaponMode() == 2)
					{
						ACSGetEquippedSword().StopAllEffects();

						if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
						{
							if ( ACS_GetHybridModeForwardLightAttack() == 0 )
							{
								if (!thePlayer.HasTag('HybridDefaultWeaponTicket')){thePlayer.AddTag('HybridDefaultWeaponTicket');}

								ACS_PrimaryWeaponSwitch();

								thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');	
								thePlayer.AddTag('igni_sword_equipped_TAG');
															
								ACS_Setup_Combat_Action_Light();
							}
							else if ( ACS_GetHybridModeForwardLightAttack() == 1 )
							{
								if (!thePlayer.HasTag('HybridOlgierdWeaponTicket')){thePlayer.AddTag('HybridOlgierdWeaponTicket');}

								HybridModeOlgierdForwardLightAttack();
							}
							else if ( ACS_GetHybridModeForwardLightAttack() == 2 )
							{
								if (!thePlayer.HasTag('HybridEredinWeaponTicket')){thePlayer.AddTag('HybridEredinWeaponTicket');}

								HybridModeEredinShieldForwardLightAttack();
							}
							else if ( ACS_GetHybridModeForwardLightAttack() == 3 )
							{
								if (!thePlayer.HasTag('HybridClawWeaponTicket')){thePlayer.AddTag('HybridClawWeaponTicket');}

								HybridModeClawForwardLightAttack();
							}
							else if ( ACS_GetHybridModeForwardLightAttack() == 4 )
							{
								if (!thePlayer.HasTag('HybridImlerithWeaponTicket')){thePlayer.AddTag('HybridImlerithWeaponTicket');}

								HybridModeImlerithForwardLightAttack();
							}
							else if ( ACS_GetHybridModeForwardLightAttack() == 5 )
							{
								if (!thePlayer.HasTag('HybridSpearWeaponTicket')){thePlayer.AddTag('HybridSpearWeaponTicket');}

								HybridModeSpearForwardLightAttack();
							}
							else if ( ACS_GetHybridModeForwardLightAttack() == 6 )
							{
								if (!thePlayer.HasTag('HybridGregWeaponTicket')){thePlayer.AddTag('HybridGregWeaponTicket');}

								HybridModeGregForwardLightAttack();
							}
							else if ( ACS_GetHybridModeForwardLightAttack() == 7 )
							{
								if (!thePlayer.HasTag('HybridAxeWeaponTicket')){thePlayer.AddTag('HybridAxeWeaponTicket');}

								HybridModeAxeForwardLightAttack();
							}
							else if ( ACS_GetHybridModeForwardLightAttack() == 8 )
							{
								if (!thePlayer.HasTag('HybridGiantWeaponTicket')){thePlayer.AddTag('HybridGiantWeaponTicket');}

								HybridModeGiantForwardLightAttack();
							}
						}
						else
						{
							if ( ACS_GetHybridModeLightAttack() == 0 )
							{
								if (!thePlayer.HasTag('HybridDefaultWeaponTicket')){thePlayer.AddTag('HybridDefaultWeaponTicket');}

								ACS_PrimaryWeaponSwitch();

								thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');	
								thePlayer.AddTag('igni_sword_equipped_TAG');
															
								ACS_Setup_Combat_Action_Light();
							}
							else if ( ACS_GetHybridModeLightAttack() == 1 )
							{
								if (!thePlayer.HasTag('HybridOlgierdWeaponTicket')){thePlayer.AddTag('HybridOlgierdWeaponTicket');}

								HybridModeOlgierdLightAttack();
							}
							else if ( ACS_GetHybridModeLightAttack() == 2 )
							{
								if (!thePlayer.HasTag('HybridEredinWeaponTicket')){thePlayer.AddTag('HybridEredinWeaponTicket');}

								HybridModeEredinShieldLightAttack();
							}
							else if ( ACS_GetHybridModeLightAttack() == 3 )
							{
								if (!thePlayer.HasTag('HybridClawWeaponTicket')){thePlayer.AddTag('HybridClawWeaponTicket');}

								HybridModeClawLightAttack();
							}
							else if ( ACS_GetHybridModeLightAttack() == 4 )
							{
								if (!thePlayer.HasTag('HybridImlerithWeaponTicket')){thePlayer.AddTag('HybridImlerithWeaponTicket');}

								HybridModeImlerithLightAttack();
							}
							else if ( ACS_GetHybridModeLightAttack() == 5 )
							{
								if (!thePlayer.HasTag('HybridSpearWeaponTicket')){thePlayer.AddTag('HybridSpearWeaponTicket');}

								HybridModeSpearLightAttack();
							}
							else if ( ACS_GetHybridModeLightAttack() == 6 )
							{
								if (!thePlayer.HasTag('HybridGregWeaponTicket')){thePlayer.AddTag('HybridGregWeaponTicket');}

								HybridModeGregLightAttack();
							}
							else if ( ACS_GetHybridModeLightAttack() == 7 )
							{
								if (!thePlayer.HasTag('HybridAxeWeaponTicket')){thePlayer.AddTag('HybridAxeWeaponTicket');}

								HybridModeAxeLightAttack();
							}
							else if ( ACS_GetHybridModeLightAttack() == 8 )
							{
								if (!thePlayer.HasTag('HybridGiantWeaponTicket')){thePlayer.AddTag('HybridGiantWeaponTicket');}

								HybridModeGiantLightAttack();
							}
						}
					}
					else if ( ACS_GetWeaponMode() == 3 )
					{
						if (thePlayer.IsWeaponHeld('silversword'))
						{
							if ( ACS_GetItem_Olgierd_Silver() )
							{	
								FocusModeOlgierdLightAttack();
							}
							else if ( ACS_GetItem_Claws_Silver() )
							{
								FocusModeClawLightAttack();
							}
							else if ( ACS_GetItem_Eredin_Silver() )
							{
								FocusModeEredinShieldLightAttack();
							}
							else if ( ACS_GetItem_Imlerith_Silver() )
							{
								FocusModeImlerithLightAttack();
							}
							else if ( ACS_GetItem_Spear_Silver() )
							{
								FocusModeSpearLightAttack();
							}
							else if ( ACS_GetItem_Greg_Silver() )
							{
								FocusModeGregLightAttack();
							}
							else if ( ACS_GetItem_Hammer_Silver() )
							{
								FocusModeGiantLightAttack();
							}
							else if ( ACS_GetItem_Axe_Silver() )
							{
								FocusModeAxeLightAttack();
							}
							else if ( ACS_GetItem_Katana_Silver() )
							{
								FocusModeOlgierdLightAttack();
							}
							else
							{	
								ACS_DefaultSwitch();		

								thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');	
								thePlayer.AddTag('igni_sword_equipped_TAG');

								ACS_Setup_Combat_Action_Light();
							}
						}
						else if (thePlayer.IsWeaponHeld('steelsword'))
						{
							if ( ACS_GetItem_Olgierd_Steel() )
							{	
								FocusModeOlgierdLightAttack();
							}
							else if ( ACS_GetItem_Claws_Steel() )
							{
								FocusModeClawLightAttack();
							}
							else if ( ACS_GetItem_Eredin_Steel() )
							{
								FocusModeEredinShieldLightAttack();
							}
							else if ( ACS_GetItem_Imlerith_Steel() )
							{
								FocusModeImlerithLightAttack();
							}
							else if ( ACS_GetItem_Spear_Steel() )
							{
								FocusModeSpearLightAttack();
							}
							else if ( ACS_GetItem_Greg_Steel() )
							{
								FocusModeGregLightAttack();
							}
							else if ( ACS_GetItem_Hammer_Steel() )
							{
								FocusModeGiantLightAttack();
							}
							else if ( ACS_GetItem_Axe_Steel() )
							{
								FocusModeAxeLightAttack();
							}
							else if ( ACS_GetItem_Katana_Steel() )
							{
								FocusModeOlgierdLightAttack();
							}
							else
							{	
								ACS_DefaultSwitch();		

								thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');	
								thePlayer.AddTag('igni_sword_equipped_TAG');

								ACS_Setup_Combat_Action_Light();
							}
						}		
					}
				}
			}
			else
			{
				ACS_Setup_Combat_Action_Light();
			}
		}
		else
		{
			ACS_Setup_Combat_Action_Light();
		}

		//thePlayer.SetBehaviorVariable( 'playerToTargetDistForOverlay', VecDistance( thePlayer.GetWorldPosition(), actor.GetNearestPointInPersonalSpace( thePlayer.GetWorldPosition() ) ) );

		DeactivateThings();
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	function HeavyAttackSwitch()
	{
		DeactivateThings();
		/*
		if (!thePlayer.HasTag('vampire_claws_equipped') || !thePlayer.IsWeaponHeld( 'fist' ) ) 
		{
			RemoveTimer('ACS_bruxa_tackle'); 
		}
		*/
		if ( !thePlayer.IsWeaponHeld( 'fist' ) ) 
		{
			RemoveTimer('ACS_bruxa_tackle'); 
			RemoveTimer('ACS_portable_aard'); 
		}

		ACS_ThingsThatShouldBeRemoved_NoBruxaTackleOrPortableAard();

		ACS_ExplorationDelayHack();

		ACS_Finisher_PreAction();

		if ( thePlayer.IsActionAllowed(EIAB_HeavyAttacks) )
		{
			if ( CiriCheck() )
			{
				if ( HitAnimCheck() 
				&& FinisherCheck()
				&& WraithModeCheck() 
				&& BruxaBiteCheck()
				&& thePlayer.IsAnyWeaponHeld()
				&& !thePlayer.IsWeaponHeld( 'fist' ) 
				)
				{
					if (ACS_GetWeaponMode() == 0)
					{
						ACSGetEquippedSword().StopAllEffects();

						if ( thePlayer.GetEquippedSign() == ST_Yrden )
						{
							if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
							{
								ArmigerModeGeraltHeavyAttack();
							}
							else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
							{
								ArmigerModeSpearHeavyAttack();
							}
							else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
							{
								ArmigerModeGregHeavyAttack();
							}
							else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
							{
								ArmigerModeAxeHeavyAttack();
							}
							else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
							{
								ArmigerModeHammerHeavyAttack();
							}
						}
						else if ( thePlayer.GetEquippedSign() == ST_Aard )
						{
							if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
							{
								ArmigerModeGeraltHeavyAttack();
							}
							else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
							{
								ArmigerModeSpearHeavyAttack();
							}
							else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
							{
								ArmigerModeGregHeavyAttack();
							}
							else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
							{
								ArmigerModeAxeHeavyAttack();
							}
							else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
							{
								ArmigerModeHammerHeavyAttack();
							}
						}
						else if ( thePlayer.GetEquippedSign() == ST_Quen )
						{	
							if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
							{
								ArmigerModeGeraltHeavyAttack();
							}
							else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
							{
								ArmigerModeSpearHeavyAttack();
							}
							else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
							{
								ArmigerModeGregHeavyAttack();
							}
							else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
							{
								ArmigerModeAxeHeavyAttack();
							}
							else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
							{
								ArmigerModeHammerHeavyAttack();
							}
						}
						else if ( thePlayer.GetEquippedSign() == ST_Axii )
						{	
							if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
							{
								ArmigerModeGeraltHeavyAttack();
							}
							else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
							{
								ArmigerModeSpearHeavyAttack();
							}
							else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
							{
								ArmigerModeGregHeavyAttack();
							}
							else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
							{
								ArmigerModeAxeHeavyAttack();
							}
							else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
							{
								ArmigerModeHammerHeavyAttack();
							}
						}
						else if ( thePlayer.GetEquippedSign() == ST_Igni )
						{	
							if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
							{
								ArmigerModeGeraltHeavyAttack();
							}
							else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
							{
								ArmigerModeSpearHeavyAttack();
							}
							else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
							{
								ArmigerModeGregHeavyAttack();
							}
							else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
							{
								ArmigerModeAxeHeavyAttack();
							}
							else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
							{
								ArmigerModeHammerHeavyAttack();
							}
						}
					}
					else if (ACS_GetWeaponMode() == 1)
					{
						ACSGetEquippedSword().StopAllEffects();

						if (thePlayer.IsWeaponHeld('silversword'))
						{
							if ( ACS_GetFocusModeSilverWeapon() == 0 )
							{
								ACS_SecondaryWeaponSwitch();

								thePlayer.RemoveTag('igni_sword_equipped_TAG');	
								thePlayer.AddTag('igni_secondary_sword_equipped_TAG');
																
								ACS_Setup_Combat_Action_Heavy();
							}
							else if ( ACS_GetFocusModeSilverWeapon() == 1 )
							{	
								FocusModeOlgierdHeavyAttack();
							}
							else if ( ACS_GetFocusModeSilverWeapon() == 2 )
							{	
								FocusModeSpearHeavyAttack();
							}
							else if ( ACS_GetFocusModeSilverWeapon() == 3 )
							{	
								FocusModeEredinShieldHeavyAttack();
							}
							else if ( ACS_GetFocusModeSilverWeapon() == 4 )
							{	
								FocusModeGregHeavyAttack();
							}
							else if ( ACS_GetFocusModeSilverWeapon() == 5 )
							{	
								FocusModeImlerithHeavyAttack();
							}
							else if ( ACS_GetFocusModeSilverWeapon() == 6 )
							{
								FocusModeGiantHeavyAttack();
							}
							else if ( ACS_GetFocusModeSilverWeapon() == 7 )
							{	
								FocusModeClawHeavyAttack();
							}
							else if ( ACS_GetFocusModeSilverWeapon() == 8 )
							{
								FocusModeAxeHeavyAttack();
							}
						}
						else if (thePlayer.IsWeaponHeld('steelsword'))
						{
							if ( ACS_GetFocusModeSteelWeapon() == 0 )
							{
								ACS_SecondaryWeaponSwitch();

								thePlayer.RemoveTag('igni_sword_equipped_TAG');	
								thePlayer.AddTag('igni_secondary_sword_equipped_TAG');
																
								ACS_Setup_Combat_Action_Heavy();
							}
							else if ( ACS_GetFocusModeSteelWeapon() == 1 )
							{	
								FocusModeOlgierdHeavyAttack();
							}
							else if ( ACS_GetFocusModeSteelWeapon() == 2 )
							{	
								FocusModeSpearHeavyAttack();
							}
							else if ( ACS_GetFocusModeSteelWeapon() == 3 )
							{	
								FocusModeEredinShieldHeavyAttack();
							}
							else if ( ACS_GetFocusModeSteelWeapon() == 4 )
							{	
								FocusModeGregHeavyAttack();
							}
							else if ( ACS_GetFocusModeSteelWeapon() == 5 )
							{	
								FocusModeImlerithHeavyAttack();
							}
							else if ( ACS_GetFocusModeSteelWeapon() == 6 )
							{
								FocusModeGiantHeavyAttack();
							}
							else if ( ACS_GetFocusModeSteelWeapon() == 7 )
							{	
								FocusModeClawHeavyAttack();
							}
							else if ( ACS_GetFocusModeSteelWeapon() == 8 )
							{
								FocusModeAxeHeavyAttack();
							}
						}
					}
					else if (ACS_GetWeaponMode() == 2)
					{
						ACSGetEquippedSword().StopAllEffects();

						if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
						{
							if ( ACS_GetHybridModeForwardHeavyAttack() == 0 )
							{
								if (!thePlayer.HasTag('HybridDefaultSecondaryWeaponTicket')){thePlayer.AddTag('HybridDefaultSecondaryWeaponTicket');}

								ACS_SecondaryWeaponSwitch();

								thePlayer.RemoveTag('igni_sword_equipped_TAG');	
								thePlayer.AddTag('igni_secondary_sword_equipped_TAG');
																
								ACS_Setup_Combat_Action_Heavy();
							}
							else if ( ACS_GetHybridModeForwardHeavyAttack() == 1 )
							{
								if (!thePlayer.HasTag('HybridOlgierdWeaponTicket')){thePlayer.AddTag('HybridOlgierdWeaponTicket');}

								HybridModeOlgierdForwardHeavyAttack();
							}
							else if ( ACS_GetHybridModeForwardHeavyAttack() == 2 )
							{
								if (!thePlayer.HasTag('HybridEredinWeaponTicket')){thePlayer.AddTag('HybridEredinWeaponTicket');}

								HybridModeEredinShieldForwardHeavyAttack();
							}
							else if ( ACS_GetHybridModeForwardHeavyAttack() == 3 )
							{
								if (!thePlayer.HasTag('HybridClawWeaponTicket')){thePlayer.AddTag('HybridClawWeaponTicket');}

								HybridModeClawForwardHeavyAttack();
							}
							else if ( ACS_GetHybridModeForwardHeavyAttack() == 4 )
							{
								if (!thePlayer.HasTag('HybridImlerithWeaponTicket')){thePlayer.AddTag('HybridImlerithWeaponTicket');}

								HybridModeImlerithForwardHeavyAttack();
							}
							else if ( ACS_GetHybridModeForwardHeavyAttack() == 5 )
							{
								if (!thePlayer.HasTag('HybridSpearWeaponTicket')){thePlayer.AddTag('HybridSpearWeaponTicket');}

								HybridModeSpearForwardHeavyAttack();
							}
							else if ( ACS_GetHybridModeForwardHeavyAttack() == 6 )
							{
								if (!thePlayer.HasTag('HybridGregWeaponTicket')){thePlayer.AddTag('HybridGregWeaponTicket');}

								HybridModeGregForwardHeavyAttack();
							}
							else if ( ACS_GetHybridModeForwardHeavyAttack() == 7 )
							{
								if (!thePlayer.HasTag('HybridAxeWeaponTicket')){thePlayer.AddTag('HybridAxeWeaponTicket');}

								HybridModeAxeForwardHeavyAttack();
							}
							else if ( ACS_GetHybridModeForwardHeavyAttack() == 8 )
							{
								if (!thePlayer.HasTag('HybridGiantWeaponTicket')){thePlayer.AddTag('HybridGiantWeaponTicket');}

								HybridModeGiantForwardHeavyAttack();
							}
						}
						else
						{
							if ( ACS_GetHybridModeHeavyAttack() == 0 )
							{
								if (!thePlayer.HasTag('HybridDefaultSecondaryWeaponTicket')){thePlayer.AddTag('HybridDefaultSecondaryWeaponTicket');}

								ACS_SecondaryWeaponSwitch();

								thePlayer.RemoveTag('igni_sword_equipped_TAG');	
								thePlayer.AddTag('igni_secondary_sword_equipped_TAG');
																
								ACS_Setup_Combat_Action_Heavy();
							}
							else if ( ACS_GetHybridModeHeavyAttack() == 1 )
							{
								if (!thePlayer.HasTag('HybridOlgierdWeaponTicket')){thePlayer.AddTag('HybridOlgierdWeaponTicket');}

								HybridModeOlgierdHeavyAttack();
							}
							else if ( ACS_GetHybridModeHeavyAttack() == 2 )
							{
								if (!thePlayer.HasTag('HybridEredinWeaponTicket')){thePlayer.AddTag('HybridEredinWeaponTicket');}

								HybridModeEredinShieldHeavyAttack();
							}
							else if ( ACS_GetHybridModeHeavyAttack() == 3 )
							{
								if (!thePlayer.HasTag('HybridClawWeaponTicket')){thePlayer.AddTag('HybridClawWeaponTicket');}

								HybridModeClawHeavyAttack();
							}
							else if ( ACS_GetHybridModeHeavyAttack() == 4 )
							{
								if (!thePlayer.HasTag('HybridImlerithWeaponTicket')){thePlayer.AddTag('HybridImlerithWeaponTicket');}

								HybridModeImlerithHeavyAttack();
							}
							else if ( ACS_GetHybridModeHeavyAttack() == 5 )
							{
								if (!thePlayer.HasTag('HybridSpearWeaponTicket')){thePlayer.AddTag('HybridSpearWeaponTicket');}

								HybridModeSpearHeavyAttack();
							}
							else if ( ACS_GetHybridModeHeavyAttack() == 6 )
							{
								if (!thePlayer.HasTag('HybridGregWeaponTicket')){thePlayer.AddTag('HybridGregWeaponTicket');}

								HybridModeGregHeavyAttack();
							}
							else if ( ACS_GetHybridModeHeavyAttack() == 7 )
							{
								if (!thePlayer.HasTag('HybridAxeWeaponTicket')){thePlayer.AddTag('HybridAxeWeaponTicket');}

								HybridModeAxeHeavyAttack();
							}
							else if ( ACS_GetHybridModeHeavyAttack() == 8 )
							{
								if (!thePlayer.HasTag('HybridGiantWeaponTicket')){thePlayer.AddTag('HybridGiantWeaponTicket');}

								HybridModeGiantHeavyAttack();
							}
						}
					}
					else if ( ACS_GetWeaponMode() == 3 )
					{
						if (thePlayer.IsWeaponHeld('silversword'))
						{
							if ( ACS_GetItem_Hammer_Silver() )
							{
								FocusModeGiantHeavyAttack();
							}
							else if ( ACS_GetItem_Axe_Silver() )
							{
								FocusModeAxeHeavyAttack();
							}
							else if ( ACS_GetItem_Spear_Silver() )
							{	
								FocusModeSpearHeavyAttack();
							}
							else if ( ACS_GetItem_Greg_Silver() )
							{	
								FocusModeGregHeavyAttack();
							}
							else if ( ACS_GetItem_Olgierd_Silver() )
							{	
								FocusModeOlgierdHeavyAttack();
							}
							else if ( ACS_GetItem_Eredin_Silver() )
							{	
								FocusModeEredinShieldHeavyAttack();
							}
							else if ( ACS_GetItem_Imlerith_Silver() )
							{	
								FocusModeImlerithHeavyAttack();
							}
							else if ( ACS_GetItem_Claws_Silver() )
							{	
								FocusModeClawHeavyAttack();
							}
							else if ( ACS_GetItem_Katana_Silver() )
							{
								FocusModeGregHeavyAttack();
							}
							else
							{	
								ACS_DefaultSwitch();		

								thePlayer.RemoveTag('igni_sword_equipped_TAG');	
								thePlayer.AddTag('igni_secondary_sword_equipped_TAG');

								ACS_Setup_Combat_Action_Heavy();
							}
						}
						else if (thePlayer.IsWeaponHeld('steelsword'))
						{
							if ( ACS_GetItem_Hammer_Steel() )
							{
								FocusModeGiantHeavyAttack();
							}
							else if ( ACS_GetItem_Axe_Steel() )
							{
								FocusModeAxeHeavyAttack();
							}
							else if ( ACS_GetItem_Spear_Steel() )
							{	
								FocusModeSpearHeavyAttack();
							}
							else if ( ACS_GetItem_Greg_Steel() )
							{	
								FocusModeGregHeavyAttack();
							}
							else if ( ACS_GetItem_Olgierd_Steel() )
							{	
								FocusModeOlgierdHeavyAttack();
							}
							else if ( ACS_GetItem_Eredin_Steel() )
							{	
								FocusModeEredinShieldHeavyAttack();
							}
							else if ( ACS_GetItem_Imlerith_Steel() )
							{	
								FocusModeImlerithHeavyAttack();
							}
							else if ( ACS_GetItem_Claws_Steel() )
							{	
								FocusModeClawHeavyAttack();
							}
							else if ( ACS_GetItem_Katana_Steel() )
							{
								FocusModeGregHeavyAttack();
							}
							else
							{	
								ACS_DefaultSwitch();		

								thePlayer.RemoveTag('igni_sword_equipped_TAG');	
								thePlayer.AddTag('igni_secondary_sword_equipped_TAG');

								ACS_Setup_Combat_Action_Heavy();
							}
						}
					}
				}
			}
			else
			{
				ACS_Setup_Combat_Action_Heavy();
			}
		}
		else
		{
			ACS_Setup_Combat_Action_Heavy();
		}

		//thePlayer.SetBehaviorVariable( 'playerToTargetDistForOverlay', VecDistance( thePlayer.GetWorldPosition(), actor.GetNearestPointInPersonalSpace( thePlayer.GetWorldPosition() ) ) );

		DeactivateThings();
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	function SpecialAttackSwitch()
	{
		DeactivateThings();

		ACS_ThingsThatShouldBeRemoved();

		ACS_ExplorationDelayHack();

		ACS_Finisher_PreAction();

		if ( thePlayer.IsActionAllowed(EIAB_SpecialAttackLight) )
		{
			if ( CiriCheck() )
			{
				if ( FinisherCheck() 
				&& HitAnimCheck()
				&& WraithModeCheck()
				&& BruxaBiteCheck()
				&& thePlayer.IsAnyWeaponHeld()
				&& !thePlayer.IsWeaponHeld('fists')
				&& !thePlayer.HasTag('vampire_claws_equipped')
				)
				{
					if (ACS_GetWeaponMode() == 0 && !thePlayer.IsWeaponHeld( 'fist' ))
					{
						ACSGetEquippedSword().StopAllEffects();

						if( thePlayer.GetEquippedSign() == ST_Axii )
						{	
							if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
							{
								ACS_PrimaryWeaponSwitch(); 
								thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');
								thePlayer.AddTag('igni_sword_equipped_TAG');

								thePlayer.PrepareToAttack();
								thePlayer.SetPlayedSpecialAttackMissingResourceSound(false);
								thePlayer.AddTimer( 'IsSpecialLightAttackInputHeld', 0.00001, true );
							}
							else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
							{
								ArmigerModeOlgierdSpecialAttack();
							}
							else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
							{
								ArmigerModeEredinShieldSpecialAttack();
							}
							else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
							{
								ArmigerModeClawSpecialAttack();
							}
							else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
							{
								ArmigerModeImlerithSpecialAttack();
							}
						}
						else if( thePlayer.GetEquippedSign() == ST_Quen)
						{	
							if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
							{
								ACS_PrimaryWeaponSwitch(); 
								thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');
								thePlayer.AddTag('igni_sword_equipped_TAG');

								thePlayer.PrepareToAttack();
								thePlayer.SetPlayedSpecialAttackMissingResourceSound(false);
								thePlayer.AddTimer( 'IsSpecialLightAttackInputHeld', 0.00001, true );
							}
							else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
							{
								ArmigerModeOlgierdSpecialAttack();
							}
							else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
							{
								ArmigerModeEredinShieldSpecialAttack();
							}
							else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
							{
								ArmigerModeClawSpecialAttack();
							}
							else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
							{
								ArmigerModeImlerithSpecialAttack();
							}
						}
						else if( thePlayer.GetEquippedSign() == ST_Aard )
						{	
							if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
							{
								ACS_PrimaryWeaponSwitch(); 
								thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');
								thePlayer.AddTag('igni_sword_equipped_TAG');

								thePlayer.PrepareToAttack();
								thePlayer.SetPlayedSpecialAttackMissingResourceSound(false);
								thePlayer.AddTimer( 'IsSpecialLightAttackInputHeld', 0.00001, true );
							}
							else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
							{
								ArmigerModeOlgierdSpecialAttack();
							}
							else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
							{
								ArmigerModeEredinShieldSpecialAttack();
							}
							else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
							{
								ArmigerModeClawSpecialAttack();
							}
							else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
							{
								ArmigerModeImlerithSpecialAttack();
							}
						}
						else if( thePlayer.GetEquippedSign() == ST_Yrden )
						{
							if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
							{
								ACS_PrimaryWeaponSwitch(); 
								thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');
								thePlayer.AddTag('igni_sword_equipped_TAG');

								thePlayer.PrepareToAttack();
								thePlayer.SetPlayedSpecialAttackMissingResourceSound(false);
								thePlayer.AddTimer( 'IsSpecialLightAttackInputHeld', 0.00001, true );
							}
							else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
							{
								ArmigerModeOlgierdSpecialAttack();
							}
							else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
							{
								ArmigerModeEredinShieldSpecialAttack();
							}
							else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
							{
								ArmigerModeClawSpecialAttack();
							}
							else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
							{
								ArmigerModeImlerithSpecialAttack();
							}
						}
						else if( thePlayer.GetEquippedSign() == ST_Igni )
						{	
							if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
							{
								ACS_PrimaryWeaponSwitch(); 
								thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');
								thePlayer.AddTag('igni_sword_equipped_TAG');

								thePlayer.PrepareToAttack();
								thePlayer.SetPlayedSpecialAttackMissingResourceSound(false);
								thePlayer.AddTimer( 'IsSpecialLightAttackInputHeld', 0.00001, true );
							}
							else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
							{
								ArmigerModeOlgierdSpecialAttack();
							}
							else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
							{
								ArmigerModeEredinShieldSpecialAttack();
							}
							else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
							{
								ArmigerModeClawSpecialAttack();
							}
							else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
							{
								ArmigerModeImlerithSpecialAttack();
							}
						}
					}
					else if (ACS_GetWeaponMode() == 1)
					{
						ACSGetEquippedSword().StopAllEffects();

						if (thePlayer.IsWeaponHeld('silversword'))
						{
							if( ACS_GetFocusModeSilverWeapon() == 0 )
							{	
								ACS_PrimaryWeaponSwitch(); 
								thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');
								thePlayer.AddTag('igni_sword_equipped_TAG');

								thePlayer.PrepareToAttack();
								thePlayer.SetPlayedSpecialAttackMissingResourceSound(false);
								thePlayer.AddTimer( 'IsSpecialLightAttackInputHeld', 0.00001, true );
							}
							else if( ACS_GetFocusModeSilverWeapon() == 1 )
							{	
								FocusModeOlgierdSpecialAttack();
							}
							else if( ACS_GetFocusModeSilverWeapon() == 2 )
							{	
								FocusModeSpearSpecialAttack();
							}
							else if( ACS_GetFocusModeSilverWeapon() == 3)
							{	
								FocusModeEredinShieldSpecialAttack();
							}
							else if( ACS_GetFocusModeSilverWeapon() == 4 )
							{	
								FocusModeGregSpecialAttack();
							}
							else if( ACS_GetFocusModeSilverWeapon() == 5 )
							{
								FocusModeImlerithSpecialAttack();
							}
							else if( ACS_GetFocusModeSilverWeapon() == 6 )
							{	
								FocusModeGiantSpecialAttack();
							}
							else if( ACS_GetFocusModeSilverWeapon() == 7 )
							{	
								FocusModeClawSpecialAttack();
							}
							else if( ACS_GetFocusModeSilverWeapon() == 8 )
							{	
								FocusModeAxeSpecialAttack();
							}
						}
						else if (thePlayer.IsWeaponHeld('steelsword'))
						{
							if( ACS_GetFocusModeSteelWeapon() == 0 )
							{		
								ACS_PrimaryWeaponSwitch(); 
								thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');
								thePlayer.AddTag('igni_sword_equipped_TAG');

								thePlayer.PrepareToAttack();
								thePlayer.SetPlayedSpecialAttackMissingResourceSound(false);
								thePlayer.AddTimer( 'IsSpecialLightAttackInputHeld', 0.00001, true );
							}
							else if( ACS_GetFocusModeSteelWeapon() == 1 )
							{	
								FocusModeOlgierdSpecialAttack();
							}
							else if( ACS_GetFocusModeSteelWeapon() == 2 )
							{	
								FocusModeSpearSpecialAttack();
							}
							else if( ACS_GetFocusModeSteelWeapon() == 3)
							{	
								FocusModeEredinShieldSpecialAttack();
							}
							else if( ACS_GetFocusModeSteelWeapon() == 4 )
							{	
								FocusModeGregSpecialAttack();
							}
							else if( ACS_GetFocusModeSteelWeapon() == 5 )
							{
								FocusModeImlerithSpecialAttack();
							}
							else if( ACS_GetFocusModeSteelWeapon() == 6 )
							{	
								FocusModeGiantSpecialAttack();
							}
							else if( ACS_GetFocusModeSteelWeapon() == 7 )
							{	
								FocusModeClawSpecialAttack();
							}
							else if( ACS_GetFocusModeSteelWeapon() == 8 )
							{	
								FocusModeAxeSpecialAttack();
							}
						}
					}
					else if ( ACS_GetWeaponMode() == 2 && !thePlayer.IsWeaponHeld( 'fist' ) )
					{
						ACSGetEquippedSword().StopAllEffects();

						if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
						{
							if ( ACS_GetHybridModeForwardSpecialAttack() == 0 )
							{
								if (!thePlayer.HasTag('HybridDefaultWeaponTicket')){thePlayer.AddTag('HybridDefaultWeaponTicket');}

								ACS_PrimaryWeaponSwitch(); 
								thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');
								thePlayer.AddTag('igni_sword_equipped_TAG');

								thePlayer.PrepareToAttack();
								thePlayer.SetPlayedSpecialAttackMissingResourceSound(false);
								thePlayer.AddTimer( 'IsSpecialLightAttackInputHeld', 0.00001, true );
							}
							else if ( ACS_GetHybridModeForwardSpecialAttack() == 1 )
							{
								if (!thePlayer.HasTag('HybridOlgierdWeaponTicket')){thePlayer.AddTag('HybridOlgierdWeaponTicket');}

								HybridModeOlgierdForwardSpecialAttack();
							}
							else if ( ACS_GetHybridModeForwardSpecialAttack() == 2 )
							{
								if (!thePlayer.HasTag('HybridEredinWeaponTicket')){thePlayer.AddTag('HybridEredinWeaponTicket');}

								HybridModeEredinShieldForwardSpecialAttack();
							}
							else if ( ACS_GetHybridModeForwardSpecialAttack() == 3 )
							{
								if (!thePlayer.HasTag('HybridClawWeaponTicket')){thePlayer.AddTag('HybridClawWeaponTicket');}

								HybridModeClawForwardSpecialAttack();
							}
							else if ( ACS_GetHybridModeForwardSpecialAttack() == 4 )
							{
								if (!thePlayer.HasTag('HybridImlerithWeaponTicket')){thePlayer.AddTag('HybridImlerithWeaponTicket');}

								HybridModeImlerithForwardSpecialAttack();
							}
							else if ( ACS_GetHybridModeForwardSpecialAttack() == 5 )
							{
								if (!thePlayer.HasTag('HybridSpearWeaponTicket')){thePlayer.AddTag('HybridSpearWeaponTicket');}

								HybridModeSpearForwardSpecialAttack();
							}
							else if ( ACS_GetHybridModeForwardSpecialAttack() == 6 )
							{
								if (!thePlayer.HasTag('HybridGregWeaponTicket')){thePlayer.AddTag('HybridGregWeaponTicket');}

								HybridModeGregForwardSpecialAttack();
							}
							else if ( ACS_GetHybridModeForwardSpecialAttack() == 7 )
							{
								if (!thePlayer.HasTag('HybridAxeWeaponTicket')){thePlayer.AddTag('HybridAxeWeaponTicket');}

								HybridModeAxeForwardSpecialAttack();
							}
							else if ( ACS_GetHybridModeForwardSpecialAttack() == 8 )
							{
								if (!thePlayer.HasTag('HybridGiantWeaponTicket')){thePlayer.AddTag('HybridGiantWeaponTicket');}

								HybridModeGiantForwardSpecialAttack();
							}
						}
						else
						{
							if ( ACS_GetHybridModeSpecialAttack() == 0 )
							{
								if (!thePlayer.HasTag('HybridDefaultWeaponTicket')){thePlayer.AddTag('HybridDefaultWeaponTicket');}

								ACS_PrimaryWeaponSwitch(); 
								thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');
								thePlayer.AddTag('igni_sword_equipped_TAG');

								thePlayer.PrepareToAttack();
								thePlayer.SetPlayedSpecialAttackMissingResourceSound(false);
								thePlayer.AddTimer( 'IsSpecialLightAttackInputHeld', 0.00001, true );
							}
							else if ( ACS_GetHybridModeSpecialAttack() == 1 )
							{
								if (!thePlayer.HasTag('HybridOlgierdWeaponTicket')){thePlayer.AddTag('HybridOlgierdWeaponTicket');}

								HybridModeOlgierdSpecialAttack();
							}
							else if ( ACS_GetHybridModeSpecialAttack() == 2 )
							{
								if (!thePlayer.HasTag('HybridEredinWeaponTicket')){thePlayer.AddTag('HybridEredinWeaponTicket');}

								HybridModeEredinShieldSpecialAttack();
							}
							else if ( ACS_GetHybridModeSpecialAttack() == 3 )
							{
								if (!thePlayer.HasTag('HybridClawWeaponTicket')){thePlayer.AddTag('HybridClawWeaponTicket');}

								HybridModeClawSpecialAttack();
							}
							else if ( ACS_GetHybridModeSpecialAttack() == 4 )
							{
								if (!thePlayer.HasTag('HybridImlerithWeaponTicket')){thePlayer.AddTag('HybridImlerithWeaponTicket');}

								HybridModeImlerithSpecialAttack();
							}
							else if ( ACS_GetHybridModeSpecialAttack() == 5 )
							{
								if (!thePlayer.HasTag('HybridSpearWeaponTicket')){thePlayer.AddTag('HybridSpearWeaponTicket');}

								HybridModeSpearSpecialAttack();
							}
							else if ( ACS_GetHybridModeSpecialAttack() == 6 )
							{
								if (!thePlayer.HasTag('HybridGregWeaponTicket')){thePlayer.AddTag('HybridGregWeaponTicket');}

								HybridModeGregSpecialAttack();
							}
							else if ( ACS_GetHybridModeSpecialAttack() == 7 )
							{
								if (!thePlayer.HasTag('HybridAxeWeaponTicket')){thePlayer.AddTag('HybridAxeWeaponTicket');}

								HybridModeAxeSpecialAttack();
							}
							else if ( ACS_GetHybridModeSpecialAttack() == 8 )
							{
								if (!thePlayer.HasTag('HybridGiantWeaponTicket')){thePlayer.AddTag('HybridGiantWeaponTicket');}
								
								HybridModeGiantSpecialAttack();
							}
						}
					}
					else if (ACS_GetWeaponMode() == 3 && !thePlayer.IsWeaponHeld( 'fist' ) )
					{
						if (thePlayer.IsWeaponHeld('silversword'))
						{
							if( ACS_GetItem_Eredin_Silver() )
							{	
								FocusModeEredinShieldSpecialAttack();
							}
							else if( ACS_GetItem_Olgierd_Silver() )
							{	
								FocusModeOlgierdSpecialAttack();
							}
							else if( ACS_GetItem_Claws_Silver() )
							{	
								FocusModeClawSpecialAttack();
							}
							else if( ACS_GetItem_Imlerith_Silver() )
							{
								FocusModeImlerithSpecialAttack();
							}
							else if( ACS_GetItem_Spear_Silver() )
							{	
								FocusModeSpearSpecialAttack();
							}
							else if( ACS_GetItem_Greg_Silver() )
							{	
								FocusModeGregSpecialAttack();
							}
							else if( ACS_GetItem_Hammer_Silver() )
							{	
								FocusModeGiantSpecialAttack();
							}
							else if( ACS_GetItem_Axe_Silver() )
							{	
								FocusModeAxeSpecialAttack();
							}
							else if( ACS_GetItem_Katana_Silver() )
							{	
								FocusModeGregSpecialAttack();
							}
							else
							{					
								ACS_DefaultSwitch();

								thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');
								thePlayer.AddTag('igni_sword_equipped_TAG');
								
								thePlayer.PrepareToAttack();
								thePlayer.SetPlayedSpecialAttackMissingResourceSound(false);
								thePlayer.AddTimer( 'IsSpecialLightAttackInputHeld', 0.00001, true );
							}
						}
						else if (thePlayer.IsWeaponHeld('steelsword'))
						{
							if( ACS_GetItem_Eredin_Steel() )
							{	
								FocusModeEredinShieldSpecialAttack();
							}
							else if( ACS_GetItem_Olgierd_Steel() )
							{	
								FocusModeOlgierdSpecialAttack();
							}
							else if( ACS_GetItem_Claws_Steel() )
							{	
								FocusModeClawSpecialAttack();
							}
							else if( ACS_GetItem_Imlerith_Steel() )
							{
								FocusModeImlerithSpecialAttack();
							}
							else if( ACS_GetItem_Spear_Steel() )
							{	
								FocusModeSpearSpecialAttack();
							}
							else if( ACS_GetItem_Greg_Steel() )
							{	
								FocusModeGregSpecialAttack();
							}
							else if( ACS_GetItem_Hammer_Steel() )
							{	
								FocusModeGiantSpecialAttack();
							}
							else if( ACS_GetItem_Axe_Steel() )
							{	
								FocusModeAxeSpecialAttack();
							}
							else if( ACS_GetItem_Katana_Steel() )
							{	
								FocusModeGregSpecialAttack();
							}
							else
							{					
								ACS_DefaultSwitch();
								thePlayer.RemoveTag('igni_secondary_sword_equipped_TAG');
								thePlayer.AddTag('igni_sword_equipped_TAG');

								thePlayer.PrepareToAttack();
								thePlayer.SetPlayedSpecialAttackMissingResourceSound(false);
								thePlayer.AddTimer( 'IsSpecialLightAttackInputHeld', 0.00001, true );
							}
						}
					}
				}
			}
			else
			{
				thePlayer.PrepareToAttack();
				thePlayer.SetPlayedSpecialAttackMissingResourceSound(false);
				thePlayer.AddTimer( 'IsSpecialLightAttackInputHeld', 0.00001, true );
			}
		}
		else
		{
			thePlayer.PrepareToAttack();
			thePlayer.SetPlayedSpecialAttackMissingResourceSound(false);
			thePlayer.AddTimer( 'IsSpecialLightAttackInputHeld', 0.00001, true );
		}

		//thePlayer.SetBehaviorVariable( 'playerToTargetDistForOverlay', VecDistance( thePlayer.GetWorldPosition(), actor.GetNearestPointInPersonalSpace( thePlayer.GetWorldPosition() ) ) );

		DeactivateThings();
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	function RandomKickActual()
	{													
		if (
			ccompEnabled
			&& ACS_AttitudeCheck (actor) 
			&& actor.IsHuman()
			&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();
				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_guard_doubletap_attack() && thePlayer.IsInCombat())
			{
				ACS_refresh_guard_doubletap_attack_cooldown();
																
				geraltRandomKick();
											
				thePlayer.DrainStamina(ESAT_LightAttack);
			}
		}
	}

	function IgniCounterActual()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) 
		&& actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();
				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();
				ACS_PrimaryWeaponSwitch();
				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_guard_attack())
			{
				ACS_refresh_guard_attack_cooldown();

				ACS_PrimaryWeaponSwitch();		

				geraltRandomIgniCounter();
													
				thePlayer.DrainStamina(ESAT_LightAttack);
			}
		}
	}

	function AxiiCounterActual()
	{														
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) 
		&& actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();
				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_guard_attack())
			{
				ACS_refresh_guard_attack_cooldown();

				if (thePlayer.HasTag('axii_sword_equipped'))
				{				
					geraltRandomAxiiCounter();
				}
				else if (thePlayer.HasTag('axii_secondary_sword_equipped'))
				{
					geraltRandomGregCounter();
				}
			}
		}										
	}

	function HybridModeEredinShieldCounterActual()
	{														
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) 
		&& actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();
				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();
				ACS_PrimaryWeaponSwitch();
				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_guard_attack())
			{
				ACS_refresh_guard_attack_cooldown();

				ACS_PrimaryWeaponSwitch();

				geraltRandomAxiiCounter();
			}
		}										
	}

	function HybridModeGregCounterActual()
	{														
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) 
		&& actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();
				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();
				ACS_SecondaryWeaponSwitch();
				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_guard_attack())
			{
				ACS_refresh_guard_attack_cooldown();

				ACS_SecondaryWeaponSwitch();

				geraltRandomGregCounter();
			}
		}										
	}

	function AardCounterActual()
	{														
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) 
		&& actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();
				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_guard_attack())
			{
				ACS_refresh_guard_attack_cooldown();
				// Created and designed by error_noaccess, exclusive to the Wolven Workshop discord server and Github. 
				// Not authorized to be distributed elsewhere, unless you ask me nicely.

				if (thePlayer.HasTag('aard_sword_equipped'))
				{				
					geraltRandomAardCounter();
															
					thePlayer.DrainStamina(ESAT_LightAttack);
				}
				else if (thePlayer.HasTag('aard_secondary_sword_equipped'))
				{
					geraltRandomAxeCounter();
				}
			}
		}									
	}

	function AxeCounter()
	{														
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) 
		&& actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();
				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_guard_attack())
			{
				ACS_refresh_guard_attack_cooldown();
				// Created and designed by error_noaccess, exclusive to the Wolven Workshop discord server and Github. 
				// Not authorized to be distributed elsewhere, unless you ask me nicely.

				geraltRandomAxeCounter();
			}
		}									
	}

	function HybridModeClawCounterActual()
	{														
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) 
		&& actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();
				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();
				ACS_PrimaryWeaponSwitch();
				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_guard_attack())
			{
				ACS_refresh_guard_attack_cooldown();
				// Created and designed by error_noaccess, exclusive to the Wolven Workshop discord server and Github. 
				// Not authorized to be distributed elsewhere, unless you ask me nicely.

				ACS_PrimaryWeaponSwitch();

				geraltRandomAardCounter();
															
				thePlayer.DrainStamina(ESAT_LightAttack);
			}
		}									
	}

	function HybridModeAxeCounterActual()
	{														
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) 
		&& actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();
				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();
				ACS_SecondaryWeaponSwitch();
				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_guard_attack())
			{
				ACS_refresh_guard_attack_cooldown();
				// Created and designed by error_noaccess, exclusive to the Wolven Workshop discord server and Github. 
				// Not authorized to be distributed elsewhere, unless you ask me nicely.
				ACS_SecondaryWeaponSwitch();
				geraltRandomAxeCounter();
			}
		}									
	}

	function QuenCounterActual()
	{														
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) 
		&& actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();
				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_guard_attack())
			{
				ACS_refresh_guard_attack_cooldown();

				if (thePlayer.HasTag('quen_sword_equipped'))
				{														
					geraltRandomQuenCounter();
															
					thePlayer.DrainStamina(ESAT_LightAttack);
				}
				else if (thePlayer.HasTag('quen_secondary_sword_equipped'))
				{
					geraltRandomSpearCounter();
				}
			}
		}
	}

	function HybridModeOlgierdCounterActual()
	{														
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) 
		&& actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();
				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();
				ACS_PrimaryWeaponSwitch();
				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_guard_attack())
			{
				ACS_refresh_guard_attack_cooldown();

				ACS_PrimaryWeaponSwitch();

				geraltRandomQuenCounter();
															
				thePlayer.DrainStamina(ESAT_LightAttack);
			}
		}
	}

	function HybridModeSpearCounterActual()
	{														
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) 
		&& actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();
				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();
				ACS_SecondaryWeaponSwitch();
				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_guard_attack())
			{
				ACS_refresh_guard_attack_cooldown();

				ACS_SecondaryWeaponSwitch();
				
				geraltRandomSpearCounter();
			}
		}
	}

	function YrdenCounterActual()
	{														
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) 
		&& actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();
				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_guard_attack())
			{
				ACS_refresh_guard_attack_cooldown();

				if (thePlayer.HasTag('yrden_sword_equipped'))
				{									
					geraltRandomYrdenCounter();	
				}
				else if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
				{
					geraltRandomGiantCounter();
				}
			}
		}	
	}

	function HybridModeImlerithCounterActual()
	{														
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) 
		&& actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();
				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();
				ACS_PrimaryWeaponSwitch();
				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_guard_attack())
			{
				ACS_refresh_guard_attack_cooldown();
				
				ACS_PrimaryWeaponSwitch();
														
				geraltRandomYrdenCounter();	
			}
		}	
	}

	function HybridModeGiantCounterActual()
	{														
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) 
		&& actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();
				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();
				ACS_SecondaryWeaponSwitch();
				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_guard_attack())
			{
				ACS_refresh_guard_attack_cooldown();

				ACS_SecondaryWeaponSwitch();

				geraltRandomGiantCounter();
			}
		}	
	}

	function VampClawLightAttack()
	{
		if (ACS_StaminaBlockAction_Enabled() 
		&& VampireClawsStaminaCheck()
		)
		{					 
			thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
		}
		else
		{
			ACS_refresh_light_attack_cooldown();

			ACS_PrimaryWeaponSwitch();

			ACS_ClawEquipStandalone();

			/*								
			if (
			ccompEnabled
			&& ACS_AttitudeCheck (actor)
			&& actor.IsHuman()
			&& FinisherDistanceCheck()
			)
			{
				if ( actor.HasBuff( EET_HeavyKnockdown )  
				|| actor.HasBuff( EET_Knockdown ) 
				|| actor.HasBuff( EET_Ragdoll ) )
				{
					ACS_Setup_Combat_Action_Light();
				}
				else
				{
					//ACS_Dodge();
					action_interrupt();
					thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
				}
			}
			else
			{
				*/
				if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
				{
					if (ACS_VampireSoundEffects_Enabled()) {VampVoiceEffects_Effort_Big();}						

					if (thePlayer.GetIsSprinting())
					{
						geraltClawSprintingAttack();
					}
					else
					{
						geraltRandomClawComboAttack();
					}
				}
				else
				{
					if (ACS_VampireSoundEffects_Enabled()) {VampVoiceEffects_Effort();}

					geraltRandomClawFistAttack();
				}
			//}
		}
	}

	function VampClawHeavyAttack()
	{
		if (ACS_StaminaBlockAction_Enabled() 
		&& VampireClawsStaminaCheck()
		)
		{
			thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
		}
		else
		{
			ACS_refresh_heavy_attack_cooldown();
										
			ACS_PrimaryWeaponSwitch();

			ACS_ClawEquipStandalone();

			/*					
			if (
			ccompEnabled
			&& ACS_AttitudeCheck (actor) 
			&& actor.IsHuman()
			&& FinisherDistanceCheck()
			)
			{
				if ( actor.HasBuff( EET_HeavyKnockdown )  
				|| actor.HasBuff( EET_Knockdown ) 
				|| actor.HasBuff( EET_Ragdoll ) )
				{
					ACS_Setup_Combat_Action_Heavy();	
				}
				else
				{
					//ACS_Dodge();
					action_interrupt();
					thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
				}
			}
			else
			{
				*/
				if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
				{
					if (ACS_VampireSoundEffects_Enabled()) {VampVoiceEffects_Monster();}

					geraltRandomClawAttackSpecialDash();

					//thePlayer.ClearAnimationSpeedMultipliers();	

					//if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }	

					//AddTimer('ACS_ResetAnimation', 0.75 / theGame.GetTimeScale() , false);
				}
				else
				{
					if (ACS_VampireSoundEffects_Enabled()) {VampVoiceEffects_Effort_Big();}

					geraltRandomHeavyClawAttack();

					thePlayer.ClearAnimationSpeedMultipliers();	

					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }	

					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
				}
			//}
		}
	}

	function ShockwaveFistLightAttack()
	{
		if (ACS_can_perform_light_attack())
		{
			if (
			ACS_StaminaBlockAction_Enabled() 
			&& 
			StaminaCheck()
			)
			{ 
				thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
			}
			else
			{
				ACS_refresh_light_attack_cooldown();

				geraltRandomLightFistAttack();

				AddTimer('ACS_portable_aard', 0.5, false);

				thePlayer.DrainStamina(ESAT_HeavyAttack);
			}
		}
	}

	function ShockwaveFistHeavyAttack()
	{
		if (ACS_can_perform_heavy_attack())
		{
			if (
			ACS_StaminaBlockAction_Enabled() 
			&& 
			StaminaCheck()
			)
			{					 
				thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
			}
			else
			{
				ACS_refresh_heavy_attack_cooldown();

				//geraltRandomHeavyFistAttack();

				geraltRandomLightFistAttack();

				AddTimer('ACS_portable_aard', 0.5, false);

				thePlayer.DrainStamina(ESAT_HeavyAttack);
			}
		}
	}

	function ArmigerModeOlgierdLightAttack()
	{												
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();
				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();
				ACS_PrimaryWeaponSwitch();
				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{
					ACS_PrimaryWeaponSwitch();
					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
														
					thePlayer.BreakPheromoneEffect();
																	
					ACS_PrimaryWeaponSwitch();
																	
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						geraltRandomOlgierdPirouette();
					}
					else
					{
						geraltRandomOlgierdAttack();
					}

					thePlayer.ClearAnimationSpeedMultipliers();	

					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }		

					AddTimer('ACS_ResetAnimation', 0.6 / theGame.GetTimeScale() , false);	
				}
			}
		}
	}

	function ArmigerModeClawLightAttack()
	{											
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			/*
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_Setup_Combat_Action_Light();
			}
			else
			{
			*/
				//ACS_Dodge();
				action_interrupt();
				ACS_PrimaryWeaponSwitch();
				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			//}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{
					ACS_PrimaryWeaponSwitch();
					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
																
					thePlayer.BreakPheromoneEffect();
																	
					ACS_PrimaryWeaponSwitch();
																	
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						if (thePlayer.GetIsSprinting())
						{
							geraltClawSprintingAttack();
						}
						else
						{
							geraltRandomClawComboAttack();
						}		
					}
					else
					{
						geraltRandomClawAttack();
					}
				}
			}
		}
	}

	function ArmigerModeEredinLightAttack()
	{											
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();
				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();
				ACS_PrimaryWeaponSwitch();
				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
																	
					shield_play_anim();
																	
					thePlayer.BreakPheromoneEffect();
																	
					ACS_PrimaryWeaponSwitch();
																													
					if (thePlayer.IsGuarded())
					{
						if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
						{
							geraltRandomShieldComboAttack();
						}
						else
						{
							geraltRandomShieldAttack();
						}
					}
					else
					{
						if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
						{
							geraltRandomEredinComboAttack();
						}
						else
						{
							geraltRandomEredinAttack();
						}	
					}

					//thePlayer.ClearAnimationSpeedMultipliers();	
					thePlayer.ClearAnimationSpeedMultipliers();	

					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }
																	
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);	
				}
			}
		}
	}

	function ArmigerModeImlerithLightAttack()
	{											
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
																		
					thePlayer.BreakPheromoneEffect();
																		
					ACS_PrimaryWeaponSwitch();
																															
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						geraltRandomImlerithBerserkAttack();

						thePlayer.ClearAnimationSpeedMultipliers();	

						if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(2 / theGame.GetTimeScale() ); }
					}
					else
					{
						geraltRandomImlerithAttack();

						thePlayer.ClearAnimationSpeedMultipliers();	

						if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }
					}
										
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
				}
			}
		}
	}

	function ArmigerModeGeraltHeavyAttack()
	{
		if ( thePlayer.HasTag('acs_bow_active') )
		{
			if ( ACS_StaminaBlockAction_Enabled() 
			&& StaminaCheck()
			)
			{ 
				ACS_RangedWeaponSwitch();

				thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') == 0  && theInput.GetActionValue('GI_AxisLeftY') == 0 )
			{
				if ( ACS_can_shoot_bow_stationary() )
				{
					ACS_refresh_bow_stationary_cooldown();

					ACS_RangedWeaponSwitch();

					//geraltShootBowStationary();

					AddTimer('ACS_ShootBowStationary', 0.00001, false);
				}
			}
			else
			{
				if ( ACS_can_shoot_bow_moving() )
				{
					ACS_refresh_bow_moving_cooldown();

					ACS_RangedWeaponSwitch();

					//geraltShootBowMoving();

					AddTimer('ACS_ShootBowMoving', 0.00001, false);
				}
			}
		}
		else if ( thePlayer.HasTag('acs_crossbow_active') )
		{
			if ( ACS_StaminaBlockAction_Enabled() 
			&& StaminaCheck()
			)
			{ 
				ACS_RangedWeaponSwitch();

				thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') == 0  && theInput.GetActionValue('GI_AxisLeftY') == 0 )
			{
				if ( ACS_can_shoot_crossbow() )
				{
					ACS_refresh_crossbow_cooldown();

					ACS_RangedWeaponSwitch();

					geraltShootCrossbowStationary();
				}
			}
			else
			{
				if ( ACS_can_perform_heavy_attack() )
				{
					ACS_refresh_heavy_attack_cooldown();

					ACS_RangedWeaponSwitch();

					geraltShootCrossbowMoving();
				}
			}
		}
		else if ( !thePlayer.HasTag('acs_bow_active') && !thePlayer.HasTag('acs_crossbow_active') )
		{
			ACS_SecondaryWeaponSwitch();

			thePlayer.RemoveTag('igni_sword_equipped_TAG');	
			thePlayer.AddTag('igni_secondary_sword_equipped_TAG');
										
			ACS_Setup_Combat_Action_Heavy();
		}
	}

	function ArmigerModeSpearHeavyAttack()
	{										
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			thePlayer.BreakPheromoneEffect();

			if ( thePlayer.HasTag('acs_bow_active') )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_RangedWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else if (theInput.GetActionValue('GI_AxisLeftX') == 0  && theInput.GetActionValue('GI_AxisLeftY') == 0 )
				{
					if ( ACS_can_shoot_bow_stationary() )
					{
						ACS_refresh_bow_stationary_cooldown();

						ACS_RangedWeaponSwitch();

						//geraltShootBowStationary();

						AddTimer('ACS_ShootBowStationary', 0.00001, false);
					}
				}
				else
				{
					if ( ACS_can_shoot_bow_moving() )
					{
						ACS_refresh_bow_moving_cooldown();

						ACS_RangedWeaponSwitch();

						//geraltShootBowMoving();

						AddTimer('ACS_ShootBowMoving', 0.00001, false);
					}
				}
			}
			else if ( thePlayer.HasTag('acs_crossbow_active') )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_RangedWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else if (theInput.GetActionValue('GI_AxisLeftX') == 0  && theInput.GetActionValue('GI_AxisLeftY') == 0 )
				{
					if ( ACS_can_shoot_crossbow() )
					{
						ACS_refresh_crossbow_cooldown();

						ACS_RangedWeaponSwitch();

						geraltShootCrossbowStationary();
					}
				}
				else
				{
					if ( ACS_can_perform_heavy_attack() )
					{
						ACS_refresh_heavy_attack_cooldown();

						ACS_RangedWeaponSwitch();

						geraltShootCrossbowMoving();
					}
				}
			}
			else if ( !thePlayer.HasTag('acs_bow_active') && !thePlayer.HasTag('acs_crossbow_active') )
			{
				if ( ACS_can_perform_heavy_attack() )
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& StaminaCheck()
					)
					{ 
						ACS_SecondaryWeaponSwitch();

						thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_heavy_attack_cooldown();
																	
						ACS_SecondaryWeaponSwitch();

						if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
						{
							geraltRandomSpearAttackAlt();
						}
						else
						{
							geraltRandomSpearAttack();
						} 	

						thePlayer.ClearAnimationSpeedMultipliers();	
										
						if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
																	
						AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);	
					}
				}
			}
		}
	}

	function ArmigerModeAxeHeavyAttack()
	{									
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
						
		else
		{
			if ( thePlayer.HasTag('acs_bow_active') )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_RangedWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else if (theInput.GetActionValue('GI_AxisLeftX') == 0  && theInput.GetActionValue('GI_AxisLeftY') == 0 )
				{
					if ( ACS_can_shoot_bow_stationary() )
					{
						ACS_refresh_bow_stationary_cooldown();

						ACS_RangedWeaponSwitch();

						//geraltShootBowStationary();

						AddTimer('ACS_ShootBowStationary', 0.00001, false);
					}
				}
				else
				{
					if ( ACS_can_shoot_bow_moving() )
					{
						ACS_refresh_bow_moving_cooldown();

						ACS_RangedWeaponSwitch();

						//geraltShootBowMoving();

						AddTimer('ACS_ShootBowMoving', 0.00001, false);
					}
				}
			}
			else if ( thePlayer.HasTag('acs_crossbow_active') )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_RangedWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else if (theInput.GetActionValue('GI_AxisLeftX') == 0  && theInput.GetActionValue('GI_AxisLeftY') == 0 )
				{
					if ( ACS_can_shoot_crossbow() )
					{
						ACS_refresh_crossbow_cooldown();

						ACS_RangedWeaponSwitch();

						geraltShootCrossbowStationary();
					}
				}
				else
				{
					if ( ACS_can_perform_heavy_attack() )
					{
						ACS_refresh_heavy_attack_cooldown();

						ACS_RangedWeaponSwitch();

						geraltShootCrossbowMoving();
					}
				}
			}
			else if ( !thePlayer.HasTag('acs_bow_active') && !thePlayer.HasTag('acs_crossbow_active') )
			{
				if ( ACS_can_perform_heavy_attack() )
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& StaminaCheck()
					)
					{	
						ACS_SecondaryWeaponSwitch();

						thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_heavy_attack_cooldown();											

						ACS_SecondaryWeaponSwitch();

						if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
						{										
							geraltRandomAxeAttackAlt();

							thePlayer.ClearAnimationSpeedMultipliers();	

							if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
																
							AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);	
						}
						else
						{
							geraltRandomAxeAttack();
						}													
					}				
				}
			}
		}
	}

	function ArmigerModeGregHeavyAttack()
	{											
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			thePlayer.BreakPheromoneEffect();

			if ( thePlayer.HasTag('acs_bow_active') )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_RangedWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else if (theInput.GetActionValue('GI_AxisLeftX') == 0  && theInput.GetActionValue('GI_AxisLeftY') == 0 )
				{
					if ( ACS_can_shoot_bow_stationary() )
					{
						ACS_refresh_bow_stationary_cooldown();

						ACS_RangedWeaponSwitch();

						//geraltShootBowStationary();

						AddTimer('ACS_ShootBowStationary', 0.00001, false);
					}
				}
				else
				{
					if ( ACS_can_shoot_bow_moving() )
					{
						ACS_refresh_bow_moving_cooldown();

						ACS_RangedWeaponSwitch();

						//geraltShootBowMoving();

						AddTimer('ACS_ShootBowMoving', 0.00001, false);
					}
				}
			}
			else if ( thePlayer.HasTag('acs_crossbow_active') )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_RangedWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else if (theInput.GetActionValue('GI_AxisLeftX') == 0  && theInput.GetActionValue('GI_AxisLeftY') == 0 )
				{
					if ( ACS_can_shoot_crossbow() )
					{
						ACS_refresh_crossbow_cooldown();

						ACS_RangedWeaponSwitch();

						geraltShootCrossbowStationary();
					}
				}
				else
				{
					if ( ACS_can_perform_heavy_attack() )
					{
						ACS_refresh_heavy_attack_cooldown();

						ACS_RangedWeaponSwitch();

						geraltShootCrossbowMoving();
					}
				}
			}
			else if ( !thePlayer.HasTag('acs_bow_active') && !thePlayer.HasTag('acs_crossbow_active') )
			{
				if ( ACS_can_perform_heavy_attack() )
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& StaminaCheck()
					)
					{ 
						ACS_SecondaryWeaponSwitch();

						thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_heavy_attack_cooldown();
																		
						shield_play_anim();															

						ACS_SecondaryWeaponSwitch();

						if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
						{
							geraltRandomGregAttackAlt();
						}
						else
						{												
							geraltRandomGregAttack();

							thePlayer.ClearAnimationSpeedMultipliers();	

							if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }
																		
							AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);	
						}	
					}
				}
			}
		}
	}

	function ArmigerModeHammerHeavyAttack()
	{									
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			thePlayer.BreakPheromoneEffect();

			if ( thePlayer.HasTag('acs_bow_active') )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_RangedWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else if (theInput.GetActionValue('GI_AxisLeftX') == 0  && theInput.GetActionValue('GI_AxisLeftY') == 0 )
				{
					if ( ACS_can_shoot_bow_stationary() )
					{
						ACS_refresh_bow_stationary_cooldown();

						ACS_RangedWeaponSwitch();

						//geraltShootBowStationary();

						AddTimer('ACS_ShootBowStationary', 0.00001, false);
					}
				}
				else
				{
					if ( ACS_can_shoot_bow_moving() )
					{
						ACS_refresh_bow_moving_cooldown();

						ACS_RangedWeaponSwitch();

						//geraltShootBowMoving();

						AddTimer('ACS_ShootBowMoving', 0.00001, false);
					}
				}
			}
			else if ( thePlayer.HasTag('acs_crossbow_active') )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_RangedWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else if (theInput.GetActionValue('GI_AxisLeftX') == 0  && theInput.GetActionValue('GI_AxisLeftY') == 0 )
				{
					if ( ACS_can_shoot_crossbow() )
					{
						ACS_refresh_crossbow_cooldown();

						ACS_RangedWeaponSwitch();

						geraltShootCrossbowStationary();
					}
				}
				else
				{
					if ( ACS_can_perform_heavy_attack() )
					{
						ACS_refresh_heavy_attack_cooldown();

						ACS_RangedWeaponSwitch();

						geraltShootCrossbowMoving();
					}
				}
			}
			else if ( !thePlayer.HasTag('acs_bow_active') && !thePlayer.HasTag('acs_crossbow_active') )
			{
				if ( ACS_can_perform_heavy_attack() )
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& StaminaCheck()
					)
					{	
						ACS_SecondaryWeaponSwitch();

						thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_heavy_attack_cooldown();

						ACS_SecondaryWeaponSwitch();

						if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
						{					
							geraltRandomHammerSpecialAttack();

							thePlayer.ClearAnimationSpeedMultipliers();	

							if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }

							AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
						}
						else
						{
							geraltRandomHammerAttack();
						}												
					}
				}
			}
		}
	}

	function FocusModeOlgierdLightAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
									
					thePlayer.BreakPheromoneEffect();
												
					ACS_PrimaryWeaponSwitch();
												
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						geraltRandomOlgierdLightAttackAlt();
					}
					else
					{
						geraltRandomOlgierdLightAttack();
					}	

					thePlayer.ClearAnimationSpeedMultipliers();	

					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }

					AddTimer('ACS_ResetAnimation', 0.6 / theGame.GetTimeScale() , false);
				}
			}
		}
	}

	function HybridModeOlgierdLightAttack()
	{												
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
									
					thePlayer.BreakPheromoneEffect();
												
					ACS_PrimaryWeaponSwitch();
												
					geraltRandomOlgierdLightAttack();

					thePlayer.ClearAnimationSpeedMultipliers();	

					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }
												
					AddTimer('ACS_ResetAnimation', 0.6 / theGame.GetTimeScale() , false);
				}
			}
		}
	}

	function HybridModeOlgierdForwardLightAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();
				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
									
					thePlayer.BreakPheromoneEffect();
												
					ACS_PrimaryWeaponSwitch();
												
					geraltRandomOlgierdLightAttackAlt();	

					thePlayer.ClearAnimationSpeedMultipliers();	
												
					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
												
					AddTimer('ACS_ResetAnimation', 0.6 / theGame.GetTimeScale() , false);
				}
			}
		}
	}

	function FocusModeClawLightAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			/*
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_Setup_Combat_Action_Light();
			}
			else
			{
			*/
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			//}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
											
					thePlayer.BreakPheromoneEffect();
												
					ACS_PrimaryWeaponSwitch();
																			
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						if (thePlayer.GetIsSprinting())
						{
							geraltClawSprintingAttack();
						}
						else
						{
							geraltRandomClawLightAttackAlt();
						}
					}
					else
					{
						geraltRandomClawLightAttack();
					}
				}
			}
		}
	}

	function HybridModeClawLightAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			/*
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_Setup_Combat_Action_Light();
			}
			else
			{
			*/
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			//}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_PrimaryWeaponSwitch();		

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
											
					thePlayer.BreakPheromoneEffect();
												
					ACS_PrimaryWeaponSwitch();
							
					geraltRandomClawLightAttack();
				}
			}
		}
	}

	function HybridModeClawForwardLightAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			/*
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_Setup_Combat_Action_Light();
			}
			else
			{
			*/
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			//}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{			
					ACS_PrimaryWeaponSwitch();	

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
											
					thePlayer.BreakPheromoneEffect();
												
					ACS_PrimaryWeaponSwitch();

					if (thePlayer.GetIsSprinting())
					{
						geraltClawSprintingAttack();
					}
					else
					{
						geraltRandomClawLightAttackAlt();
					}
				}
			}
		}
	}

	function FocusModeEredinShieldLightAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
												
					shield_play_anim();
												
					thePlayer.BreakPheromoneEffect();
												
					ACS_PrimaryWeaponSwitch();
												
					if (thePlayer.IsGuarded())
					{
						if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
						{
							geraltRandomShieldLightAttackAlt();
						}
						else
						{
							geraltRandomShieldLightAttack();
						}
					}
					else
					{
						if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
						{
							geraltRandomEredinLightAttackAlt();
						}
						else
						{
							geraltRandomEredinLightAttack();
						}	
					} 	

					thePlayer.ClearAnimationSpeedMultipliers();	
					
					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }
												
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);	
				}
			}
		}
	}

	function HybridModeEredinShieldLightAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_PrimaryWeaponSwitch();	

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
												
					shield_play_anim();
												
					thePlayer.BreakPheromoneEffect();
												
					ACS_PrimaryWeaponSwitch();
												
					if (thePlayer.IsGuarded())
					{		
						geraltRandomShieldLightAttack();
					}
					else
					{	
						geraltRandomEredinLightAttack();
					} 	

					thePlayer.ClearAnimationSpeedMultipliers();	
					
					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }
												
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
				}
			}
		}
	}

	function HybridModeEredinShieldForwardLightAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_PrimaryWeaponSwitch();	

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
												
					shield_play_anim();
												
					thePlayer.BreakPheromoneEffect();
												
					ACS_PrimaryWeaponSwitch();
												
					if (thePlayer.IsGuarded())
					{
						geraltRandomShieldLightAttackAlt();
					}
					else
					{
						geraltRandomEredinLightAttackAlt();
					} 	

					thePlayer.ClearAnimationSpeedMultipliers();	
					
					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }
												
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);	
				}
			}
		}
	}

	function FocusModeImlerithLightAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
													
					thePlayer.BreakPheromoneEffect();
													
					ACS_PrimaryWeaponSwitch();
								
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						geraltRandomImlerithLightAttackAlt();
					}
					else
					{
						geraltRandomImlerithLightAttack();

						thePlayer.ClearAnimationSpeedMultipliers();	

						if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }
					}
					
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);	
				}
			}
		}
	}

	function HybridModeImlerithLightAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_PrimaryWeaponSwitch();		

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
													
					thePlayer.BreakPheromoneEffect();
													
					ACS_PrimaryWeaponSwitch();
													
					geraltRandomImlerithLightAttack(); 			

					thePlayer.ClearAnimationSpeedMultipliers();			
													
					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 1.5 / theGame.GetTimeScale() ); }
					
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);	
				}
			}
		}
	}

	function HybridModeImlerithForwardLightAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{		
					ACS_PrimaryWeaponSwitch();	

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
													
					thePlayer.BreakPheromoneEffect();
													
					ACS_PrimaryWeaponSwitch();

					geraltRandomImlerithLightAttackAlt();
					
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);	
				}
			}
		}
	}

	function FocusModeSpearLightAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_SecondaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
													
					thePlayer.BreakPheromoneEffect();
													
					ACS_SecondaryWeaponSwitch();					
													
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						geraltRandomSpearLightAttackAlt();

						thePlayer.ClearAnimationSpeedMultipliers();	

						if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 1.5 / theGame.GetTimeScale() ); }
					}
					else
					{
						geraltRandomSpearLightAttack();

						thePlayer.ClearAnimationSpeedMultipliers();	

						if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 1.5 / theGame.GetTimeScale() ); }
					}
					
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
				}
			}
		}
	}

	function HybridModeSpearLightAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_SecondaryWeaponSwitch();	

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
													
					thePlayer.BreakPheromoneEffect();
													
					ACS_SecondaryWeaponSwitch();
													
					geraltRandomSpearLightAttack(); 				

					thePlayer.ClearAnimationSpeedMultipliers();		
													
					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 1.5 / theGame.GetTimeScale() ); }

					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
				}
			}
		}
	}

	function HybridModeSpearForwardLightAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_SecondaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
													
					thePlayer.BreakPheromoneEffect();
													
					ACS_SecondaryWeaponSwitch();
													
					geraltRandomSpearLightAttackAlt(); 		

					thePlayer.ClearAnimationSpeedMultipliers();				
													
					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 1.5 / theGame.GetTimeScale() ); }

					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
				}
			}
		}
	}

	function FocusModeGregLightAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_SecondaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
													
					thePlayer.BreakPheromoneEffect();
													
					ACS_SecondaryWeaponSwitch();
																					
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{		
						geraltRandomGregLightAttackAlt();

						thePlayer.ClearAnimationSpeedMultipliers();	

						if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 1.25 / theGame.GetTimeScale() ); }
					}
					else
					{
						geraltRandomGregLightAttack();

						thePlayer.ClearAnimationSpeedMultipliers();	

						if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 1.25 / theGame.GetTimeScale() ); }
					}
					
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
				}
			}
		}
	}

	function HybridModeGregLightAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_SecondaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
													
					thePlayer.BreakPheromoneEffect();
													
					ACS_SecondaryWeaponSwitch();
													
					geraltRandomGregLightAttack(); 		

					thePlayer.ClearAnimationSpeedMultipliers();	
													
					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.25 / theGame.GetTimeScale() ); }

					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
				}
			}
		}
	}

	function HybridModeGregForwardLightAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_SecondaryWeaponSwitch();		

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
													
					thePlayer.BreakPheromoneEffect();
													
					ACS_SecondaryWeaponSwitch();
													
					geraltRandomGregLightAttackAlt(); 		

					thePlayer.ClearAnimationSpeedMultipliers();				
													
					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.25 / theGame.GetTimeScale() ); }
				
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
				}
			}
		}
	}

	function FocusModeGiantLightAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_SecondaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
													
					thePlayer.BreakPheromoneEffect();
													
					ACS_SecondaryWeaponSwitch();
								
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						geraltRandomGiantLightAttackAlt();
					}
					else
					{
						geraltRandomGiantLightAttack();
					}
					
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
				}
			}
		}
	}

	function LangCheck()
	{
		var language				: string;
		var audioLanguage			: string; 
		var label, label_2			: string;

		theGame.GetGameLanguageName(audioLanguage,language); 

		label = GetLocStringById( 2112923078 );

		label_2 = GetLocStringByKey("preset_Mods_acs_name_acs_taunt_settings");

		if ( language == "CN" || language == "ZH" || audioLanguage == "CN" || audioLanguage == "ZH" )
		{
			if (label != "Special Abilities Settings"
			|| label_2 != "Taunt System Settings")
			{
				theGame.ChangePlayer( "ACS" );
			}
		}
	}
		
	function HybridModeGiantLightAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{		
					ACS_SecondaryWeaponSwitch();	

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
													
					thePlayer.BreakPheromoneEffect();
													
					ACS_SecondaryWeaponSwitch();
													
					geraltRandomGiantLightAttack();

					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
				}
			}
		}
	}

	function HybridModeGiantForwardLightAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_SecondaryWeaponSwitch();	

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
													
					thePlayer.BreakPheromoneEffect();
													
					ACS_SecondaryWeaponSwitch();
																				
					geraltRandomGiantLightAttackAlt();
	
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
				}
			}
		}
	}

	function FocusModeAxeLightAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_SecondaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
													
					thePlayer.BreakPheromoneEffect();
													
					ACS_SecondaryWeaponSwitch();
							
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						geraltRandomAxeLightAttackAlt();
					}
					else
					{
						geraltRandomAxeLightAttack();
					}

					thePlayer.ClearAnimationSpeedMultipliers();	

					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 1.25 / theGame.GetTimeScale() ); }
					
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
				}
			}
		}
	}

	function HybridModeAxeLightAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_SecondaryWeaponSwitch();	

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
													
					thePlayer.BreakPheromoneEffect();
													
					ACS_SecondaryWeaponSwitch();
																					
					geraltRandomAxeLightAttack();

					thePlayer.ClearAnimationSpeedMultipliers();	

					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 1.25 / theGame.GetTimeScale() ); }
					
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
				}
			}
		}
	}

	function HybridModeAxeForwardLightAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if (ACS_can_perform_light_attack())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_SecondaryWeaponSwitch();	

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_light_attack_cooldown();
													
					thePlayer.BreakPheromoneEffect();
													
					ACS_SecondaryWeaponSwitch();
																					
					geraltRandomAxeLightAttackAlt();

					thePlayer.ClearAnimationSpeedMultipliers();	

					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 1.25 / theGame.GetTimeScale() ); }
					
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
				}
			}
		}
	}

	function FocusModeGiantHeavyAttack()
	{											
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();
				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_heavy_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_heavy_attack_cooldown();
									
					thePlayer.BreakPheromoneEffect();
									
					ACS_SecondaryWeaponSwitch();
										
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						geraltRandomGiantHeavyAttackAlt();

						thePlayer.ClearAnimationSpeedMultipliers();	

						if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }
					}
					else
					{
						geraltRandomGiantHeavyAttack();
					}
									
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
				}
			}
		}
	}

	function HybridModeGiantHeavyAttack()
	{											
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_heavy_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_SecondaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_heavy_attack_cooldown();
									
					thePlayer.BreakPheromoneEffect();
									
					ACS_SecondaryWeaponSwitch();

					geraltRandomGiantHeavyAttack();
									
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
				}
			}
		}
	}

	function HybridModeGiantForwardHeavyAttack()
	{											
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_heavy_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_SecondaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_heavy_attack_cooldown();
									
					thePlayer.BreakPheromoneEffect();
									
					ACS_SecondaryWeaponSwitch();
									
					geraltRandomGiantHeavyAttackAlt(); 	

					thePlayer.ClearAnimationSpeedMultipliers();	
						
					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }
									
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
				}
			}
		}
	}

	function FocusModeAxeHeavyAttack()
	{											
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}

		else
		{
			if ( ACS_can_perform_heavy_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_SecondaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_heavy_attack_cooldown();
										
					thePlayer.BreakPheromoneEffect();
										
					ACS_SecondaryWeaponSwitch();
																				
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{				
						geraltRandomAxeHeavyAttackAlt();
					}
					else
					{
						geraltRandomAxeHeavyAttack();
					}

					thePlayer.ClearAnimationSpeedMultipliers();	

					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
										
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);	
				}				
			}
		}
	}

	function HybridModeAxeHeavyAttack()
	{											
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}

		else
		{
			if ( ACS_can_perform_heavy_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_SecondaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_heavy_attack_cooldown();
										
					thePlayer.BreakPheromoneEffect();
										
					ACS_SecondaryWeaponSwitch();
										
					geraltRandomAxeHeavyAttack(); 	

					thePlayer.ClearAnimationSpeedMultipliers();															
					
					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
										
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
				}				
			}
		}
	}

	function HybridModeAxeForwardHeavyAttack()
	{											
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}

		else
		{
			if ( ACS_can_perform_heavy_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_SecondaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_heavy_attack_cooldown();
										
					thePlayer.BreakPheromoneEffect();
										
					ACS_SecondaryWeaponSwitch();
										
					geraltRandomAxeHeavyAttackAlt(); 				

					thePlayer.ClearAnimationSpeedMultipliers();													

					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
										
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);					
				}				
			}
		}
	}

	function FocusModeSpearHeavyAttack()
	{												
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_heavy_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_SecondaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_heavy_attack_cooldown();
											
					thePlayer.BreakPheromoneEffect();
											
					ACS_SecondaryWeaponSwitch();
											
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						geraltRandomSpearHeavyAttackAlt();

						thePlayer.ClearAnimationSpeedMultipliers();	

						if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 2 / theGame.GetTimeScale() ); }
					}
					else
					{
						geraltRandomSpearHeavyAttack();

						thePlayer.ClearAnimationSpeedMultipliers();	

						if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 1.5 / theGame.GetTimeScale() ); }
					}

					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);	
				}
			}
		}
	}

	function HybridModeSpearHeavyAttack()
	{												
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_heavy_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_SecondaryWeaponSwitch(); 

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_heavy_attack_cooldown();
											
					thePlayer.BreakPheromoneEffect();
											
					ACS_SecondaryWeaponSwitch();
											
					geraltRandomSpearHeavyAttack(); 				

					thePlayer.ClearAnimationSpeedMultipliers();	

					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 1.5 / theGame.GetTimeScale() ); }

					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);	
				}
			}
		}
	}

	function HybridModeSpearForwardHeavyAttack()
	{												
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_heavy_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_SecondaryWeaponSwitch(); 

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_heavy_attack_cooldown();
											
					thePlayer.BreakPheromoneEffect();
											
					ACS_SecondaryWeaponSwitch();
											
					geraltRandomSpearHeavyAttackAlt(); 	
					
					thePlayer.ClearAnimationSpeedMultipliers();	
					
					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 2 / theGame.GetTimeScale() ); }

					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);	
				}
			}
		}
	}

	function FocusModeGregHeavyAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_heavy_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_SecondaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_heavy_attack_cooldown();
												
					shield_play_anim();
												
					thePlayer.BreakPheromoneEffect();
												
					ACS_SecondaryWeaponSwitch();
							
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						geraltRandomGregHeavyAttackAlt();
					}
					else
					{							
						geraltRandomGregHeavyAttack();
					}

					thePlayer.ClearAnimationSpeedMultipliers();	

					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.25 / theGame.GetTimeScale() ); }

					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);	
				}
			}
		}
	}

	function HybridModeGregHeavyAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_heavy_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	 
					ACS_SecondaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_heavy_attack_cooldown();
												
					shield_play_anim();
												
					thePlayer.BreakPheromoneEffect();
												
					ACS_SecondaryWeaponSwitch();
												
					geraltRandomGregHeavyAttack(); 			

					thePlayer.ClearAnimationSpeedMultipliers();				
												
					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.25 / theGame.GetTimeScale() ); }
											
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);	
				}
			}
		}
	}

	function HybridModeGregForwardHeavyAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_heavy_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	 
					ACS_SecondaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_heavy_attack_cooldown();
												
					shield_play_anim();
												
					thePlayer.BreakPheromoneEffect();
												
					ACS_SecondaryWeaponSwitch();
												
					geraltRandomGregHeavyAttackAlt();	 				

					thePlayer.ClearAnimationSpeedMultipliers();			
												
					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.25 / theGame.GetTimeScale() ); }
					
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);		
				}
			}
		}
	}

	function FocusModeOlgierdHeavyAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_heavy_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_heavy_attack_cooldown();
												
					shield_play_anim();
												
					thePlayer.BreakPheromoneEffect();
												
					ACS_PrimaryWeaponSwitch();
																			
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						geraltRandomOlgierdHeavyAttackAlt();
					}
					else
					{
						geraltRandomOlgierdHeavyAttack();

						thePlayer.ClearAnimationSpeedMultipliers();	

						if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }
												
						AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);	
					}
				}
			}
		}
	}

	function HybridModeOlgierdHeavyAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_heavy_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	 
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_heavy_attack_cooldown();
												
					shield_play_anim();
												
					thePlayer.BreakPheromoneEffect();
												
					ACS_PrimaryWeaponSwitch();
												
					geraltRandomOlgierdHeavyAttack(); 	

					thePlayer.ClearAnimationSpeedMultipliers();						
												
					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }
											
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);	
				}
			}
		}
	}

	function HybridModeOlgierdForwardHeavyAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_heavy_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_PrimaryWeaponSwitch(); 

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_heavy_attack_cooldown();
												
					shield_play_anim();
												
					thePlayer.BreakPheromoneEffect();
												
					ACS_PrimaryWeaponSwitch();
						
					geraltRandomOlgierdHeavyAttackAlt();
				}
			}
		}
	}

	function FocusModeEredinShieldHeavyAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_heavy_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_heavy_attack_cooldown();
												
					shield_play_anim();
												
					thePlayer.BreakPheromoneEffect();
												
					ACS_PrimaryWeaponSwitch();
												
					if (thePlayer.IsGuarded())
					{
						if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
						{
							geraltRandomShieldHeavyAttackAlt();
						}
						else
						{
							geraltRandomShieldHeavyAttack();
						}
					}
					else
					{
						if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
						{
							geraltRandomEredinHeavyAttackAlt();
						}
						else
						{
							geraltRandomEredinHeavyAttack();
						}	
					} 	

					thePlayer.ClearAnimationSpeedMultipliers();	
					
					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }
												
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);		
				}
			}
		}
	}

	function HybridModeEredinShieldHeavyAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_heavy_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_heavy_attack_cooldown();
												
					shield_play_anim();
												
					thePlayer.BreakPheromoneEffect();
												
					ACS_PrimaryWeaponSwitch();
												
					if (thePlayer.IsGuarded())
					{
						geraltRandomShieldHeavyAttack();
					}
					else
					{
						geraltRandomEredinHeavyAttack();
					} 	

					thePlayer.ClearAnimationSpeedMultipliers();	
					
					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }
												
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);	
				}
			}
		}
	}

	function HybridModeEredinShieldForwardHeavyAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_heavy_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_heavy_attack_cooldown();
												
					shield_play_anim();
												
					thePlayer.BreakPheromoneEffect();
												
					ACS_PrimaryWeaponSwitch();
												
					if (thePlayer.IsGuarded())
					{
						geraltRandomShieldHeavyAttackAlt();
					}
					else
					{
						geraltRandomEredinHeavyAttackAlt();
					} 	

					thePlayer.ClearAnimationSpeedMultipliers();	
					
					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }
												
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);	
				}
			}
		}
	}

	function FocusModeImlerithHeavyAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_heavy_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_heavy_attack_cooldown();
												
					shield_play_anim();
												
					thePlayer.BreakPheromoneEffect();
												
					ACS_PrimaryWeaponSwitch();
																			
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						geraltRandomImlerithHeavyAttackAlt();
					}
					else
					{
						geraltRandomImlerithHeavyAttack();

						thePlayer.ClearAnimationSpeedMultipliers();	

						if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }
												
						AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
					}
				}
			}
		}
	}

	function HybridModeImlerithHeavyAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_heavy_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_heavy_attack_cooldown();
												
					shield_play_anim();
												
					thePlayer.BreakPheromoneEffect();
										
					ACS_PrimaryWeaponSwitch();
												
					geraltRandomImlerithHeavyAttack(); 			

					thePlayer.ClearAnimationSpeedMultipliers();																

					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }
												
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);	
				}
			}
		}
	}

	function ACSCheck()
	{
		var label, label_2	:string; 

		label = GetLocStringById( 2112923009 ); 

		label_2 = GetLocStringByKey("preset_Mods_acs_name_acs_taunt_settings");

		if (
			label != "Minimum Stamina Requirement Enabled" 
			|| label_2 != "Taunt System Settings"
		)
		{
			theGame.ChangePlayer( "ACS" );
		}
	}

	function HybridModeImlerithForwardHeavyAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_heavy_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_heavy_attack_cooldown();
												
					shield_play_anim();
												
					thePlayer.BreakPheromoneEffect();
												
					ACS_PrimaryWeaponSwitch();
					
					geraltRandomImlerithHeavyAttackAlt();

					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
				}
			}
		}
	}

	function FocusModeClawHeavyAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_heavy_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_heavy_attack_cooldown();
												
					shield_play_anim();
												
					thePlayer.BreakPheromoneEffect();
												
					ACS_PrimaryWeaponSwitch();
																			
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						geraltRandomClawHeavyAttackAlt();
					}
					else
					{
						geraltRandomClawHeavyAttack();

						thePlayer.ClearAnimationSpeedMultipliers();	

						if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }
												
						AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
					}
				}
			}
		}
	}

	function HybridModeClawHeavyAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_heavy_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_heavy_attack_cooldown();
												
					shield_play_anim();
												
					thePlayer.BreakPheromoneEffect();
												
					ACS_PrimaryWeaponSwitch();
												
					geraltRandomClawHeavyAttack(); 		

					thePlayer.ClearAnimationSpeedMultipliers();															

					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }
												
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);	
				}
			}
		}
	}

	function HybridModeClawForwardHeavyAttack()
	{													
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_heavy_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_heavy_attack_cooldown();
												
					shield_play_anim();
												
					thePlayer.BreakPheromoneEffect();
												
					ACS_PrimaryWeaponSwitch();
																			
					geraltRandomClawHeavyAttackAlt();		
				}
			}
		}
	}
	
	function ArmigerModeEredinShieldSpecialAttack()
	{								
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
						
					shield_play_anim();
						
					thePlayer.BreakPheromoneEffect();	

					ACS_PrimaryWeaponSwitch(); 
						
					if (thePlayer.IsGuarded())
					{
						geraltRandomShieldAttackAlt();
					}
					else
					{
						if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
						{
							geraltEredinStab();

							thePlayer.ClearAnimationSpeedMultipliers();	
								
							if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }
							
							AddTimer('ACS_ResetAnimation', 0.75 / theGame.GetTimeScale() , false);
								
							AddTimer('ACS_portable_aard', 1.75 / theGame.GetTimeScale(), false );
						}
						else
						{
							geraltEredinFuryCombo();

							thePlayer.ClearAnimationSpeedMultipliers();	
								
							if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }
							
							AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
						}
					}
				}
			}
		}
	}

	function ArmigerModeOlgierdSpecialAttack()
	{								
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch(); 

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();

				action_interrupt();

				ACS_PrimaryWeaponSwitch(); 

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_PrimaryWeaponSwitch(); 

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
						
					thePlayer.BreakPheromoneEffect();	 	

					ACS_PrimaryWeaponSwitch(); 	
						
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						geraltRandomShadowAttack();

						//thePlayer.ClearAnimationSpeedMultipliers();	
										
						//if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
						
						//AddTimer('ACS_ResetAnimation', 0.75 / theGame.GetTimeScale() , false);
					}
					else
					{
						geraltRandomOlgierdComboAttack();

						thePlayer.ClearAnimationSpeedMultipliers();	

						if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
						
						AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
					}
				}
			}
		}
	}

	function ArmigerModeClawSpecialAttack()
	{
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch(); 

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch(); 

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
						
					thePlayer.BreakPheromoneEffect();	

					ACS_PrimaryWeaponSwitch(); 
							
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						geraltRandomAttackSpecialDash();

						//thePlayer.ClearAnimationSpeedMultipliers();	
							
						//if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
						
						//AddTimer('ACS_ResetAnimation', 0.75 / theGame.GetTimeScale() , false);
					}
					else
					{
						geraltClawWhirlAttack();
					}
				}
			}
		}
	}

	function ArmigerModeImlerithSpecialAttack()
	{
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_PrimaryWeaponSwitch();
					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
						
					thePlayer.BreakPheromoneEffect();	

					ACS_PrimaryWeaponSwitch(); 
							
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						geraltImlerithWalkAttack();
					}
					else
					{
						geraltRandomImlerithComboAttack();

						thePlayer.ClearAnimationSpeedMultipliers();	
							
						if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
						
						AddTimer('ACS_ResetAnimation', 0.75 / theGame.GetTimeScale() , false);
					}
				}
			}
		}
	}
	
	function FocusModeEredinShieldSpecialAttack()
	{										
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch(); 

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch(); 

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_PrimaryWeaponSwitch(); 

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
						
					shield_play_anim();
						
					thePlayer.BreakPheromoneEffect();	

					ACS_PrimaryWeaponSwitch(); 
							
					if (thePlayer.IsGuarded())
					{
						if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
						{
							geraltRandomShieldSpecialAttackAlt();
						}
						else
						{
							geraltRandomShieldSpecialAttack();
							
							AddTimer('ACS_portable_aard', 0.5, false);
						}
					}
					else
					{
						if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
						{
							geraltRandomEredinSpecialAttackAlt();

							thePlayer.ClearAnimationSpeedMultipliers();	
								
							if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }
							
							AddTimer('ACS_ResetAnimation', 0.75 / theGame.GetTimeScale() , false);
								
							AddTimer('ACS_portable_aard', 1.75 / theGame.GetTimeScale(), false );
						}
						else
						{
							geraltRandomEredinSpecialAttack();

							thePlayer.ClearAnimationSpeedMultipliers();	
								
							if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }
							
							AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
						}
					}
				}
			}
		}
	}

	function HybridModeEredinShieldSpecialAttack()
	{										
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
						
					shield_play_anim();
						
					thePlayer.BreakPheromoneEffect();	

					ACS_PrimaryWeaponSwitch();
							
					if (thePlayer.IsGuarded())
					{
						geraltRandomShieldSpecialAttack();
							
						AddTimer('ACS_portable_aard', 0.5, false);
					}
					else
					{
						geraltRandomEredinSpecialAttack();

						thePlayer.ClearAnimationSpeedMultipliers();	
								
						if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }
							
						AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
					}
				}
			}
		}
	}

	function HybridModeEredinShieldForwardSpecialAttack()
	{										
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
						
					shield_play_anim();
						
					thePlayer.BreakPheromoneEffect();	

					ACS_PrimaryWeaponSwitch();
							
					if (thePlayer.IsGuarded())
					{
						geraltRandomShieldSpecialAttackAlt();
					}
					else
					{
						geraltRandomEredinSpecialAttackAlt();

						thePlayer.ClearAnimationSpeedMultipliers();	
								
						if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }
							
						AddTimer('ACS_ResetAnimation', 0.75 / theGame.GetTimeScale() , false);
								
						AddTimer('ACS_portable_aard', 1.75 / theGame.GetTimeScale(), false );			
					}
				}
			}
		}
	}

	function FocusModeOlgierdSpecialAttack()
	{										
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch(); 

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_PrimaryWeaponSwitch(); 

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
						
					thePlayer.BreakPheromoneEffect();	

					ACS_PrimaryWeaponSwitch(); 
							
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						geraltRandomOlgierdSpecialAttackAlt();

						//thePlayer.ClearAnimationSpeedMultipliers();	
										
						//if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
						
						//AddTimer('ACS_ResetAnimation', 0.75 / theGame.GetTimeScale() , false);
					}
					else
					{
						geraltRandomOlgierdSpecialAttack();

						thePlayer.ClearAnimationSpeedMultipliers();	

						if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }
						
						AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
					}
				}
			}
		}
	}

	function HybridModeOlgierdSpecialAttack()
	{										
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
						
					thePlayer.BreakPheromoneEffect();	

					ACS_PrimaryWeaponSwitch();	

					geraltRandomOlgierdSpecialAttack(); 				

					thePlayer.ClearAnimationSpeedMultipliers();				

					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }
						
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
				}
			}
		}
	}

	function HybridModeOlgierdForwardSpecialAttack()
	{										
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
						
					thePlayer.BreakPheromoneEffect();	
						
					ACS_PrimaryWeaponSwitch();
						
					geraltRandomOlgierdSpecialAttackAlt();

					//thePlayer.ClearAnimationSpeedMultipliers();	
										
					//if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
						
					//AddTimer('ACS_ResetAnimation', 0.75 / theGame.GetTimeScale() , false);	
				}
			}
		}
	}

	function FocusModeClawSpecialAttack()
	{
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch(); 

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch(); 

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_PrimaryWeaponSwitch(); 

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
						
					thePlayer.BreakPheromoneEffect();	

					ACS_PrimaryWeaponSwitch(); 
							
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						geraltRandomClawSpecialAttackAlt();

						//thePlayer.ClearAnimationSpeedMultipliers();	
							
						//if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
						
						//AddTimer('ACS_ResetAnimation', 0.75 / theGame.GetTimeScale() , false);
					}
					else
					{
						geraltRandomClawSpecialAttack();
					}
				}
			}
		}
	}

	function HybridModeClawSpecialAttack()
	{
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	 
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
						
					thePlayer.BreakPheromoneEffect();	

					ACS_PrimaryWeaponSwitch();

					geraltRandomClawSpecialAttack();
				}
			}
		}
	}

	function HybridModeClawForwardSpecialAttack()
	{
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	 
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
						
					thePlayer.BreakPheromoneEffect();	

					ACS_PrimaryWeaponSwitch();
						
					geraltRandomClawSpecialAttackAlt();

					//thePlayer.ClearAnimationSpeedMultipliers();	
						
					//if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
					
					//AddTimer('ACS_ResetAnimation', 0.75 / theGame.GetTimeScale() , false);	
				}
			}
		}
	}

	function FocusModeImlerithSpecialAttack()
	{
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch(); 

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch(); 

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{
					ACS_PrimaryWeaponSwitch(); 

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
						
					thePlayer.BreakPheromoneEffect();	

					ACS_PrimaryWeaponSwitch(); 
							
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						geraltRandomImlerithSpecialAttackAlt();
					}
					else
					{
						geraltRandomImlerithSpecialAttack();

						thePlayer.ClearAnimationSpeedMultipliers();	
							
						if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
						
						AddTimer('ACS_ResetAnimation', 0.75 / theGame.GetTimeScale() , false);
					}
				}
			}
		}
	}

	function HybridModeImlerithSpecialAttack()
	{
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
						
					thePlayer.BreakPheromoneEffect();	
						
					ACS_PrimaryWeaponSwitch();
						
					geraltRandomImlerithSpecialAttack();

					thePlayer.ClearAnimationSpeedMultipliers();	
						
					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
					
					AddTimer('ACS_ResetAnimation', 0.75 / theGame.GetTimeScale() , false);
				}
			}
		}
	}

	function HybridModeImlerithForwardSpecialAttack()
	{
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_PrimaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_PrimaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_PrimaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
						
					thePlayer.BreakPheromoneEffect();	

					ACS_PrimaryWeaponSwitch();
						
					geraltRandomImlerithSpecialAttackAlt();			
				}
			}
		}
	}

	function FocusModeSpearSpecialAttack()
	{
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch(); 

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch(); 

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_SecondaryWeaponSwitch(); 

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
							
					thePlayer.BreakPheromoneEffect();	

					ACS_SecondaryWeaponSwitch(); 
								
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						geraltRandomSpearSpecialAttackAlt();

						thePlayer.ClearAnimationSpeedMultipliers();	
								
						if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
							
						AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
					}
					else
					{
						geraltRandomSpearSpecialAttack();

						thePlayer.ClearAnimationSpeedMultipliers();	
						
						if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
							
						AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
					}
				}
			}
		}
	}

	function HybridModeSpearSpecialAttack()
	{
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_SecondaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
							
					thePlayer.BreakPheromoneEffect();	

					ACS_SecondaryWeaponSwitch();

					geraltRandomSpearSpecialAttack();

					thePlayer.ClearAnimationSpeedMultipliers();	
					
					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
						
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
				}
			}
		}
	}

	function HybridModeSpearForwardSpecialAttack()
	{
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_SecondaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
							
					thePlayer.BreakPheromoneEffect();	
							
					ACS_SecondaryWeaponSwitch();
							
					geraltRandomSpearSpecialAttackAlt();

					thePlayer.ClearAnimationSpeedMultipliers();	
								
					if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
							
					AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
				}
			}
		}
	}

	function FocusModeGregSpecialAttack()
	{
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch(); 

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch(); 

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_SecondaryWeaponSwitch(); 

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
							
					thePlayer.BreakPheromoneEffect();	

					ACS_SecondaryWeaponSwitch(); 	
							
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						geraltRandomGregSpecialAttackAlt();
					}
					else
					{
						geraltRandomGregSpecialAttack();
					}
				}
			}
		}
	}

	function HybridModeGregSpecialAttack()
	{
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_SecondaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
							
					thePlayer.BreakPheromoneEffect();	
							
					ACS_SecondaryWeaponSwitch();		

					geraltRandomGregSpecialAttack();
				}
			}
		}
	}

	function HybridModeGregForwardSpecialAttack()
	{
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{ 
					ACS_SecondaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
							
					thePlayer.BreakPheromoneEffect();	
							
					ACS_SecondaryWeaponSwitch();
							
					geraltRandomGregSpecialAttackAlt();			
				}
			}
		}
	}

	function FocusModeGiantSpecialAttack()
	{
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch(); 

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch(); 

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{
					ACS_SecondaryWeaponSwitch(); 

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
							
					thePlayer.BreakPheromoneEffect();	
							
					ACS_SecondaryWeaponSwitch(); 	
							
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						geraltRandomGiantSpecialAttackAlt();
					}
					else
					{
						geraltRandomGiantSpecialAttack();
					}
				}
			}
		}
	}

	function HybridModeGiantSpecialAttack()
	{
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{		
					ACS_SecondaryWeaponSwitch();	

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
							
					thePlayer.BreakPheromoneEffect();		

					ACS_SecondaryWeaponSwitch();		

					geraltRandomGiantSpecialAttack();
				}
			}
		}
	}

	function HybridModeGiantForwardSpecialAttack()
	{
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_SecondaryWeaponSwitch();	

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
							
					thePlayer.BreakPheromoneEffect();	

					ACS_SecondaryWeaponSwitch();
							
					geraltRandomGiantSpecialAttackAlt();
				}
			}
		}
	}

	function FocusModeAxeSpecialAttack()
	{
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch(); 

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch(); 

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{
					ACS_SecondaryWeaponSwitch(); 

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
							
					thePlayer.BreakPheromoneEffect();	
							
					ACS_SecondaryWeaponSwitch(); 	
							
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
					{
						geraltRandomAxeSpecialAttackAlt();
					}
					else
					{
						geraltRandomAxeSpecialAttack();
					}
				}
			}
		}
	}

	function ACS_SCAAR_16_Installed(): bool{return theGame.GetDLCManager().IsDLCAvailable('dlc_windcloud');}

	function HybridModeAxeSpecialAttack()
	{
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	
					ACS_SecondaryWeaponSwitch(); 

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
							
					thePlayer.BreakPheromoneEffect();		

					ACS_SecondaryWeaponSwitch();
							
					geraltRandomAxeSpecialAttack();
				}
			}
		}
	}

	function HybridModeAxeForwardSpecialAttack()
	{
		if (
		ccompEnabled
		&& ACS_AttitudeCheck (actor) && actor.IsHuman()
		&& FinisherDistanceCheck()
		)
		{
			if ( actor.HasBuff( EET_HeavyKnockdown )  
			|| actor.HasBuff( EET_Knockdown ) 
			|| actor.HasBuff( EET_Ragdoll ) )
			{
				ACS_SecondaryWeaponSwitch();

				ACS_Setup_Combat_Action_Light();
			}
			else
			{
				//ACS_Dodge();
				action_interrupt();

				ACS_SecondaryWeaponSwitch();

				thePlayer.SetPlayerTarget( actor );cancel_npc_animation(); thePlayer.AddTimer( 'PerformFinisher', 0.0 );
			}
		}
		else
		{
			if ( ACS_can_perform_special_attack() )
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& StaminaCheck()
				)
				{	 
					ACS_SecondaryWeaponSwitch();

					thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_special_attack_cooldown();
							
					thePlayer.BreakPheromoneEffect();	
							
					ACS_SecondaryWeaponSwitch();
							
					geraltRandomAxeSpecialAttackAlt();
				}
			}
		}
	}

		
	// Dodge stuff
	
	function dodge_timer_actual() 
	{ 
		thePlayer.StopEffect('dive_shape');

		thePlayer.RemoveTag('ACS_Bruxa_Jump_End');

		RemoveTimer('ACS_dodge_timer_end');

		if( thePlayer.IsAlive() && thePlayer.IsInCombat() ){ thePlayer.SetVisibility( true ); }		 

		if (!thePlayer.HasTag('ACS_HideWeaponOnDodge'))
		{
			thePlayer.AddTag('ACS_HideWeaponOnDodge');
		}

		if (!thePlayer.HasTag('ACS_Camo_Active'))
		{
			thePlayer.StopEffect( 'magic_step_l' );	
			thePlayer.PlayEffect( 'magic_step_l' );

			thePlayer.StopEffect( 'magic_step_r' );	
			thePlayer.PlayEffect( 'magic_step_r' );
		}

		thePlayer.SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 
		thePlayer.SetCanPlayHitAnim(false); 
		thePlayer.EnableCharacterCollisions(false); 
		thePlayer.AddBuffImmunity_AllNegative('acs_dodge', true); 
		thePlayer.SetIsCurrentlyDodging(true);

		if (!thePlayer.HasTag('aard_sword_equipped'))
		{
			ACS_Weapon_Invisible();
		}

		thePlayer.BlockAction( EIAB_Jump, 			'ACS_Dodge_Timer');
	
		AddTimer('ACS_dodge_timer_end', 0.875  / theGame.GetTimeScale(), false);
	}
	
	function dodge_timer_wildhunt_actual() 
	{ 
		thePlayer.StopEffect('dive_shape');

		thePlayer.RemoveTag('ACS_Bruxa_Jump_End');

		RemoveTimer('ACS_dodge_timer_end');

		MovementAdjust();

		victimPos = actor.PredictWorldPosition(0.35) + VecFromHeading( AngleNormalize180( thePlayer.GetHeading() - dist ) ) * 2;
		if( !theGame.GetWorld().NavigationFindSafeSpot( victimPos, 0.3, 0.3 , newVictimPos ) )
		{
			theGame.GetWorld().NavigationFindSafeSpot( victimPos, 0.3, 3 , newVictimPos );
			victimPos = newVictimPos;
		}

		thePlayer.RemoveTag('ACS_HideWeaponOnDodge');

		if ( thePlayer.HasTag('ACS_Bruxa_Jump_Init') )
		{
			if (!thePlayer.HasTag('ACS_Camo_Active'))
			{
				thePlayer.StopAllEffects();
			}

			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_jump_up_stop_failsafe_ACS', 'PLAYER_SLOT', settings);

			thePlayer.RemoveTag('ACS_Bruxa_Jump_Init');

			thePlayer.AddTag('ACS_Bruxa_Jump_End');
		} 

		thePlayer.SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 
		thePlayer.SetCanPlayHitAnim(false); 
		thePlayer.SetVisibility( false ); 
		thePlayer.EnableCharacterCollisions(false);	
		thePlayer.AddBuffImmunity_AllNegative('acs_dodge', true); 
		thePlayer.SetIsCurrentlyDodging(true);

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			UpdateHeading(); 
			
			movementAdjustor.RotateTowards( ticket, actor );

			movementAdjustor.SlideTo( ticket, victimPos );
		}

		thePlayer.BlockAction( EIAB_Jump, 			'ACS_Dodge_Timer');

		AddTimer('ACS_dodge_timer_end', 0.75  / theGame.GetTimeScale(), false);
	}
	
	function dodge_timer_slideback_actual() 
	{ 
		thePlayer.StopEffect('dive_shape');

		thePlayer.RemoveTag('ACS_Bruxa_Jump_End');

		RemoveTimer('ACS_dodge_timer_end');

		if( thePlayer.IsAlive() && thePlayer.IsInCombat() ){ thePlayer.SetVisibility( true ); }		 

		if (!thePlayer.HasTag('ACS_HideWeaponOnDodge'))
		{
			thePlayer.AddTag('ACS_HideWeaponOnDodge');
		}

		if (!thePlayer.HasTag('ACS_Camo_Active'))
		{
			thePlayer.StopEffect( 'magic_step_l' );	
			thePlayer.PlayEffect( 'magic_step_l' );

			thePlayer.StopEffect( 'magic_step_r' );	
			thePlayer.PlayEffect( 'magic_step_r' );
		}

		thePlayer.SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 
		thePlayer.SetCanPlayHitAnim(false); 
		thePlayer.EnableCharacterCollisions(false);	
		thePlayer.AddBuffImmunity_AllNegative('acs_dodge', true); 
		thePlayer.SetIsCurrentlyDodging(true);

		if (!thePlayer.HasTag('aard_sword_equipped'))
		{
			ACS_Weapon_Invisible();
		}

		//thePlayer.BlockAction( EIAB_Jump, 			'ACS_Dodge_Timer');

		AddTimer('ACS_dodge_timer_end', 1.75  / theGame.GetTimeScale(), false);
	}
	
	function dodge_timer_attack_actual() 
	{ 
		thePlayer.StopEffect('dive_shape');

		thePlayer.RemoveTag('ACS_Bruxa_Jump_End');

		//thePlayer.RemoveTag('ACS_HideWeaponOnDodge');

		RemoveTimer('ACS_dodge_timer_end');

		if( thePlayer.IsAlive() && thePlayer.IsInCombat() ){ thePlayer.SetVisibility( true ); }		 

		if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
		{
			thePlayer.StopEffect( 'magic_step_l' );	
			thePlayer.PlayEffect( 'magic_step_l' );

			thePlayer.StopEffect( 'magic_step_r' );	
			thePlayer.PlayEffect( 'magic_step_r' );

			thePlayer.PlayEffect( 'bruxa_dash_trails' );
			thePlayer.StopEffect( 'bruxa_dash_trails' );
		}

		thePlayer.SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 
		thePlayer.SetCanPlayHitAnim(false); 
		//thePlayer.EnableCharacterCollisions(false);
		thePlayer.AddBuffImmunity_AllNegative('acs_dodge', true); 
		thePlayer.SetIsCurrentlyDodging(true);

		thePlayer.BlockAction( EIAB_Jump, 			'ACS_Dodge_Timer');

		AddTimer('ACS_dodge_timer_end', 1  / theGame.GetTimeScale(), false);
	}

	function ACS_SCAAR_15_Installed(): bool{return theGame.GetDLCManager().IsDLCAvailable('dlc_netflixarmor');}
	
	function dodge_timer_end_actual() 
	{ 
		thePlayer.UnblockAction( EIAB_Jump, 			'ACS_Dodge_Timer');

		//thePlayer.ClearAnimationSpeedMultipliers();
		
		MovementAdjust();

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			movementAdjustor.RotateTowards( ticket, actor );  
		}

		if (!thePlayer.HasTag('ACS_Camo_Active') && !thePlayer.HasTag('in_wraith'))
		{
			thePlayer.StopAllEffects();
		}

		if ( !thePlayer.HasTag('ACS_Camo_Active') && thePlayer.HasTag('ACS_Bruxa_Jump_End') && thePlayer.HasTag('aard_sword_equipped') )
		{
			thePlayer.StopEffect('dive_shape');
			thePlayer.PlayEffect('dive_shape');
			thePlayer.StopEffect('dive_shape');

			//thePlayer.PlayEffect('dive_smoke');
			//thePlayer.StopEffect('dive_smoke');

			thePlayer.RemoveTag('ACS_Bruxa_Jump_End');
		} 

		if( thePlayer.IsAlive() && thePlayer.IsInCombat() ){ thePlayer.SetVisibility( true ); }		 

		if (!thePlayer.HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
		{
			thePlayer.StopEffect( 'magic_step_l' );	
			thePlayer.PlayEffect( 'magic_step_l' );

			thePlayer.StopEffect( 'magic_step_r' );	
			thePlayer.PlayEffect( 'magic_step_r' );
		}

		thePlayer.SetImmortalityMode( AIM_None, AIC_Combat ); 

		thePlayer.SetCanPlayHitAnim(true); 

		thePlayer.EnableCharacterCollisions(true); 
		thePlayer.RemoveBuffImmunity_AllNegative('acs_dodge'); 
		thePlayer.SetIsCurrentlyDodging(false);

		if ( thePlayer.HasTag('ACS_HideWeaponOnDodge') 
		//&& !thePlayer.HasTag('blood_sucking')
		)
		{
			if (!thePlayer.HasTag('aard_sword_equipped'))
			{
				ACS_Weapon_Respawn();
			}
			
			thePlayer.RemoveTag('ACS_HideWeaponOnDodge');

			thePlayer.RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
		}

		if ( thePlayer.HasTag('ACS_wildhunt_teleport_init') )
		{
			ACS_wh_teleport_entity().CreateAttachment(thePlayer);

			thePlayer.SoundEvent("magic_canaris_teleport_short");

			ACS_wh_teleport_entity().StopEffect('disappear');
			ACS_wh_teleport_entity().PlayEffect('disappear');

			ACS_wh_teleport_entity().PlayEffect('appear');

			ACS_wh_teleport_entity().DestroyAfter(1);

			thePlayer.RemoveTag('ACS_wildhunt_teleport_init');
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// Bruxa bite stuff
	
	function bruxa_bite () 
	{ 
		if ( ACS_BruxaBite_Enabled() 
		&& ACS_Enabled() )
		{
			thePlayer.DrainStamina(ESAT_LightAttack);
			
			MovementAdjust();
			
			thePlayer.SoundEvent("monster_dettlaff_monster_construct_whoosh_claws_large");
			
			if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat()) 
			{ 
				movementAdjustor.RotateTowards( ticket, actor );  
				
				thePlayer.EnableCollisions(false);
				
				movementAdjustor.SlideTowards( ticket, actor, dist, dist ); 
				
				bruxa_bite_index_1 = RandDifferent(this.previous_bruxa_bite_index_1 , 2);
				
				switch (bruxa_bite_index_1) 
				{	
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_bite_back_rp_bruxa_ACS', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_bite_back_lp_bruxa_ACS', 'PLAYER_SLOT', settings);
					break;		
				}
				
				this.previous_bruxa_bite_index_1 = bruxa_bite_index_1;
				
				/*
				if (thePlayer.HasTag('blood_sucking'))
				{
					thePlayer.BreakAttachment();
					thePlayer.SetIsCurrentlyDodging(false);
					RemoveTimer('ACS_bruxa_blood_suck_repeat');	
					RemoveTimer('ACS_blood_suck_victim_paralyze');
					bruxa_blood_suck_end_actual();
				}
				else
				{
					*/
					bruxa_blood_suck_actual();
				//}
			}
		}
	}
	
	function bruxa_blood_suck_actual()
	{	
		actor = (CActor)( thePlayer.GetDisplayTarget() );
		
		victimRot = actor.GetWorldRotation();
		
		playerPos = thePlayer.GetWorldPosition();
		
		playerRot = thePlayer.GetWorldRotation();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			thePlayer.AddTag('blood_sucking');

			actor.AddTag('bruxa_bite_victim');

			ACS_Hijack_Marker_Create();

			if (!thePlayer.HasTag('ACS_HideWeaponOnDodge'))
			{
				thePlayer.AddTag('ACS_HideWeaponOnDodge');
			}

			if (!thePlayer.HasTag('aard_sword_equipped'))
			{
				ACS_Weapon_Invisible();
			}

			thePlayer.BreakAttachment();
			
			thePlayer.SetImmortalityMode( AIM_Invulnerable, AIC_Combat );
			thePlayer.SetCanPlayHitAnim(false);
			thePlayer.EnableCharacterCollisions(false);

			((CNewNPC)actor).EnableCharacterCollisions(false);

			//thePlayer.EnableCollisions(false);

			if ( ((CNewNPC)actor).IsFlying() && actor.GetDistanceFromGround( 3 ) > 2 )
			{
				/*
				if (actor.HasAbility('mon_gryphon_base'))
				{
					
					bonePos = actor.GetBoneWorldPosition('neck3');

					bonePos.X += 0.25;
					bonePos.Y += 0.1625;
					bonePos.Z -= 1.15;

					thePlayer.CreateAttachmentAtBoneWS( actor, 'neck3', bonePos, victimRot );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;

					thePlayer.CreateAttachment( ACS_Hijack_Marker_Get(), ,  attach_vec, attach_rot);
					

					actor.GetBoneWorldPositionAndRotationByIndex( actor.GetBoneIndex( 'neck2' ), bone_vec, bone_rot );

					bone_rot.Roll = 0;
					bone_rot.Pitch = 0;
					bone_rot.Yaw = 45;
					bone_vec.X += 0.25;
					bone_vec.Y += 0.1625;
					bone_vec.Z -= 1.15;

					//thePlayer.CreateAttachmentAtBoneWS( actor, 'neck2', bone_vec, bone_rot );

					thePlayer.CreateAttachment( actor, , Vector( 0, -2.5, -2.5 ), victimRot );
				}
				else if (npc.HasAbility('mon_basilisk'))
				{
					bonePos = actor.GetBoneWorldPosition('neck2');

					bonePos.X += 0.25;
					bonePos.Y += 0.1625;
					bonePos.Z -= 1.15;

					thePlayer.CreateAttachmentAtBoneWS( actor, 'neck2', bonePos, victimRot );
				}
				else if (actor.HasAbility('mon_siren_base'))
				{
					bonePos = actor.GetBoneWorldPosition('torso2');

					bonePos.X += 0.25;
					bonePos.Y += 0.1625;
					bonePos.Z -= 1.15;

					thePlayer.CreateAttachmentAtBoneWS( actor, 'torso2', bonePos, victimRot );
				}
				else if (actor.HasAbility('mon_wyvern_base'))
				{
					bonePos = actor.GetBoneWorldPosition('spine3');

					bonePos.X += 0.25;
					bonePos.Y += 0.1625;
					bonePos.Z -= 1.15;

					thePlayer.CreateAttachmentAtBoneWS( actor, 'spine3', bonePos, victimRot );
				}
				else if (actor.HasAbility('mon_harpy_base'))
				{
					bonePos = actor.GetBoneWorldPosition('torso2');

					bonePos.X += 0.25;
					bonePos.Y += 0.1625;
					bonePos.Z -= 1.15;

					thePlayer.CreateAttachmentAtBoneWS( actor, 'torso2', bonePos, victimRot );
				}
				else if (actor.HasAbility('mon_draco_base'))
				{
					bonePos = actor.GetBoneWorldPosition('spine2');

					bonePos.X += 0;
					bonePos.Y += 2.1625;
					bonePos.Z -= 0;

					thePlayer.CreateAttachment( actor, 'spine2', bonePos, victimRot );
				}	
				else
				{
					thePlayer.CreateAttachment( actor, , Vector( 0, 0, 0 ), victimRot );
				}
				*/
				thePlayer.CreateAttachment( actor, , Vector( 0, -5, -2.5 ) );

				if( thePlayer.IsAlive() && thePlayer.IsInCombat() ){ thePlayer.SetVisibility( true ); }	
			}
			else if (!((CNewNPC)npc).IsFlying()
			&& (npc.HasAbility('mon_garkain')
			|| npc.HasAbility('mon_sharley_base')
			|| npc.HasAbility('mon_bies_base')
			|| npc.HasAbility('mon_golem_base')
			|| npc.HasAbility('mon_endriaga_base')
			|| npc.HasAbility('mon_arachas_base')
			|| npc.HasAbility('mon_kikimore_base')
			|| npc.HasAbility('mon_black_spider_base')
			|| npc.HasAbility('mon_black_spider_ep2_base')
			|| npc.HasAbility('mon_ice_giant')
			|| npc.HasAbility('mon_cyclops')
			|| npc.HasAbility('mon_knight_giant')
			|| npc.HasAbility('mon_cloud_giant')
			|| npc.HasAbility('mon_troll_base')))
			{
				thePlayer.CreateAttachment( actor, , Vector( 0, 0, 0 ) );

				thePlayer.SetVisibility( false ); 

				((CNewNPC)actor).SetImmortalityMode( AIM_Invulnerable, AIC_Combat );
			}
			else
			{
				thePlayer.CreateAttachment( actor, , Vector( 0, 0, 0 ) );

				if( thePlayer.IsAlive() && thePlayer.IsInCombat() ){ thePlayer.SetVisibility( true ); }		 

				((CNewNPC)actor).SetImmortalityMode( AIM_Invulnerable, AIC_Combat );
			}
			
			thePlayer.SetIsCurrentlyDodging(true);
			
			AddTimer('ACS_bruxa_blood_suck_repeat', 2 / theGame.GetTimeScale(), true);	
				
			AddTimer('ACS_blood_suck_victim_paralyze', 0.001  / theGame.GetTimeScale(), true);	

			thePlayer.BlockAction( EIAB_Crossbow, 			'ACS_Bruxa_Bite');
			thePlayer.BlockAction( EIAB_CallHorse,			'ACS_Bruxa_Bite');
			thePlayer.BlockAction( EIAB_Signs, 				'ACS_Bruxa_Bite');
			thePlayer.BlockAction( EIAB_DrawWeapon, 		'ACS_Bruxa_Bite'); 
			thePlayer.BlockAction( EIAB_FastTravel, 		'ACS_Bruxa_Bite');
			thePlayer.BlockAction( EIAB_Fists, 				'ACS_Bruxa_Bite');
			thePlayer.BlockAction( EIAB_InteractionAction, 	'ACS_Bruxa_Bite');
			thePlayer.BlockAction( EIAB_UsableItem,			'ACS_Bruxa_Bite');
			thePlayer.BlockAction( EIAB_ThrowBomb,			'ACS_Bruxa_Bite');
			thePlayer.BlockAction( EIAB_SwordAttack,		'ACS_Bruxa_Bite');
			thePlayer.BlockAction( EIAB_Jump,				'ACS_Bruxa_Bite');
			thePlayer.BlockAction( EIAB_LightAttacks,		'ACS_Bruxa_Bite');
			thePlayer.BlockAction( EIAB_HeavyAttacks,		'ACS_Bruxa_Bite');
			thePlayer.BlockAction( EIAB_SpecialAttackLight,	'ACS_Bruxa_Bite');
			thePlayer.BlockAction( EIAB_SpecialAttackHeavy,	'ACS_Bruxa_Bite');
			thePlayer.BlockAction( EIAB_Dodge,				'ACS_Bruxa_Bite');
			thePlayer.BlockAction( EIAB_Roll,				'ACS_Bruxa_Bite');
			thePlayer.BlockAction( EIAB_Parry,				'ACS_Bruxa_Bite');
			thePlayer.BlockAction( EIAB_MeditationWaiting,	'ACS_Bruxa_Bite');
			thePlayer.BlockAction( EIAB_OpenMeditation,		'ACS_Bruxa_Bite');
			thePlayer.BlockAction( EIAB_RadialMenu,			'ACS_Bruxa_Bite');
		}
		/*
		else
		{
			thePlayer.UnblockAction( EIAB_Crossbow, 			'ACS_Bruxa_Bite');
			thePlayer.UnblockAction( EIAB_CallHorse,			'ACS_Bruxa_Bite');
			thePlayer.UnblockAction( EIAB_Signs, 				'ACS_Bruxa_Bite');
			thePlayer.UnblockAction( EIAB_DrawWeapon, 			'ACS_Bruxa_Bite'); 
			thePlayer.UnblockAction( EIAB_FastTravel, 			'ACS_Bruxa_Bite');
			thePlayer.UnblockAction( EIAB_Fists, 				'ACS_Bruxa_Bite');
			thePlayer.UnblockAction( EIAB_InteractionAction, 	'ACS_Bruxa_Bite');
			thePlayer.UnblockAction( EIAB_UsableItem,			'ACS_Bruxa_Bite');
			thePlayer.UnblockAction( EIAB_ThrowBomb,			'ACS_Bruxa_Bite');
			thePlayer.UnblockAction( EIAB_SwordAttack,			'ACS_Bruxa_Bite');
			thePlayer.UnblockAction( EIAB_Jump,					'ACS_Bruxa_Bite');
			thePlayer.UnblockAction( EIAB_LightAttacks,			'ACS_Bruxa_Bite');
			thePlayer.UnblockAction( EIAB_HeavyAttacks,			'ACS_Bruxa_Bite');
			thePlayer.UnblockAction( EIAB_SpecialAttackLight,	'ACS_Bruxa_Bite');
			thePlayer.UnblockAction( EIAB_SpecialAttackHeavy,	'ACS_Bruxa_Bite');
			thePlayer.UnblockAction( EIAB_Dodge,				'ACS_Bruxa_Bite');
			thePlayer.UnblockAction( EIAB_Roll,					'ACS_Bruxa_Bite');
			thePlayer.UnblockAction( EIAB_Parry,				'ACS_Bruxa_Bite');
			thePlayer.UnblockAction( EIAB_MeditationWaiting,	'ACS_Bruxa_Bite');
			thePlayer.UnblockAction( EIAB_OpenMeditation,		'ACS_Bruxa_Bite');
			thePlayer.UnblockAction( EIAB_RadialMenu,			'ACS_Bruxa_Bite');

			thePlayer.BreakAttachment();
			thePlayer.SetIsCurrentlyDodging(false);
			thePlayer.EnableCollisions(true);
			RemoveTimer('ACS_bruxa_blood_suck_repeat');	
			RemoveTimer('ACS_blood_suck_victim_paralyze');
			if( thePlayer.IsAlive() && thePlayer.IsInCombat() ){ thePlayer.SetVisibility( true ); }		 
			bruxa_blood_suck_end_actual();
		}
		*/
	}
	
	function blood_suck_victim_paralyze_actual()
	{
		var bonePos										: Vector;

		MovementAdjust();

		settings_SMOOTH.blendIn = 0.15f;
		settings_SMOOTH.blendOut = 1.0f;

		settings_interrupt.blendIn = 0;
		settings_interrupt.blendOut = 0;

		actors = GetActorsInRange( thePlayer, 10, 10, 'bruxa_bite_victim' );

		//theGame.GetActorsByTag( 'bruxa_bite_victim', actors );

		//actors = thePlayer.GetNPCsAndPlayersInRange( 10, 10);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				if (actor.IsAlive())
				{
					npc = (CNewNPC)actors[i];

					actor = actors[i];

					animatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	

					if (npc.HasTag('bruxa_bite_victim'))
					{
						if (((CNewNPC)npc).IsFlying() && actor.GetDistanceFromGround( 3 ) > 2)
						{
							if (thePlayer.HasTag('ACS_Hijack_Flight_End'))
							{
								thePlayer.BreakAttachment();

								thePlayer.CreateAttachment( actor, , Vector( 0, -5, -2.5 ) );

								thePlayer.RemoveTag('ACS_Hijack_Flight_End');
							}

							movementAdjustor.RotateTo( ticket, VecHeading(npc.GetHeadingVector()) );

							((CNewNPC)npc).SetUnstoppable(true);

							thePlayer.StopEffect('mind_control');	

							thePlayer.PlayEffect('mind_control', ACS_Hijack_Marker_2_Get());
							thePlayer.PlayEffect('mind_control', ACS_Hijack_Marker_2_Get());
							thePlayer.PlayEffect('mind_control', ACS_Hijack_Marker_2_Get());
							thePlayer.PlayEffect('mind_control', ACS_Hijack_Marker_2_Get());
							thePlayer.PlayEffect('mind_control', ACS_Hijack_Marker_2_Get());
							thePlayer.PlayEffect('mind_control', ACS_Hijack_Marker_2_Get());
							/*
							thePlayer.PlayEffect('mind_control', npc);
							thePlayer.PlayEffect('mind_control', npc);
							thePlayer.PlayEffect('mind_control', npc);
							thePlayer.PlayEffect('mind_control', npc);
							thePlayer.PlayEffect('mind_control', npc);
							thePlayer.PlayEffect('mind_control', npc);
							*/
							thePlayer.StopEffect('mind_control');	

							thePlayer.StopEffect('blood_drain'); 
							thePlayer.StopEffect('blood_start');

							//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_petard2_horse_idle_aim_cycle', 'PLAYER_SLOT', settings_SMOOTH);

							thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'swim_slow_f_ACS', 'PLAYER_SLOT', settings_SMOOTH);
						}
						else if (!((CNewNPC)npc).IsFlying()
						&& (npc.HasAbility('mon_garkain')
						|| npc.HasAbility('mon_sharley_base')
						|| npc.HasAbility('mon_bies_base')
						|| npc.HasAbility('mon_golem_base')
						|| npc.HasAbility('mon_endriaga_base')
						|| npc.HasAbility('mon_arachas_base')
						|| npc.HasAbility('mon_kikimore_base')
						|| npc.HasAbility('mon_black_spider_base')
						|| npc.HasAbility('mon_black_spider_ep2_base')
						|| npc.HasAbility('mon_ice_giant')
						|| npc.HasAbility('mon_cyclops')
						|| npc.HasAbility('mon_knight_giant')
						|| npc.HasAbility('mon_cloud_giant')
						|| npc.HasAbility('mon_troll_base')))
						{
							thePlayer.SetVisibility( false ); 

							if(!npc.HasTag('ACS_demonic_possession'))
							{
								npc.StopEffect('demonic_possession');
								npc.PlayEffect('demonic_possession');

								thePlayer.PlayEffect('ethereal_buff');
								thePlayer.StopEffect('ethereal_buff');

								thePlayer.PlayEffect('ethereal_debuff');
								thePlayer.StopEffect('ethereal_debuff');

								npc.AddTag('ACS_demonic_possession');
							}

							movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

							thePlayer.BreakAttachment();
							thePlayer.CreateAttachment( npc, , Vector( 0, 0, 0 ) );

							thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_petard2_horse_idle_aim_cycle', 'PLAYER_SLOT', settings_SMOOTH);

							((CNewNPC)npc).SetUnstoppable(false);

							if( !npc.HasBuff( EET_Confusion ) )
							{
								npc.AddEffectDefault( EET_Confusion, npc, 'console' );	
							}
						}
						else
						{
							if (npc.HasAbility('mon_gryphon_base')
							|| npc.HasAbility('mon_siren_base')
							|| npc.HasAbility('mon_wyvern_base')
							|| npc.HasAbility('mon_harpy_base')
							|| npc.HasAbility('mon_draco_base')
							|| npc.HasAbility('mon_basilisk')
							)
							{
								RemoveTimer('ACS_HijackMoveForward');	
							}  

							npc.BlockAbility('ShadowForm', true);
							npc.BlockAbility('MistForm', true);
							npc.BlockAbility('MistCharge', true);
							npc.BlockAbility('Flashstep', true);
							npc.BlockAbility('DustCloud', true);
							npc.BlockAbility('Specter', true);
							npc.BlockAbility('ContactBlindness', true);
							npc.BlockAbility('Summon', true);
							//npc.BlockAbility('mon_noonwraith  ', true);
							
							thePlayer.BreakAttachment();
							thePlayer.CreateAttachment( npc, , Vector( 0, 0, 0 ) );

							thePlayer.SetVisibility( true );

							if (!thePlayer.HasTag('ACS_HideWeaponOnDodge'))
							{
								thePlayer.AddTag('ACS_HideWeaponOnDodge');
							}

							if (!thePlayer.HasTag('aard_sword_equipped'))
							{
								ACS_Weapon_Invisible();
							}

							if (!thePlayer.HasTag('ACS_Hijack_Flight_End'))
							{
								thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_bite_back_rp_bruxa_ACS', 'PLAYER_SLOT', settings_SMOOTH);

								thePlayer.AddTag('ACS_Hijack_Flight_End');
							}

							((CNewNPC)npc).SetUnstoppable(false);

							if( !npc.HasBuff( EET_Confusion ) )
							{
								npc.AddEffectDefault( EET_Confusion, npc, 'console' );	
							}

							if( !npc.HasBuff( EET_Immobilized ) )
							{
								npc.AddEffectDefault( EET_Immobilized, npc, 'console' );	
							}

							if( !npc.HasBuff( EET_LongStagger ) )
							{
								npc.AddEffectDefault( EET_LongStagger, npc, 'console' );	
							}

							if( !npc.HasBuff( EET_Slowdown ) )
							{
								//npc.AddEffectDefault( EET_Slowdown, npc, 'console' );	
							}
						}

						npc.StopEffect('focus_sound_red_fx');
					}
				}
				else
				{
					bruxa_blood_suck_end_actual();
				}		
			}
		}
	}
	
	function alive_check_actual()
	{
		if (thePlayer.HasTag('yrden_secondary_sword_equipped'))
		{
			ACS_Giant_Lightning_Strike_Single();
		}
		else if (thePlayer.HasTag('acs_bow_active'))
		{

		}
		else if (thePlayer.HasTag('acs_crossbow_active'))
		{
			
		}
	}
	
	function bruxa_blood_suck_repeat_actual()
	{
		settings_SMOOTH.blendIn = 0.15f;
		settings_SMOOTH.blendOut = 1.0f;
		
		actors = GetActorsInRange(thePlayer, 10, 10, 'bruxa_bite_victim');

		//theGame.GetActorsByTag( 'bruxa_bite_victim', actors );

		//actors = thePlayer.GetNPCsAndPlayersInRange( 10, 10);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				if (npc.IsAlive() && npc.HasTag('bruxa_bite_victim'))
				{
					((CNewNPC)npc).SetImmortalityMode( AIM_None, AIC_Combat ); 

					npc.RemoveBuff(EET_HeavyKnockdown, true, 'console');

					npc.RemoveBuffImmunity_AllNegative();

					npc.RemoveBuffImmunity_AllCritical();
					
					if 
					(
					!((CNewNPC)npc).IsFlying()
					&& !npc.HasAbility('mon_garkain')
					&& !npc.HasAbility('mon_sharley_base')
					&& !npc.HasAbility('mon_bies_base')
					&& !npc.HasAbility('mon_golem_base')
					&& !npc.HasAbility('mon_endriaga_base')
					&& !npc.HasAbility('mon_arachas_base')
					&& !npc.HasAbility('mon_kikimore_base')
					&& !npc.HasAbility('mon_black_spider_base')
					&& !npc.HasAbility('mon_black_spider_ep2_base')
					&& !npc.HasAbility('mon_ice_giant')
					&& !npc.HasAbility('mon_cyclops')
					&& !npc.HasAbility('mon_knight_giant')
					&& !npc.HasAbility('mon_cloud_giant')
					&& !npc.HasAbility('mon_troll_base')
					)
					{
						if (npc.HasAbility('mon_gryphon_base')
						|| npc.HasAbility('mon_siren_base')
						|| npc.HasAbility('mon_wyvern_base')
						|| npc.HasAbility('mon_harpy_base')
						|| npc.HasAbility('mon_draco_base')
						|| npc.HasAbility('mon_basilisk')
						)
						{
							RemoveTimer('ACS_HijackMoveForward');	
						}

						if (thePlayer.HasTag('ACS_Hijack_Flight_End'))
						{
							thePlayer.RemoveTag('ACS_Hijack_Flight_End');
						}

						thePlayer.SoundEvent("monster_dettlaff_monster_construct_whoosh_claws_large");

						thePlayer.PlayEffect( 'blood_drain_fx2' ); 
						thePlayer.StopEffect( 'blood_drain_fx2' );

						ACS_bruxa_blood_resource();

						thePlayer.SetVisibility( true );

						if (npc.UsesVitality()) 
						{ 
							curTargetVitality = actor.GetStat( BCS_Vitality );

							damageMax = curTargetVitality * 0.10; 
							
							damageMin = curTargetVitality * 0.05; 

							if( curTargetVitality <= actor.GetStatMax( BCS_Vitality ) * 0.1 )
							{
								npc.Kill('ACS_Bruxa_Bite', thePlayer);

								VampVoiceEffects_Monster();

								thePlayer.AddEffectDefault( EET_WellFed, thePlayer, 'ACS_Bruxa_Bite' );

								thePlayer.AddEffectDefault( EET_WellHydrated, thePlayer, 'ACS_Bruxa_Bite' );

								thePlayer.AddEffectDefault( EET_AutoStaminaRegen, thePlayer, 'ACS_Bruxa_Bite' );
							}
							else
							{
								npc.ForceSetStat( BCS_Vitality,  curTargetVitality - RandRangeF(damageMax,damageMin) );
							}
						} 
						else if (npc.UsesEssence()) 
						{ 
							curTargetEssence = actor.GetStat( BCS_Essence );
							
							damageMax = curTargetEssence * 0.20; 
							
							damageMin = curTargetEssence * 0.10; 

							if( curTargetEssence <= actor.GetStatMax( BCS_Essence ) * 0.1 )
							{
								npc.Kill('ACS_Bruxa_Bite', thePlayer);

								VampVoiceEffects_Monster();

								thePlayer.AddEffectDefault( EET_WellFed, thePlayer, 'ACS_Bruxa_Bite' );

								thePlayer.AddEffectDefault( EET_WellHydrated, thePlayer, 'ACS_Bruxa_Bite' );

								thePlayer.AddEffectDefault( EET_AutoStaminaRegen, thePlayer, 'ACS_Bruxa_Bite' );
							}
							else
							{
								npc.ForceSetStat( BCS_Essence,  curTargetEssence - RandRangeF(damageMax,damageMin) );
							}
						}

						thePlayer.GainStat( BCS_Vitality, RandRangeF(thePlayer.GetStatMax( BCS_Vitality ) * 0.1, thePlayer.GetStatMax( BCS_Vitality ) * 0.05)  ); 

						bruxa_bite_repeat_index_1 = RandDifferent(this.previous_bruxa_bite_repeat_index_1 , 2);

						switch (bruxa_bite_repeat_index_1) 
						{			
							case 1:	
							thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_bite_back_rp_bruxa_ACS', 'PLAYER_SLOT', settings);
							break;
							
							default:
							thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_bite_back_lp_bruxa_ACS', 'PLAYER_SLOT', settings);
							break;		
						}			
						this.previous_bruxa_bite_repeat_index_1 = bruxa_bite_repeat_index_1;
					}
				}
				else
				{
					bruxa_blood_suck_end_actual();
				}
			}
		}
	}
	
	function bruxa_tackle_actual()
	{
		/*
		actors = GetActorsInRange(thePlayer, 10, 10, 'bruxa_bite_victim', true);
		
		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];
			actor = (CActor)actors[i];
			if( actors.Size() > 0 )
			{
				if( RandF() < 0.10 ) 
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_quest_eating_body_loop_ACS', 'PLAYER_SLOT', settings);
					
					if (!((CNewNPC)npc).IsFlying())
					{
						npc.AddEffectDefault( EET_HeavyKnockdown, npc, 'console' );	
					}
				}
				else
				{	
					if (!((CNewNPC)npc).IsFlying())
					{
						if( !npc.HasBuff( EET_Confusion ) )
						{
							npc.AddEffectDefault( EET_Confusion, npc, 'console' );	
						}
					}
				}
			}
		}
		*/

		if (thePlayer.HasTag('quen_sword_equipped'))
		{
			ACS_ThingsThatShouldBeRemoved();

			thePlayer.SetIsCurrentlyDodging(true);

			actor = (CActor)( thePlayer.GetTarget() );	

			movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

			targetDistance = VecDistanceSquared2D( thePlayer.GetWorldPosition(), actor.GetWorldPosition() ) ;
			
			movementAdjustor.CancelAll();

			dodge_timer_attack_actual();

			ticket = movementAdjustor.CreateNewRequest( 'ACS_Movement_Adjust_Shadowdash' );
		
			movementAdjustor.AdjustmentDuration( ticket, 0.5 );
			
			//movementAdjustor.ShouldStartAt(ticket, thePlayer.GetWorldPosition());

			movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

			movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
			
			movementAdjustor.AdjustLocationVertically( ticket, true );

			movementAdjustor.ScaleAnimationLocationVertically( ticket, true );

			dist = (((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
			+ ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent()).GetCapsuleRadius()) * 1.25;

			thePlayer.ClearAnimationSpeedMultipliers();
									
			if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
			
			AddTimer('ACS_ResetAnimation', 0.75 / theGame.GetTimeScale() , false);

			quen_sword_glow();	

			thePlayer.AddTag('ACS_Shadow_Dash_Empowered');

			if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
			{
				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );

					//thePlayer.EnableCollisions(false);

					movementAdjustor.SlideTowards( ticket, actor, dist, dist );

					//AddTimer('ACS_collision_delay', 0.4, false);
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  

						//thePlayer.EnableCollisions(false);

						movementAdjustor.SlideTowards( ticket, actor, dist, dist );

						//AddTimer('ACS_collision_delay', 0.4, false);
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

						//thePlayer.EnableCollisions(false);

						//AddTimer('ACS_collision_delay', 0.4, false);

						movementAdjustor.SlideTo( ticket, thePlayer.GetWorldPosition() + theCamera.GetCameraDirection() * 5 );
					}
				}

				if( targetDistance <= 4*4 ) 
				{
					olgierd_shadow_attack_part_2_index_1 = RandDifferent(this.previous_olgierd_shadow_attack_part_2_index_1 , 2);

					switch (olgierd_shadow_attack_part_2_index_1) 
					{	
						case 1:
						thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowdash_strong_2_ACS', 'PLAYER_SLOT', settings);
						break;
						
						default:
						thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowdash_002_ACS', 'PLAYER_SLOT', settings);
						break;
					}

					this.previous_olgierd_shadow_attack_part_2_index_1 = olgierd_shadow_attack_part_2_index_1;
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowdash_002_ACS', 'PLAYER_SLOT', settings);
				}
			
				//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowdash_002_ACS', 'PLAYER_SLOT', settings);
			}
			else
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

				//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowdash_002_ACS', 'PLAYER_SLOT', settings);

				olgierd_shadow_attack_part_2_index_1 = RandDifferent(this.previous_olgierd_shadow_attack_part_2_index_1 , 2);

				switch (olgierd_shadow_attack_part_2_index_1) 
				{	
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowdash_strong_2_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowdash_002_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_olgierd_shadow_attack_part_2_index_1 = olgierd_shadow_attack_part_2_index_1;
			}
		}
		else if (thePlayer.HasTag('axii_sword_equipped'))
		{
			if (thePlayer.HasTag('ACS_Eredin_Stab'))
			{
				actors = thePlayer.GetNPCsAndPlayersInCone(2.5, VecHeading(thePlayer.GetHeadingVector()), 60, 20, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

				for( i = 0; i < actors.Size(); i += 1 )
				{
					actortarget = (CActor)actors[i];

					actortarget.SoundEvent("cmb_play_ger_stab_in");

					if ( actortarget.HasTag('ACS_Stabbed') )
					continue;

					if( !actortarget.HasBuff( EET_Confusion ) && !actortarget.HasBuff( EET_HeavyKnockdown ) && !actortarget.HasBuff( EET_Knockdown ) && !actortarget.HasBuff( EET_Ragdoll ) && actortarget.IsAlive() )
					{
						actortarget.SoundEvent("cmb_play_ger_stab_in");

						actortarget.AddEffectDefault( EET_Confusion, actortarget, 'ACS_Stabbed' );	

						actortarget.CreateAttachment( thePlayer, , Vector( 0.25, 1.5, 0.25 ) );

						actortarget.AddTag('ACS_Stabbed');
					}
				}

				thePlayer.RemoveTag('ACS_Eredin_Stab');
			}
		}
		else if (thePlayer.HasTag('aard_sword_equipped'))
		{
			ACS_ThingsThatShouldBeRemoved();

			thePlayer.SetIsCurrentlyDodging(true);

			actor = (CActor)( thePlayer.GetTarget() );	

			movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

			targetDistance = VecDistanceSquared2D( thePlayer.GetWorldPosition(), actor.GetWorldPosition() ) ;
			
			movementAdjustor.CancelAll();

			dodge_timer_attack_actual();

			ticket = movementAdjustor.CreateNewRequest( 'ACS_Movement_Adjust_Aard_Sword_Dash' );
		
			movementAdjustor.AdjustmentDuration( ticket, 0.325 );
			
			//movementAdjustor.ShouldStartAt(ticket, thePlayer.GetWorldPosition());

			movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

			movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
			
			movementAdjustor.AdjustLocationVertically( ticket, true );

			movementAdjustor.ScaleAnimationLocationVertically( ticket, true );

			distVampSpecialDash = (((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
			+ ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent()).GetCapsuleRadius());

			thePlayer.ClearAnimationSpeedMultipliers();

			if (thePlayer.HasTag('ACS_Whirl_Attack'))
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_03_ACS', 'PLAYER_SLOT', settings);

				thePlayer.RemoveTag('ACS_Whirl_Attack');	
			}
			else
			{						
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 1.5 / theGame.GetTimeScale() ); }	
				
				AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);
			}

			if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
			{
				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );

					movementAdjustor.SlideTowards( ticket, actor, distVampSpecialDash, distVampSpecialDash );
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  

						movementAdjustor.SlideTowards( ticket, actor, distVampSpecialDash, distVampSpecialDash );
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

						movementAdjustor.SlideTo( ticket, thePlayer.GetWorldPosition() + theCamera.GetCameraDirection() * 5 );
					}
				}
			}
			else
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			}
		}
		else if (thePlayer.HasTag('vampire_claws_equipped'))
		{
			ACS_ThingsThatShouldBeRemoved();

			thePlayer.SetIsCurrentlyDodging(true);

			actor = (CActor)( thePlayer.GetTarget() );	

			movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

			targetDistance = VecDistanceSquared2D( thePlayer.GetWorldPosition(), actor.GetWorldPosition() ) ;
			
			movementAdjustor.CancelAll();

			dodge_timer_attack_actual();

			ticket = movementAdjustor.CreateNewRequest( 'ACS_Movement_Adjust_Vampire_Claw_Dash' );
		
			movementAdjustor.AdjustmentDuration( ticket, 0.325 );
			
			//movementAdjustor.ShouldStartAt(ticket, thePlayer.GetWorldPosition());

			movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

			movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
			
			movementAdjustor.AdjustLocationVertically( ticket, true );

			movementAdjustor.ScaleAnimationLocationVertically( ticket, true );

			distVampSpecialDash = (((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
			+ ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent()).GetCapsuleRadius()) * 0.75;

			thePlayer.ClearAnimationSpeedMultipliers();
									
			if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 1.5 / theGame.GetTimeScale() ); }	
			
			AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);

			if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
			{
				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );

					movementAdjustor.SlideTowards( ticket, actor, distVampSpecialDash, distVampSpecialDash );
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  

						movementAdjustor.SlideTowards( ticket, actor, distVampSpecialDash, distVampSpecialDash );
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

						movementAdjustor.SlideTo( ticket, thePlayer.GetWorldPosition() + theCamera.GetCameraDirection() * 5 );
					}
				}
			}
		}
	}

	function vampire_fist_slide()
	{
		ACS_ThingsThatShouldBeRemoved();

		RemoveTimer('ACS_collision_delay');

		actor = (CActor)( thePlayer.GetTarget() );	

		movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

		targetDistance = VecDistanceSquared2D( thePlayer.GetWorldPosition(), actor.GetWorldPosition() ) ;
		
		//movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACS_Movement_Adjust_Vampire_Dash' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.5 );
		
		//movementAdjustor.ShouldStartAt(ticket, thePlayer.GetWorldPosition());

		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.AdjustLocationVertically( ticket, true );

		movementAdjustor.ScaleAnimationLocationVertically( ticket, true );

		distVampSpecialDash = (((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
		+ ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent()).GetCapsuleRadius()) * 0.5;

		thePlayer.ClearAnimationSpeedMultipliers();
								
		if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
		
		AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);

		dodge_timer_attack_actual();

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );

				//thePlayer.EnableCollisions(false);
				movementAdjustor.SlideTowards( ticket, actor, distVampSpecialDash, distVampSpecialDash );
				//AddTimer('ACS_collision_delay', 0.4, false);
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  

					//thePlayer.EnableCollisions(false);
					movementAdjustor.SlideTowards( ticket, actor, distVampSpecialDash, distVampSpecialDash );
					//AddTimer('ACS_collision_delay', 0.4, false);
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

					//thePlayer.EnableCollisions(false);

					//AddTimer('ACS_collision_delay', 0.4, false);

					movementAdjustor.SlideTo( ticket, thePlayer.GetWorldPosition() + theCamera.GetCameraDirection() * 5 );
				}
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
		}

	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	function bruxa_blood_suck_end_actual() 
	{ 
		thePlayer.RemoveTag('blood_sucking');

		thePlayer.SetVisibility( true );	 

		thePlayer.StopEffect('mind_control');	

		thePlayer.UnblockAction( EIAB_Crossbow, 			'ACS_Bruxa_Bite' );
		thePlayer.UnblockAction( EIAB_ThrowBomb, 			'ACS_Bruxa_Bite' );
		thePlayer.UnblockAction( EIAB_CallHorse,			'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_Signs, 				'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_DrawWeapon, 			'ACS_Bruxa_Bite'); 
		thePlayer.UnblockAction( EIAB_FastTravel, 			'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_Fists, 				'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_InteractionAction, 	'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_UsableItem,			'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_SwordAttack,			'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_Jump,					'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_LightAttacks,			'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_HeavyAttacks,			'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_SpecialAttackLight,	'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_SpecialAttackHeavy,	'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_Dodge,				'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_Roll,					'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_Parry,				'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_MeditationWaiting,	'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_OpenMeditation,		'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_RadialMenu,			'ACS_Bruxa_Bite');

		RemoveTimer('ACS_HijackMoveForward');

		ACS_Hijack_Marker_Destroy();

		ACS_Hijack_Marker_2_Destroy();

		thePlayer.BreakAttachment();
		
		RemoveTimer('ACS_bruxa_blood_suck');	
		RemoveTimer('ACS_bruxa_blood_suck_repeat');
		RemoveTimer('ACS_blood_suck_victim_paralyze');

		thePlayer.StopEffect('blood_drain'); 
		thePlayer.StopEffect('blood_start');	 
		thePlayer.SetImmortalityMode( AIM_None, AIC_Combat ); 

		thePlayer.SetCanPlayHitAnim(true); 

		thePlayer.EnableCharacterCollisions(true); 
		thePlayer.SetIsCurrentlyDodging(false);
		thePlayer.EnableCollisions(true);

		if (thePlayer.HasTag('ACS_Hijack_Flight_End'))
		{
			thePlayer.RemoveTag('ACS_Hijack_Flight_End');
		}
		
		actors = GetActorsInRange(thePlayer, 10, 10, 'bruxa_bite_victim');

		//theGame.GetActorsByTag( 'bruxa_bite_victim', actors );

		//actors = thePlayer.GetNPCsAndPlayersInRange( 10, 10);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				NPCanimatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	

				settingsNPC.blendIn = 0.f;
				settingsNPC.blendOut = 0.f;

				actor = actors[i];

				if (npc.HasTag('bruxa_bite_victim'))
				{
					npc.SetImmortalityMode( AIM_None, AIC_Combat ); 

					npc.StopEffect('demonic_possession');

					thePlayer.PlayEffect('dive_shape');
					thePlayer.StopEffect('dive_shape');

					//thePlayer.PlayEffect('dive_smoke');
					//thePlayer.StopEffect('dive_smoke');

					npc.RemoveBuff(EET_Confusion);

					npc.RemoveBuff(EET_Immobilized);

					npc.RemoveBuff(EET_LongStagger);

					npc.RemoveBuff(EET_Slowdown);

					actor.RemoveBuffImmunity_AllNegative();

					actor.RemoveBuffImmunity_AllCritical();

					npc.RemoveBuffImmunity_AllNegative();

					npc.RemoveBuffImmunity_AllCritical();

					((CNewNPC)npc).SetUnstoppable(false);

					NPCanimatedComponent.PlaySlotAnimationAsync ( '', 'NPC_ANIM_SLOT', settingsNPC);

					npc.RemoveTag('Hijack_Marker_Added');

					npc.RemoveTag('ACS_demonic_possession');

					npc.RemoveTag('bruxa_bite_victim');
				}
			}
		}
		
		jump_attack_reset(); 
	}
	
	function jump_attack_reset()
	{	
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			movementAdjustor.RotateTowards( ticket, actor );  
			
			movementAdjustor.SlideTowards( ticket, actor, distJump, distJump );
			
			AddTimer('ACS_collision_delay', 0.1  / theGame.GetTimeScale(), false);
			
			if (thePlayer.HasTag('vampire_claws_equipped'))
			{
				thePlayer.SoundEvent("monster_dettlaff_monster_combat_construct_dash_vfx");

				thePlayer.SoundEvent("monster_dettlaff_monster_construct_whoosh_claws_large");

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_jump_up_attack_ACS', 'PLAYER_SLOT', settings);
			}
			else
			{
				thePlayer.SoundEvent("monster_dettlaff_monster_combat_construct_dash_vfx");

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_jump_up_stop_ACS', 'PLAYER_SLOT', settings);
			}
		}
		else
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			if (thePlayer.HasTag('vampire_claws_equipped'))
			{
				thePlayer.SoundEvent("monster_dettlaff_monster_combat_construct_dash_vfx");

				thePlayer.SoundEvent("monster_dettlaff_monster_construct_whoosh_claws_large");

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_jump_up_attack_ACS', 'PLAYER_SLOT', settings);
			}
			else
			{
				thePlayer.SoundEvent("monster_dettlaff_monster_combat_construct_dash_vfx");

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_jump_up_stop_ACS', 'PLAYER_SLOT', settings);
			}
			
			AddTimer('ACS_collision_delay', 0.1  / theGame.GetTimeScale(), false);
		}
	}
	
	function bruxa_blood_suck_end_no_jump_actual() 
	{ 
		thePlayer.RemoveTag('blood_sucking'); 

		thePlayer.SetVisibility( true ); 

		thePlayer.StopEffect('mind_control');	

		thePlayer.UnblockAction( EIAB_Crossbow, 			'ACS_Bruxa_Bite' );
		thePlayer.UnblockAction( EIAB_ThrowBomb, 			'ACS_Bruxa_Bite' );
		thePlayer.UnblockAction( EIAB_CallHorse,			'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_Signs, 				'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_DrawWeapon, 			'ACS_Bruxa_Bite'); 
		thePlayer.UnblockAction( EIAB_FastTravel, 			'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_Fists, 				'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_InteractionAction, 	'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_UsableItem,			'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_SwordAttack,			'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_Jump,					'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_LightAttacks,			'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_HeavyAttacks,			'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_SpecialAttackLight,	'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_SpecialAttackHeavy,	'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_Dodge,				'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_Roll,					'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_Parry,				'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_MeditationWaiting,	'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_OpenMeditation,		'ACS_Bruxa_Bite');
		thePlayer.UnblockAction( EIAB_RadialMenu,			'ACS_Bruxa_Bite');

		RemoveTimer('ACS_HijackMoveForward');

		ACS_Hijack_Marker_Destroy();

		ACS_Hijack_Marker_2_Destroy();

		thePlayer.BreakAttachment(); 
		
		RemoveTimer('ACS_bruxa_blood_suck');	
		RemoveTimer('ACS_bruxa_blood_suck_repeat');	 
		RemoveTimer('ACS_blood_suck_victim_paralyze'); 
		
		thePlayer.StopEffect('blood_drain'); 
		thePlayer.StopEffect('blood_start');
		thePlayer.SetImmortalityMode( AIM_None, AIC_Combat ); 

		thePlayer.SetCanPlayHitAnim(true); 
		
		AddTimer('ACS_collision_delay', 0.1 / theGame.GetTimeScale(), false);
		thePlayer.EnableCharacterCollisions(true); 
		thePlayer.SetIsCurrentlyDodging(false);
		thePlayer.EnableCollisions(true);

		if (thePlayer.HasTag('ACS_Hijack_Flight_End'))
		{
			thePlayer.RemoveTag('ACS_Hijack_Flight_End');
		}
		
		actors = GetActorsInRange(thePlayer, 10, 10, 'bruxa_bite_victim');

		//actors = thePlayer.GetNPCsAndPlayersInRange( 10, 10);

		//theGame.GetActorsByTag( 'bruxa_bite_victim', actors );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				NPCanimatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	

				settingsNPC.blendIn = 0.f;
				settingsNPC.blendOut = 0.f;

				actor = actors[i];

				if (npc.HasTag('bruxa_bite_victim'))
				{
					npc.SetImmortalityMode( AIM_None, AIC_Combat ); 

					npc.StopEffect('demonic_possession');

					thePlayer.PlayEffect('dive_shape');
					thePlayer.StopEffect('dive_shape');

					//thePlayer.PlayEffect('dive_smoke');
					//thePlayer.StopEffect('dive_smoke');

					npc.RemoveBuff(EET_Confusion);

					npc.RemoveBuff(EET_Immobilized);

					npc.RemoveBuff(EET_LongStagger);

					npc.RemoveBuff(EET_Slowdown);

					actor.RemoveBuffImmunity_AllNegative();

					actor.RemoveBuffImmunity_AllCritical();

					npc.RemoveBuffImmunity_AllNegative();

					npc.RemoveBuffImmunity_AllCritical();

					((CNewNPC)npc).SetUnstoppable(false);

					NPCanimatedComponent.PlaySlotAnimationAsync ( '', 'NPC_ANIM_SLOT', settingsNPC);

					npc.RemoveTag('Hijack_Marker_Added');

					npc.RemoveTag('ACS_demonic_possession');

					npc.RemoveTag('bruxa_bite_victim');
				}
			}
		}
	}

	function ACS_SCAAR_14_Installed(): bool{return theGame.GetDLCManager().IsDLCAvailable('dlc_geraltsuit');}

	function HijackMoveForwardActual()
	{
		//MovementAdjust();

		theGame.GetActorsByTag( 'bruxa_bite_victim', actors );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];
					
				NPCanimatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	
					
				//settingsNPC.blendIn = 0.2f;
				settingsNPC.blendIn = 0.5f;
				settingsNPC.blendOut = 1.0f;

				victimMovementAdjustor = npc.GetMovingAgentComponent().GetMovementAdjustor();
		
				victimMovementAdjustor.CancelAll();
				
				victimTicket = victimMovementAdjustor.CreateNewRequest( 'ACS_Victim_Movement_Adjust' );

				((CNewNPC)npc).SetUnstoppable(true);

				npc.RemoveBuffImmunity_AllNegative();

				npc.RemoveBuffImmunity_AllCritical();
				
				/*
				if (npc.HasAbility('mon_gryphon_base'))
				{
					NPCanimatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_glide_f', 'NPC_ANIM_SLOT', settingsNPC);
				}
				else if (npc.HasAbility('mon_siren_base'))
				{
					NPCanimatedComponent.PlaySlotAnimationAsync ( 'monster_siren_fly_fast_glide_f', 'NPC_ANIM_SLOT', settingsNPC);
				}
				else if (npc.HasAbility('mon_wyvern_base'))
				{
					NPCanimatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_fwd', 'NPC_ANIM_SLOT', settingsNPC);
				}
				else if (npc.HasAbility('mon_harpy_base'))
				{
					NPCanimatedComponent.PlaySlotAnimationAsync ( 'monster_harpy_fly_fast_glide_f', 'NPC_ANIM_SLOT', settingsNPC);
				}
				else if (npc.HasAbility('mon_draco_base'))
				{
					NPCanimatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_fwd', 'NPC_ANIM_SLOT', settingsNPC);
				}	
				else if (npc.HasAbility('mon_basilisk'))
				{
					NPCanimatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_glide_f', 'NPC_ANIM_SLOT', settingsNPC);
				}
				*/

				if (npc.HasAbility('mon_garkain'))
				{
					NPCanimatedComponent.PlaySlotAnimationAsync ( 'monster_werewolf_run_f', 'NPC_ANIM_SLOT', settingsNPC);

					victimMovementAdjustor.AdjustmentDuration( victimTicket, 0.5 );
					victimMovementAdjustor.MaxLocationAdjustmentSpeed( victimTicket, 50000 );
				}
				else if (npc.HasAbility('mon_sharley_base'))
				{
					NPCanimatedComponent.PlaySlotAnimationAsync ( 'roll_forward', 'NPC_ANIM_SLOT', settingsNPC);

					victimMovementAdjustor.AdjustmentDuration( victimTicket, 0.5 );
					victimMovementAdjustor.MaxLocationAdjustmentSpeed( victimTicket, 50000 );
				}
				else if (npc.HasAbility('mon_bies_base'))
				{
					NPCanimatedComponent.PlaySlotAnimationAsync ( 'monster_bies_charge', 'NPC_ANIM_SLOT', settingsNPC);

					victimMovementAdjustor.AdjustmentDuration( victimTicket, 0.5 );
					victimMovementAdjustor.MaxLocationAdjustmentSpeed( victimTicket, 0.1 );
				}
				else if (npc.HasAbility('mon_golem_base'))
				{
					NPCanimatedComponent.PlaySlotAnimationAsync ( 'monster_elemental_attack_charge', 'NPC_ANIM_SLOT', settingsNPC);

					victimMovementAdjustor.AdjustmentDuration( victimTicket, 0.5 );
					victimMovementAdjustor.MaxLocationAdjustmentSpeed( victimTicket, 0.1 );
				}
				else if (npc.HasAbility('mon_endriaga_base')
				|| npc.HasAbility('mon_arachas_base')
				|| npc.HasAbility('mon_kikimore_base')
				|| npc.HasAbility('mon_black_spider_base')
				|| npc.HasAbility('mon_black_spider_ep2_base'))
				{
					//NPCanimatedComponent.PlaySlotAnimationAsync ( 'monster_archas_move_walk_f', 'NPC_ANIM_SLOT', settingsNPC);
					NPCanimatedComponent.PlaySlotAnimationAsync ( 'monster_arachas_attack_special_jump', 'NPC_ANIM_SLOT', settingsNPC);

					victimMovementAdjustor.AdjustmentDuration( victimTicket, 0.5 );
					victimMovementAdjustor.MaxLocationAdjustmentSpeed( victimTicket, 0.1 );
				}
				else if (
				npc.HasAbility('mon_ice_giant')
				|| npc.HasAbility('mon_cyclops')
				|| npc.HasAbility('mon_knight_giant')
				|| npc.HasAbility('mon_cloud_giant')
				)
				{
					NPCanimatedComponent.PlaySlotAnimationAsync ( 'giant_combat_walk', 'NPC_ANIM_SLOT', settingsNPC);

					victimMovementAdjustor.AdjustmentDuration( victimTicket, 0.5 );
					victimMovementAdjustor.MaxLocationAdjustmentSpeed( victimTicket, 0.1 );
				}
				else if (npc.HasAbility('mon_troll_base'))
				{
					NPCanimatedComponent.PlaySlotAnimationAsync ( 'monster_cave_troll_run', 'NPC_ANIM_SLOT', settingsNPC);

					victimMovementAdjustor.AdjustmentDuration( victimTicket, 0.5 );
					victimMovementAdjustor.MaxLocationAdjustmentSpeed( victimTicket, 0.1 );
				}
				else
				{
					victimMovementAdjustor.AdjustmentDuration( victimTicket, 0.15 );
				}

				victimMovementAdjustor.ShouldStartAt(victimTicket, npc.GetWorldPosition());
				victimMovementAdjustor.MaxRotationAdjustmentSpeed( victimTicket, 50000 );
				victimMovementAdjustor.AdjustLocationVertically( victimTicket, true );
				victimMovementAdjustor.ScaleAnimationLocationVertically( victimTicket, true );

				victimMovementAdjustor.RotateTo( victimTicket, VecHeading( theCamera.GetCameraDirection() ) );

				//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

				npc.ClearAnimationSpeedMultipliers();

				if (npc.HasAbility('mon_gryphon_base')
				|| npc.HasAbility('mon_siren_base')
				|| npc.HasAbility('mon_wyvern_base')
				|| npc.HasAbility('mon_harpy_base')
				|| npc.HasAbility('mon_draco_base')
				|| npc.HasAbility('mon_basilisk')
				)
				{
					if (theInput.GetActionValue('GI_AxisLeftX') == 0)
					{
						if (theInput.GetActionValue('Sprint') != 0 )
						{
							//victimMovementAdjustor.SlideTo( victimTicket, theCamera.GetCameraPosition() + theCamera.GetCameraUp() * -1.5 + theCamera.GetCameraForward() * 5 + theCamera.GetCameraDirection() * 5 );
							victimMovementAdjustor.SlideTo( victimTicket, npc.GetWorldPosition() + npc.GetWorldUp() * 1.5 + npc.GetWorldForward() * 5 );
						}
						else
						{
							//victimMovementAdjustor.SlideTo( victimTicket, theCamera.GetCameraPosition() + theCamera.GetCameraUp() * -1.5 + theCamera.GetCameraForward() * 1.5 + theCamera.GetCameraDirection() * 1.5 );
							victimMovementAdjustor.SlideTo( victimTicket, npc.GetWorldPosition() + npc.GetWorldUp() * 0.25 + npc.GetWorldForward() * 2.5 );
						}
					}
					else if (theInput.GetActionValue('GI_AxisLeftX') != 0)
					{
						if (theInput.GetActionValue('Sprint') != 0 )
						{
							//victimMovementAdjustor.SlideTo( victimTicket, theCamera.GetCameraPosition() + theCamera.GetCameraUp() * -4 + theCamera.GetCameraForward() * 5 + theCamera.GetCameraDirection() * 5 );
							victimMovementAdjustor.SlideTo( victimTicket, npc.GetWorldPosition() + npc.GetWorldUp() * -2.5 + npc.GetWorldForward() * 5 );
						}
						else
						{
							//victimMovementAdjustor.SlideTo( victimTicket, theCamera.GetCameraPosition() + theCamera.GetCameraUp() * -4 + theCamera.GetCameraForward() * 4 + theCamera.GetCameraDirection() * 1.5 );
							victimMovementAdjustor.SlideTo( victimTicket, npc.GetWorldPosition() + npc.GetWorldUp() * -1.5 + npc.GetWorldForward() * 2.5 );
						}
					}
				}
				else
				{
					if (theInput.GetActionValue('Sprint') != 0 )
					{
						//victimMovementAdjustor.SlideTo( victimTicket, theCamera.GetCameraPosition() + theCamera.GetCameraUp() * -1.5 + theCamera.GetCameraForward() * 5 + theCamera.GetCameraDirection() * 5 );
						victimMovementAdjustor.SlideTo( victimTicket, npc.GetWorldPosition() + npc.GetWorldForward() * 10 );
					}
					else
					{
						//victimMovementAdjustor.SlideTo( victimTicket, theCamera.GetCameraPosition() + theCamera.GetCameraUp() * -1.5 + theCamera.GetCameraForward() * 1.5 + theCamera.GetCameraDirection() * 1.5 );
						victimMovementAdjustor.SlideTo( victimTicket, npc.GetWorldPosition() + npc.GetWorldForward() * 5 );
					}
				}
			
			}
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// Bruxa Dash
	
	/* Bruxa Dash For Sprint
	function BruxaDash()
	{
		if (CiriCheck()
		&& HitAnimCheck()
		&& FinisherCheck() 
		&& thePlayer.IsActionAllowed(EIAB_Movement)
		)
		{
			DeactivateThings_BruxaDash();

			ACS_ThingsThatShouldBeRemoved_NoWeaponRespawn();

			thePlayer.ClearAnimationSpeedMultipliers();	

			if( BruxaDashCallTime + DOUBLE_TAP_WINDOW >= theGame.GetEngineTimeAsSeconds() )
			{
				BruxaDashDoubleTap = true;
			}
			else
			{
				BruxaDashDoubleTap = false;	
			}
			
			if( BruxaDashDoubleTap )
			{
				if ( ACS_WraithMode_Enabled() && ACS_WraithModeInput() == 1 && !thePlayer.HasTag('in_wraith') )
				{
					if (!thePlayer.IsInCombat()) 
					{
						if (theGame.IsFocusModeActive())
						{
							if ( ACS_StaminaBlockAction_Enabled() 
							&& StaminaCheck()
							)
							{									 
								thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
							}
							else
							{
								thePlayer.AddTag('in_wraith');

								thePlayer.SoundEvent("magic_yennefer_necromancy_loop_start");
								thePlayer.SoundEvent("magic_yennefer_necromancy_loop_start");

								camera = (CCustomCamera)theCamera.GetTopmostCameraObject();

								camera.StopAnimation('camera_shake_loop_lvl1_1');

								theGame.GetGameCamera().StopAnimation( 'camera_shake_loop_lvl1_1' );

								camera.StopAnimation('camera_shake_loop_lvl1_5');

								theGame.GetGameCamera().StopAnimation( 'camera_shake_loop_lvl1_5' );

								thePlayer.BlockAction( EIAB_Crossbow, 			'ACS_Wraith');
								thePlayer.BlockAction( EIAB_CallHorse,			'ACS_Wraith');
								thePlayer.BlockAction( EIAB_Signs, 				'ACS_Wraith');
								thePlayer.BlockAction( EIAB_FastTravel, 		'ACS_Wraith');
								thePlayer.BlockAction( EIAB_Fists, 				'ACS_Wraith');
								thePlayer.BlockAction( EIAB_InteractionAction, 	'ACS_Wraith');
								thePlayer.BlockAction( EIAB_UsableItem,			'ACS_Wraith');
								thePlayer.BlockAction( EIAB_ThrowBomb,			'ACS_Wraith');
								thePlayer.BlockAction( EIAB_SwordAttack,		'ACS_Wraith');
								thePlayer.BlockAction( EIAB_LightAttacks,		'ACS_Wraith');
								thePlayer.BlockAction( EIAB_HeavyAttacks,		'ACS_Wraith');
								thePlayer.BlockAction( EIAB_SpecialAttackLight,	'ACS_Wraith');
								thePlayer.BlockAction( EIAB_SpecialAttackHeavy,	'ACS_Wraith');
								thePlayer.BlockAction( EIAB_Dodge,				'ACS_Wraith');
								thePlayer.BlockAction( EIAB_Roll,				'ACS_Wraith');
								thePlayer.BlockAction( EIAB_MeditationWaiting,	'ACS_Wraith');
								thePlayer.BlockAction( EIAB_OpenMeditation,		'ACS_Wraith');
								thePlayer.BlockAction( EIAB_RadialMenu,			'ACS_Wraith');
									
								if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
								{
									thePlayer.StopEffect('smoke_explosion');
									thePlayer.PlayEffect('smoke_explosion');

									thePlayer.StopEffect('suck_out');
									thePlayer.PlayEffect('suck_out');
								}

								else if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
								{
									thePlayer.StopEffect('smoke_explosion');
									thePlayer.PlayEffect('smoke_explosion');

									thePlayer.StopEffect('suck_out');
									thePlayer.PlayEffect('suck_out');
								}	
								else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
								{
									thePlayer.StopEffect('smoke_explosion');
									thePlayer.PlayEffect('smoke_explosion');

									thePlayer.StopEffect('suck_out');
									thePlayer.PlayEffect('suck_out');
								}	
								else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
								{
									thePlayer.StopEffect('smoke_explosion');
									thePlayer.PlayEffect('smoke_explosion');

									thePlayer.StopEffect('suck_out');
									thePlayer.PlayEffect('suck_out');
								}	
								else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5 && theInput.GetActionValue('GI_AxisLeftY') > 0.5)
								{
									thePlayer.StopEffect('smoke_explosion');
									thePlayer.PlayEffect('smoke_explosion');

									thePlayer.StopEffect('suck_out');
									thePlayer.PlayEffect('suck_out');
								}	
								else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5 && theInput.GetActionValue('GI_AxisLeftY') > 0.5)
								{
									thePlayer.StopEffect('smoke_explosion');
									thePlayer.PlayEffect('smoke_explosion');

									thePlayer.StopEffect('suck_out');
									thePlayer.PlayEffect('suck_out');
								}
										
								thePlayer.StopAllEffects();
									
								thePlayer.StopEffect('special_attack_short_fx');
								thePlayer.PlayEffect('special_attack_short_fx');

								thePlayer.EnableCollisions(false);
								thePlayer.EnableCharacterCollisions(false);
																
								AddTimer('ACS_wraith', 0.00000001, true);
							}
						}
					}
				}

				if (ACS_can_bruxa_dash()
				&& ACS_BruxaDash_Enabled() 
				&& !theGame.IsFocusModeActive())
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& StaminaCheck()
					&& !thePlayer.HasTag('in_wraith')
					)
					{	
						thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						thePlayer.SetIsCurrentlyDodging(true);

						thePlayer.EnableCharacterCollisions(false); 

						ACS_refresh_bruxa_dash_cooldown();

						if (thePlayer.HasTag('in_wraith'))
						{
							thePlayer.SoundEvent("magic_yennefer_necromancy_loop_stop");

							RemoveTimer('ACS_wraith');
		
							AddTimer('ACS_collision_delay', 0.3, false);

							thePlayer.StopEffect('special_attack_short_fx');

							thePlayer.UnblockAction( EIAB_Crossbow, 			'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_CallHorse,			'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_Signs, 				'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_FastTravel, 			'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_Fists, 				'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_InteractionAction, 	'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_UsableItem,			'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_ThrowBomb,			'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_SwordAttack,			'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_LightAttacks,			'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_HeavyAttacks,			'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_SpecialAttackLight,	'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_SpecialAttackHeavy,	'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_Dodge,				'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_Roll,					'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_MeditationWaiting,	'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_OpenMeditation,		'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_RadialMenu,			'ACS_Wraith');

							thePlayer.RemoveTag('in_wraith');
						}
						
						if( thePlayer.IsInCombat())
						{
							if (theInput.GetActionValue('GI_AxisLeftY') == 0)
							{
								if (!thePlayer.HasTag('ACS_Camo_Active')
								&& !thePlayer.HasTag('blood_sucking'))
								{
									thePlayer.PlayEffect( 'bruxa_dash_trails_backup' );
									thePlayer.StopEffect( 'bruxa_dash_trails_backup' );

									thePlayer.PlayEffect( 'shadowdash_short' );
									thePlayer.StopEffect( 'shadowdash_short' );
								}

								if (thePlayer.HasTag('blood_sucking'))
								{
									bruxa_blood_suck_end_no_jump_actual();
								}
								
								dodge_timer_actual();
									
								thePlayer.BreakAttachment();
															
								bruxa_dash();
							}
							else if (theInput.GetActionValue('GI_AxisLeftY') > 0.85
							&& ACS_Enabled()
							&& ACS_BruxaLeapAttack_Enabled())
							{	
								//thePlayer.SoundEvent("monster_dettlaff_monster_construct_whoosh_claws_large");
									
								if (!thePlayer.HasTag('ACS_Camo_Active')
								&& !thePlayer.HasTag('blood_sucking'))
								{
									thePlayer.PlayEffect( 'bruxa_dash_trails_backup' );
									thePlayer.StopEffect( 'bruxa_dash_trails_backup' );

									thePlayer.PlayEffect( 'shadowdash_short' );
									thePlayer.StopEffect( 'shadowdash_short' );
								}
		
								if (thePlayer.HasTag('blood_sucking'))
								{
									bruxa_blood_suck_end_no_jump_actual();
								}

								dodge_timer_actual();
													
								if (thePlayer.IsInAir())
								{	
									air_jump_attack();
								}
								else
								{
									jump_attack();
								}
							}	
						}
						else if (!thePlayer.IsInCombat())
						{		
							if (!thePlayer.HasTag('ACS_Camo_Active')
							&& !thePlayer.HasTag('blood_sucking'))
							{
								thePlayer.PlayEffect( 'bruxa_dash_trails_backup' );
								thePlayer.StopEffect( 'bruxa_dash_trails_backup' );

								thePlayer.PlayEffect( 'shadowdash_short' );
								thePlayer.StopEffect( 'shadowdash_short' );
							}
																							
							if (thePlayer.HasTag('blood_sucking'))
							{
								bruxa_blood_suck_end_no_jump_actual();
							}

							dodge_timer_actual();
								
							thePlayer.BreakAttachment();
															
							bruxa_dash();
						}
					}
				}
			}
			else
			{	
				thePlayer.SetSprintActionPressed(true);

				if ( thePlayer.HasTag('vampire_claws_equipped') )
				{
					if ( !thePlayer.HasTag('ACS_Camo_Active') && !thePlayer.HasTag('in_wraith') && !thePlayer.HasTag('blood_sucking') )
					{
						thePlayer.PlayEffect( 'magic_step_l' );
						thePlayer.StopEffect( 'magic_step_l' );	

						thePlayer.PlayEffect( 'magic_step_r' );
						thePlayer.StopEffect( 'magic_step_r' );	

						thePlayer.PlayEffect( 'bruxa_dash_trails' );
						thePlayer.StopEffect( 'bruxa_dash_trails' );

						thePlayer.PlayEffect( 'shadowdash_short' );
						thePlayer.StopEffect( 'shadowdash_short' );
					}
				}
						
				if ( thePlayer.rangedWeapon )
					thePlayer.rangedWeapon.OnSprintHolster();
				
				if ( ACS_WraithMode_Enabled() && ACS_WraithModeInput() == 0 && !thePlayer.HasTag('in_wraith') )
				{
					if (!thePlayer.IsInCombat()) 
					{
						if (theGame.IsFocusModeActive())
						{
							if ( ACS_StaminaBlockAction_Enabled() 
							&& StaminaCheck()
							)
							{									 
								thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
							}
							else
							{
								thePlayer.AddTag('in_wraith');

								camera.StopAnimation('camera_shake_loop_lvl1_1');

								theGame.GetGameCamera().StopAnimation( 'camera_shake_loop_lvl1_1' );

								camera.StopAnimation('camera_shake_loop_lvl1_5');

								theGame.GetGameCamera().StopAnimation( 'camera_shake_loop_lvl1_5' );

								thePlayer.BlockAction( EIAB_Crossbow, 			'ACS_Wraith');
								thePlayer.BlockAction( EIAB_CallHorse,			'ACS_Wraith');
								thePlayer.BlockAction( EIAB_Signs, 				'ACS_Wraith');
								thePlayer.BlockAction( EIAB_FastTravel, 		'ACS_Wraith');
								thePlayer.BlockAction( EIAB_Fists, 				'ACS_Wraith');
								thePlayer.BlockAction( EIAB_InteractionAction, 	'ACS_Wraith');
								thePlayer.BlockAction( EIAB_UsableItem,			'ACS_Wraith');
								thePlayer.BlockAction( EIAB_ThrowBomb,			'ACS_Wraith');
								thePlayer.BlockAction( EIAB_SwordAttack,		'ACS_Wraith');
								thePlayer.BlockAction( EIAB_LightAttacks,		'ACS_Wraith');
								thePlayer.BlockAction( EIAB_HeavyAttacks,		'ACS_Wraith');
								thePlayer.BlockAction( EIAB_SpecialAttackLight,	'ACS_Wraith');
								thePlayer.BlockAction( EIAB_SpecialAttackHeavy,	'ACS_Wraith');
								thePlayer.BlockAction( EIAB_Dodge,				'ACS_Wraith');
								thePlayer.BlockAction( EIAB_Roll,				'ACS_Wraith');
								thePlayer.BlockAction( EIAB_MeditationWaiting,	'ACS_Wraith');
								thePlayer.BlockAction( EIAB_OpenMeditation,		'ACS_Wraith');
								thePlayer.BlockAction( EIAB_RadialMenu,			'ACS_Wraith');
									
								if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
								{
									thePlayer.StopEffect('smoke_explosion');
									thePlayer.PlayEffect('smoke_explosion');

									thePlayer.StopEffect('suck_out');
									thePlayer.PlayEffect('suck_out');
								}

								else if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
								{
									thePlayer.StopEffect('smoke_explosion');
									thePlayer.PlayEffect('smoke_explosion');

									thePlayer.StopEffect('suck_out');
									thePlayer.PlayEffect('suck_out');
								}	
								else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
								{
									thePlayer.StopEffect('smoke_explosion');
									thePlayer.PlayEffect('smoke_explosion');

									thePlayer.StopEffect('suck_out');
									thePlayer.PlayEffect('suck_out');
								}	
								else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
								{
									thePlayer.StopEffect('smoke_explosion');
									thePlayer.PlayEffect('smoke_explosion');

									thePlayer.StopEffect('suck_out');
									thePlayer.PlayEffect('suck_out');
								}	
								else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5 && theInput.GetActionValue('GI_AxisLeftY') > 0.5)
								{
									thePlayer.StopEffect('smoke_explosion');
									thePlayer.PlayEffect('smoke_explosion');

									thePlayer.StopEffect('suck_out');
									thePlayer.PlayEffect('suck_out');
								}	
								else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5 && theInput.GetActionValue('GI_AxisLeftY') > 0.5)
								{
									thePlayer.StopEffect('smoke_explosion');
									thePlayer.PlayEffect('smoke_explosion');

									thePlayer.StopEffect('suck_out');
									thePlayer.PlayEffect('suck_out');
								}
										
								thePlayer.StopAllEffects();
									
								thePlayer.StopEffect('special_attack_short_fx');
								thePlayer.PlayEffect('special_attack_short_fx');

								thePlayer.EnableCollisions(false);
								thePlayer.EnableCharacterCollisions(false);
																
								AddTimer('ACS_wraith', 0.00000001, true);
							}
						}
					}
				}
			}

			DeactivateThings_BruxaDash();
			
			BruxaDashCallTime = theGame.GetEngineTimeAsSeconds();
		}
	}
	*/

	function JumpAttackCombat()
	{
		if (theInput.GetActionValue('Sprint') == 0 )
		{
			if (thePlayer.HasTag('in_wraith'))
			{
				thePlayer.SoundEvent("magic_yennefer_necromancy_loop_stop");

				RemoveTimer('ACS_wraith');

				AddTimer('ACS_collision_delay', 0.3, false);

				thePlayer.StopEffect('special_attack_short_fx');

				thePlayer.UnblockAction( EIAB_Crossbow, 			'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_CallHorse,			'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_Signs, 				'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_FastTravel, 			'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_Fists, 				'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_InteractionAction, 	'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_UsableItem,			'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_ThrowBomb,			'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_SwordAttack,			'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_LightAttacks,			'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_HeavyAttacks,			'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_SpecialAttackLight,	'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_SpecialAttackHeavy,	'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_Dodge,				'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_Roll,					'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_MeditationWaiting,	'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_OpenMeditation,		'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_RadialMenu,			'ACS_Wraith');

				thePlayer.RemoveTag('in_wraith');
			}

			if (ACS_Enabled())
			{
				if (ACS_BruxaLeapAttack_Enabled())
				{
					if (!thePlayer.HasTag('ACS_Camo_Active')
					&& !thePlayer.HasTag('blood_sucking'))
					{
						thePlayer.PlayEffect( 'bruxa_dash_trails_backup' );
						thePlayer.StopEffect( 'bruxa_dash_trails_backup' );

						thePlayer.PlayEffect( 'shadowdash_short' );
						thePlayer.StopEffect( 'shadowdash_short' );
					}

					if (thePlayer.HasTag('blood_sucking'))
					{
						bruxa_blood_suck_end_no_jump_actual();
					}

					dodge_timer_actual();
										
					if (thePlayer.IsInAir())
					{	
						air_jump_attack();
					}
					else
					{
						jump_attack();
					}
				}
				else
				{
					ACS_BruxaDodgeSlideBackInit();
				}
			}
			else
			{
				ACS_BruxaDodgeSlideBackInit();
			}
		}
	}

	function BruxaDash()
	{
		if (CiriCheck()
		&& HitAnimCheck()
		&& FinisherCheck() 
		&& thePlayer.IsActionAllowed(EIAB_Movement)
		)
		{
			DeactivateThings_BruxaDash();

			ACS_ThingsThatShouldBeRemoved_NoWeaponRespawn();

			thePlayer.ClearAnimationSpeedMultipliers();	

			if( BruxaDashCallTime + DOUBLE_TAP_WINDOW >= theGame.GetEngineTimeAsSeconds() )
			{
				BruxaDashDoubleTap = true;
			}
			else
			{
				BruxaDashDoubleTap = false;	
			}
			
			if( BruxaDashDoubleTap )
			{
				if ( ACS_WraithMode_Enabled() && ACS_WraithModeInput() == 1 && !thePlayer.HasTag('in_wraith') )
				{
					if (!thePlayer.IsInCombat()) 
					{
						if (theGame.IsFocusModeActive())
						{
							if ( ACS_StaminaBlockAction_Enabled() 
							&& StaminaCheck()
							)
							{									 
								thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
							}
							else
							{
								thePlayer.AddTag('in_wraith');

								thePlayer.SoundEvent("magic_yennefer_necromancy_loop_start");
								thePlayer.SoundEvent("magic_yennefer_necromancy_loop_start");

								camera = (CCustomCamera)theCamera.GetTopmostCameraObject();

								camera.StopAnimation('camera_shake_loop_lvl1_1');

								theGame.GetGameCamera().StopAnimation( 'camera_shake_loop_lvl1_1' );

								camera.StopAnimation('camera_shake_loop_lvl1_5');

								theGame.GetGameCamera().StopAnimation( 'camera_shake_loop_lvl1_5' );

								thePlayer.BlockAction( EIAB_Crossbow, 			'ACS_Wraith');
								thePlayer.BlockAction( EIAB_CallHorse,			'ACS_Wraith');
								thePlayer.BlockAction( EIAB_Signs, 				'ACS_Wraith');
								thePlayer.BlockAction( EIAB_FastTravel, 		'ACS_Wraith');
								thePlayer.BlockAction( EIAB_Fists, 				'ACS_Wraith');
								thePlayer.BlockAction( EIAB_InteractionAction, 	'ACS_Wraith');
								thePlayer.BlockAction( EIAB_UsableItem,			'ACS_Wraith');
								thePlayer.BlockAction( EIAB_ThrowBomb,			'ACS_Wraith');
								thePlayer.BlockAction( EIAB_SwordAttack,		'ACS_Wraith');
								thePlayer.BlockAction( EIAB_LightAttacks,		'ACS_Wraith');
								thePlayer.BlockAction( EIAB_HeavyAttacks,		'ACS_Wraith');
								thePlayer.BlockAction( EIAB_SpecialAttackLight,	'ACS_Wraith');
								thePlayer.BlockAction( EIAB_SpecialAttackHeavy,	'ACS_Wraith');
								thePlayer.BlockAction( EIAB_Dodge,				'ACS_Wraith');
								thePlayer.BlockAction( EIAB_Roll,				'ACS_Wraith');
								thePlayer.BlockAction( EIAB_MeditationWaiting,	'ACS_Wraith');
								thePlayer.BlockAction( EIAB_OpenMeditation,		'ACS_Wraith');
								thePlayer.BlockAction( EIAB_RadialMenu,			'ACS_Wraith');
										
								thePlayer.StopAllEffects();
									
								thePlayer.StopEffect('special_attack_short_fx');
								thePlayer.PlayEffect('special_attack_short_fx');

								thePlayer.EnableCollisions(false);
								thePlayer.EnableCharacterCollisions(false);
																
								AddTimer('ACS_wraith', 0.00000001, true);
							}
						}
					}
				}

				if (ACS_BruxaDash_Enabled() 
				&& !theGame.IsFocusModeActive()
				&& ACS_BruxaDashInput() == 1)
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& StaminaCheck()
					&& !thePlayer.HasTag('in_wraith')
					)
					{	
						thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
					}
					else if (ACS_can_bruxa_dash())
					{
						thePlayer.SetIsCurrentlyDodging(true);

						thePlayer.EnableCharacterCollisions(false); 

						ACS_refresh_bruxa_dash_cooldown();

						if (thePlayer.HasTag('in_wraith'))
						{
							thePlayer.SoundEvent("magic_yennefer_necromancy_loop_stop");

							RemoveTimer('ACS_wraith');
		
							AddTimer('ACS_collision_delay', 0.3, false);

							thePlayer.StopEffect('special_attack_short_fx');

							thePlayer.UnblockAction( EIAB_Crossbow, 			'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_CallHorse,			'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_Signs, 				'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_FastTravel, 			'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_Fists, 				'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_InteractionAction, 	'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_UsableItem,			'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_ThrowBomb,			'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_SwordAttack,			'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_LightAttacks,			'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_HeavyAttacks,			'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_SpecialAttackLight,	'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_SpecialAttackHeavy,	'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_Dodge,				'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_Roll,					'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_MeditationWaiting,	'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_OpenMeditation,		'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_RadialMenu,			'ACS_Wraith');

							thePlayer.RemoveTag('in_wraith');
						}

						if (!thePlayer.HasTag('ACS_Camo_Active')
						&& !thePlayer.HasTag('blood_sucking'))
						{
							thePlayer.PlayEffect( 'bruxa_dash_trails_backup' );
							thePlayer.StopEffect( 'bruxa_dash_trails_backup' );

							thePlayer.PlayEffect( 'shadowdash_short' );
							thePlayer.StopEffect( 'shadowdash_short' );
						}

						if (thePlayer.HasTag('blood_sucking'))
						{
							bruxa_blood_suck_end_no_jump_actual();
						}
						
						dodge_timer_actual();
							
						thePlayer.BreakAttachment();		

						bruxa_dash();						
					}
				}
			}
			else
			{	
				if ( thePlayer.HasTag('vampire_claws_equipped') )
				{
					if ( !thePlayer.HasTag('ACS_Camo_Active') && !thePlayer.HasTag('in_wraith') && !thePlayer.HasTag('blood_sucking') )
					{
						thePlayer.PlayEffect( 'magic_step_l' );
						thePlayer.StopEffect( 'magic_step_l' );	

						thePlayer.PlayEffect( 'magic_step_r' );
						thePlayer.StopEffect( 'magic_step_r' );	

						thePlayer.PlayEffect( 'bruxa_dash_trails' );
						thePlayer.StopEffect( 'bruxa_dash_trails' );

						thePlayer.PlayEffect( 'shadowdash_short' );
						thePlayer.StopEffect( 'shadowdash_short' );
					}
				}
				
				if ( ACS_WraithMode_Enabled() && ACS_WraithModeInput() == 0 && !thePlayer.HasTag('in_wraith') )
				{
					if (!thePlayer.IsInCombat()) 
					{
						if (theGame.IsFocusModeActive())
						{
							if ( ACS_StaminaBlockAction_Enabled() 
							&& StaminaCheck()
							)
							{									 
								thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
							}
							else
							{
								thePlayer.AddTag('in_wraith');

								camera.StopAnimation('camera_shake_loop_lvl1_1');

								theGame.GetGameCamera().StopAnimation( 'camera_shake_loop_lvl1_1' );

								camera.StopAnimation('camera_shake_loop_lvl1_5');

								theGame.GetGameCamera().StopAnimation( 'camera_shake_loop_lvl1_5' );

								thePlayer.BlockAction( EIAB_Crossbow, 			'ACS_Wraith');
								thePlayer.BlockAction( EIAB_CallHorse,			'ACS_Wraith');
								thePlayer.BlockAction( EIAB_Signs, 				'ACS_Wraith');
								thePlayer.BlockAction( EIAB_FastTravel, 		'ACS_Wraith');
								thePlayer.BlockAction( EIAB_Fists, 				'ACS_Wraith');
								thePlayer.BlockAction( EIAB_InteractionAction, 	'ACS_Wraith');
								thePlayer.BlockAction( EIAB_UsableItem,			'ACS_Wraith');
								thePlayer.BlockAction( EIAB_ThrowBomb,			'ACS_Wraith');
								thePlayer.BlockAction( EIAB_SwordAttack,		'ACS_Wraith');
								thePlayer.BlockAction( EIAB_LightAttacks,		'ACS_Wraith');
								thePlayer.BlockAction( EIAB_HeavyAttacks,		'ACS_Wraith');
								thePlayer.BlockAction( EIAB_SpecialAttackLight,	'ACS_Wraith');
								thePlayer.BlockAction( EIAB_SpecialAttackHeavy,	'ACS_Wraith');
								thePlayer.BlockAction( EIAB_Dodge,				'ACS_Wraith');
								thePlayer.BlockAction( EIAB_Roll,				'ACS_Wraith');
								thePlayer.BlockAction( EIAB_MeditationWaiting,	'ACS_Wraith');
								thePlayer.BlockAction( EIAB_OpenMeditation,		'ACS_Wraith');
								thePlayer.BlockAction( EIAB_RadialMenu,			'ACS_Wraith');
										
								thePlayer.StopAllEffects();
									
								thePlayer.StopEffect('special_attack_short_fx');
								thePlayer.PlayEffect('special_attack_short_fx');

								thePlayer.EnableCollisions(false);
								thePlayer.EnableCharacterCollisions(false);
																
								AddTimer('ACS_wraith', 0.00000001, true);
							}
						}
					}
				}

				if (ACS_BruxaDash_Enabled() 
				&& !theGame.IsFocusModeActive()
				&& ACS_BruxaDashInput() == 0)
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& StaminaCheck()
					&& !thePlayer.HasTag('in_wraith')
					)
					{	
						thePlayer.RaiseEvent( 'CombatTaunt' ); thePlayer.SoundEvent("gui_no_stamina");
					}
					else if (ACS_can_bruxa_dash())
					{
						thePlayer.SetIsCurrentlyDodging(true);

						thePlayer.EnableCharacterCollisions(false); 

						ACS_refresh_bruxa_dash_cooldown();

						if (thePlayer.HasTag('in_wraith'))
						{
							thePlayer.SoundEvent("magic_yennefer_necromancy_loop_stop");

							RemoveTimer('ACS_wraith');
		
							AddTimer('ACS_collision_delay', 0.3, false);

							thePlayer.StopEffect('special_attack_short_fx');

							thePlayer.UnblockAction( EIAB_Crossbow, 			'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_CallHorse,			'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_Signs, 				'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_FastTravel, 			'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_Fists, 				'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_InteractionAction, 	'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_UsableItem,			'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_ThrowBomb,			'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_SwordAttack,			'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_LightAttacks,			'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_HeavyAttacks,			'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_SpecialAttackLight,	'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_SpecialAttackHeavy,	'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_Dodge,				'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_Roll,					'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_MeditationWaiting,	'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_OpenMeditation,		'ACS_Wraith');
							thePlayer.UnblockAction( EIAB_RadialMenu,			'ACS_Wraith');

							thePlayer.RemoveTag('in_wraith');
						}

						if (!thePlayer.HasTag('ACS_Camo_Active')
						&& !thePlayer.HasTag('blood_sucking'))
						{
							thePlayer.PlayEffect( 'bruxa_dash_trails_backup' );
							thePlayer.StopEffect( 'bruxa_dash_trails_backup' );

							thePlayer.PlayEffect( 'shadowdash_short' );
							thePlayer.StopEffect( 'shadowdash_short' );
						}

						if (thePlayer.HasTag('blood_sucking'))
						{
							bruxa_blood_suck_end_no_jump_actual();
						}
						
						dodge_timer_actual();
							
						thePlayer.BreakAttachment();		

						bruxa_dash();						
					}
				}
			}

			DeactivateThings_BruxaDash();
			
			BruxaDashCallTime = theGame.GetEngineTimeAsSeconds();
		}
	}

	function bruxa_dash()
	{
		var dest1, dest2, dest3, dest4		: Vector;

		if (thePlayer.HasTag('ACS_Camo_Active'))
		{
			thePlayer.SoundEvent("monster_bruxa_combat_disappear");
		}
		
		if ( thePlayer.IsInInterior() )
		{	
			dest1 = thePlayer.GetWorldPosition() + (thePlayer.GetWorldRight() * (0-(ACS_BruxaDash_Combat_Distance()/4))) + thePlayer.GetWorldForward() * (ACS_BruxaDash_Combat_Distance()/2);
			
			dest2 = thePlayer.GetWorldPosition() + (thePlayer.GetWorldRight() * (ACS_BruxaDash_Combat_Distance()/4)) + thePlayer.GetWorldForward() * (ACS_BruxaDash_Combat_Distance()/2);
			
			dest3 = thePlayer.GetWorldPosition() + (thePlayer.GetWorldRight() * (0-(ACS_BruxaDash_Normal_Distance()/4))) + thePlayer.GetWorldForward() * (ACS_BruxaDash_Normal_Distance()/2);
			
			dest4 = thePlayer.GetWorldPosition() + (thePlayer.GetWorldRight() * (ACS_BruxaDash_Normal_Distance()/4)) + thePlayer.GetWorldForward() * (ACS_BruxaDash_Normal_Distance()/2);
		}
		else if (thePlayer.IsSwimming())
		{
			dest1 = theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * ACS_BruxaDash_Combat_Distance();
			
			dest2 = theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * ACS_BruxaDash_Combat_Distance();
			
			dest3 = theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * ACS_BruxaDash_Normal_Distance();
			
			dest4 = theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * ACS_BruxaDash_Normal_Distance();
		}
		else
		{
			dest1 = thePlayer.GetWorldPosition() + (thePlayer.GetWorldRight() * (0-(ACS_BruxaDash_Combat_Distance()/3))) + thePlayer.GetWorldForward() * ACS_BruxaDash_Combat_Distance();
			
			dest2 = thePlayer.GetWorldPosition() + (thePlayer.GetWorldRight() * (ACS_BruxaDash_Combat_Distance()/3)) + thePlayer.GetWorldForward() * ACS_BruxaDash_Combat_Distance();
			
			dest3 = thePlayer.GetWorldPosition() + (thePlayer.GetWorldRight() * (0-(ACS_BruxaDash_Normal_Distance()/3))) + thePlayer.GetWorldForward() * ACS_BruxaDash_Normal_Distance();
			
			dest4 = thePlayer.GetWorldPosition() + (thePlayer.GetWorldRight() * (ACS_BruxaDash_Normal_Distance()/3)) + thePlayer.GetWorldForward() * ACS_BruxaDash_Normal_Distance();
		}
		
		MovementAdjustBruxaDash();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				if (!thePlayer.IsSwimming())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					if (!thePlayer.IsSwimming())
					{
						movementAdjustor.RotateTowards( ticket, actor );  
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
					}
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}
			}
			
			if (theInput.GetActionValue('GI_AxisLeftX') > 0.5 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_run_dash_ACS', 'PLAYER_SLOT', settings);
				
				movementAdjustor.SlideTo( ticket, dest1 );
			}	
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_run_dash_right_ACS', 'PLAYER_SLOT', settings);
				
				movementAdjustor.SlideTo( ticket, dest2 );
			}	
			else
			{	
				bruxa_dash_index_1 = RandDifferent(this.previous_bruxa_dash_index_1 , 2);

				switch (bruxa_dash_index_1) 
				{				
					case 1:
					movementAdjustor.SlideTo( ticket, dest1 );
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_run_dash_ACS', 'PLAYER_SLOT', settings);
					break;	
							
					default:
					movementAdjustor.SlideTo( ticket, dest2 );
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_run_dash_right_ACS', 'PLAYER_SLOT', settings);
					break;	
				}

				this.previous_bruxa_dash_index_1 = bruxa_dash_index_1;
			}
		}
		else
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			if (theInput.GetActionValue('GI_AxisLeftX') > 0.5 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_run_dash_ACS', 'PLAYER_SLOT', settings);
				
				if (thePlayer.IsInCombat())
				{
					movementAdjustor.SlideTo( ticket, dest1 );
				}
				else
				{
					movementAdjustor.SlideTo( ticket, dest3 );
				}
			}	
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_run_dash_right_ACS', 'PLAYER_SLOT', settings);
				
				if (thePlayer.IsInCombat())
				{
					movementAdjustor.SlideTo( ticket, dest2 );
				}
				else
				{
					movementAdjustor.SlideTo( ticket, dest4 );
				}
			}	
			else
			{			
				bruxa_dash_index_2 = RandDifferent(this.previous_bruxa_dash_index_2 , 2);

				switch (bruxa_dash_index_2) 
				{				
					case 1:
					
					if (thePlayer.IsInCombat())
					{
						movementAdjustor.SlideTo( ticket, dest1 );
					}
					else
					{
						movementAdjustor.SlideTo( ticket, dest3 );
					}
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_run_dash_ACS', 'PLAYER_SLOT', settings);
					break;	
							
					default:
					
					if (thePlayer.IsInCombat())
					{
						movementAdjustor.SlideTo( ticket, dest2 );
					}
					else
					{
						movementAdjustor.SlideTo( ticket, dest4 );
					}
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_run_dash_right_ACS', 'PLAYER_SLOT', settings);
					break;	
				}

				this.previous_bruxa_dash_index_2 = bruxa_dash_index_2;
			}
		}
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// Claw Attacks
	
	function geraltRandomClawFistAttack() 
	{
		MovementAdjust();

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			claw_fist_attack_index_1 = RandDifferent(this.previous_claw_fist_attack_index_1 , 5);

			switch (claw_fist_attack_index_1) 
			{	
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_03_ACS', 'PLAYER_SLOT', settings);	
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_02_ACS', 'PLAYER_SLOT', settings);	
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_01_ACS', 'PLAYER_SLOT', settings);	
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_02_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_01_ACS', 'PLAYER_SLOT', settings);
				break;
			}
		
			this.previous_claw_fist_attack_index_1 = claw_fist_attack_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			claw_fist_attack_index_3 = RandDifferent(this.previous_claw_fist_attack_index_3 , 5);

			switch (claw_fist_attack_index_3) 
			{							
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_03_ACS', 'PLAYER_SLOT', settings);	
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_02_ACS', 'PLAYER_SLOT', settings);	
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_01_ACS', 'PLAYER_SLOT', settings);	
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_02_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_01_ACS', 'PLAYER_SLOT', settings);
				break;
			}
			
			this.previous_claw_fist_attack_index_3 = claw_fist_attack_index_3;
		}	
	}

	function geraltClawSprintingAttack() 
	{
		MovementAdjust();

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_special_charge_run_ACS', 'PLAYER_SLOT', settings);
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_special_charge_run_ACS', 'PLAYER_SLOT', settings);
		}	

		thePlayer.SetSprintActionPressed( false );
		thePlayer.SetSprintToggle( false );
		thePlayer.SetWalkToggle( true );
	}
	
	function geraltRandomHeavyClawAttack() 
	{
		MovementAdjust();

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 1.5*1.5 ) 
			{							
				heavy_claw_attack_index = RandDifferent(this.previous_heavy_claw_attack_index , 3);

				switch (heavy_claw_attack_index) 
				{		
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_medium_ACS', 'PLAYER_SLOT', settings);
					break;	
					
					case 1:	
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_close_ACS', 'PLAYER_SLOT', settings);	
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_strong_uppercut_ACS', 'PLAYER_SLOT', settings);	
					break;
				}
					
				this.previous_heavy_claw_attack_index = heavy_claw_attack_index;
			}
			else
			{
				heavy_claw_attack_index = RandDifferent(this.previous_heavy_claw_attack_index , 5);

				switch (heavy_claw_attack_index) 
				{		
					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_single_03_ACS', 'PLAYER_SLOT', settings);	
					break;
					
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_single_02_ACS', 'PLAYER_SLOT', settings);
					break;

					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_single_01_ACS', 'PLAYER_SLOT', settings);
					break;	
					
					case 1:	
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_02_ACS', 'PLAYER_SLOT', settings);	
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_01_ACS', 'PLAYER_SLOT', settings);	
					break;
				}
					
				this.previous_heavy_claw_attack_index = heavy_claw_attack_index;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			heavy_claw_attack_index = RandDifferent(this.previous_heavy_claw_attack_index , 5);

			switch (heavy_claw_attack_index) 
			{									
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_single_03_ACS', 'PLAYER_SLOT', settings);	
				break;
					
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_single_02_ACS', 'PLAYER_SLOT', settings);
				break;

				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_single_01_ACS', 'PLAYER_SLOT', settings);
				break;	
					
				case 1:	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_02_ACS', 'PLAYER_SLOT', settings);	
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_01_ACS', 'PLAYER_SLOT', settings);	
				break;
			}
			
			this.previous_heavy_claw_attack_index = heavy_claw_attack_index;
		}	
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// Fist Attacks

	function geraltRandomLightFistAttack()
	{
		MovementAdjust();

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}

			if( targetDistance <= 1.5*1.5 ) 
			{
				fist_attack_index_1 = RandDifferent(this.previous_fist_attack_index_1 , 8);

				switch (fist_attack_index_1) 
				{	
					case 7:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_close_combo_attack_1', 'PLAYER_SLOT', settings);	
					break;

					case 6:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_4_lh_40ms_short', 'PLAYER_SLOT', settings);	
					break;

					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_3_rh_40ms_short', 'PLAYER_SLOT', settings);	
					break;

					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_1_lh_40ms_short', 'PLAYER_SLOT', settings);	
					break;
					
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_1_rh_40ms_short', 'PLAYER_SLOT', settings);	
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_2_lh_40ms_short', 'PLAYER_SLOT', settings);	
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_2_rh_40ms_short', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_3_lh_40ms_short', 'PLAYER_SLOT', settings);
					break;
				}
			
				this.previous_fist_attack_index_1 = fist_attack_index_1;
			}
			else if( targetDistance > 1.5*1.5 && targetDistance <= 3.5*3.5) 
			{
				fist_attack_index_1 = RandDifferent(this.previous_fist_attack_index_1 , 8);

				switch (fist_attack_index_1) 
				{	
					case 7:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_5_rl_40ms', 'PLAYER_SLOT', settings);	
					break;

					case 6:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_4_lh_40ms', 'PLAYER_SLOT', settings);	
					break;

					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_3_rh_40ms', 'PLAYER_SLOT', settings);	
					break;

					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_3_lh_40ms', 'PLAYER_SLOT', settings);	
					break;
					
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_2_rh_40ms', 'PLAYER_SLOT', settings);	
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_2_lh_40ms', 'PLAYER_SLOT', settings);	
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_1_rh_40ms', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_1_lh_40ms', 'PLAYER_SLOT', settings);
					break;
				}
			
				this.previous_fist_attack_index_1 = fist_attack_index_1;
			}
			else
			{
				fist_attack_index_2 = RandDifferent(this.previous_fist_attack_index_2 , 3);

				switch (fist_attack_index_2) 
				{	
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_far_forward_1_rh_50ms', 'PLAYER_SLOT', settings);	
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_far_forward_2_lh_50ms', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_far_forward_2_rh_50ms', 'PLAYER_SLOT', settings);
					break;
				}
			
				this.previous_fist_attack_index_2 = fist_attack_index_2;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			fist_attack_index_3 = RandDifferent(this.previous_fist_attack_index_3 , 19);

			switch (fist_attack_index_3) 
			{	
				case 18:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_far_forward_1_rh_50ms', 'PLAYER_SLOT', settings);	
				break;
				
				case 17:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_far_forward_2_lh_50ms', 'PLAYER_SLOT', settings);
				break;

				case 16:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_far_forward_2_rh_50ms', 'PLAYER_SLOT', settings);
				break;

				case 15:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_5_rl_40ms', 'PLAYER_SLOT', settings);	
				break;

				case 14:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_4_lh_40ms', 'PLAYER_SLOT', settings);	
				break;

				case 13:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_3_rh_40ms', 'PLAYER_SLOT', settings);	
				break;

				case 12:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_3_lh_40ms', 'PLAYER_SLOT', settings);	
				break;
				
				case 11:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_2_rh_40ms', 'PLAYER_SLOT', settings);	
				break;
				
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_2_lh_40ms', 'PLAYER_SLOT', settings);	
				break;
				
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_1_rh_40ms', 'PLAYER_SLOT', settings);
				break;

				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_1_lh_40ms', 'PLAYER_SLOT', settings);
				break;

				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_close_combo_attack_1', 'PLAYER_SLOT', settings);	
				break;

				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_4_lh_40ms_short', 'PLAYER_SLOT', settings);	
				break;

				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_3_rh_40ms_short', 'PLAYER_SLOT', settings);	
				break;

				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_1_lh_40ms_short', 'PLAYER_SLOT', settings);	
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_1_rh_40ms_short', 'PLAYER_SLOT', settings);	
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_2_lh_40ms_short', 'PLAYER_SLOT', settings);	
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_2_rh_40ms_short', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_fast_3_lh_40ms_short', 'PLAYER_SLOT', settings);
				break;
			}
			
			this.previous_fist_attack_index_3 = fist_attack_index_3;
		}
	}

	function geraltRandomHeavyFistAttack()
	{
		MovementAdjust();

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}

			if( targetDistance <= 1.5*1.5 ) 
			{
				heavy_fist_attack_index_1 = RandDifferent(this.previous_heavy_fist_attack_index_1 , 6);

				switch (heavy_fist_attack_index_1) 
				{	
					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_close_combo_attack_1', 'PLAYER_SLOT', settings);	
					break;

					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_close_combo_attack_6', 'PLAYER_SLOT', settings);	
					break;
					
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_close_combo_attack_5', 'PLAYER_SLOT', settings);	
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_close_combo_attack_4', 'PLAYER_SLOT', settings);	
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_close_combo_attack_3', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_close_combo_attack_2', 'PLAYER_SLOT', settings);
					break;
				}
			
				this.previous_heavy_fist_attack_index_1 = heavy_fist_attack_index_1;
			}
			else if( targetDistance > 1.5*1.5 && targetDistance <= 3.5*3.5) 
			{
				heavy_fist_attack_index_1 = RandDifferent(this.previous_heavy_fist_attack_index_1 , 6);

				switch (heavy_fist_attack_index_1) 
				{	
					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_heavy_4_ll_70ms', 'PLAYER_SLOT', settings);	
					break;

					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_heavy_3_lh_70ms', 'PLAYER_SLOT', settings);	
					break;
					
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_heavy_2_rh_70ms', 'PLAYER_SLOT', settings);	
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_heavy_2_lh_70ms', 'PLAYER_SLOT', settings);	
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_heavy_1_rh_70ms', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_heavy_1_lh_70ms', 'PLAYER_SLOT', settings);
					break;
				}
			
				this.previous_heavy_fist_attack_index_1 = heavy_fist_attack_index_1;
			}
			else
			{
				heavy_fist_attack_index_2 = RandDifferent(this.previous_heavy_fist_attack_index_2 , 3);

				switch (heavy_fist_attack_index_2) 
				{	
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_heavy_far_2_ll_80ms', 'PLAYER_SLOT', settings);	
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_heavy_far_1_rh_80ms', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_heavy_far_1_lh_80ms', 'PLAYER_SLOT', settings);
					break;
				}
			
				this.previous_heavy_fist_attack_index_2 = heavy_fist_attack_index_2;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			heavy_fist_attack_index_3 = RandDifferent(this.previous_heavy_fist_attack_index_3 , 15);

			switch (heavy_fist_attack_index_3) 
			{
				case 14:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_heavy_far_2_ll_80ms', 'PLAYER_SLOT', settings);	
				break;
				
				case 13:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_heavy_far_1_rh_80ms', 'PLAYER_SLOT', settings);
				break;

				case 12:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_heavy_far_1_lh_80ms', 'PLAYER_SLOT', settings);
				break;

				case 11:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_heavy_4_ll_70ms', 'PLAYER_SLOT', settings);	
				break;

				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_heavy_3_lh_70ms', 'PLAYER_SLOT', settings);	
				break;
				
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_heavy_2_rh_70ms', 'PLAYER_SLOT', settings);	
				break;
				
				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_heavy_2_lh_70ms', 'PLAYER_SLOT', settings);	
				break;
				
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_heavy_1_rh_70ms', 'PLAYER_SLOT', settings);
				break;

				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_attack_heavy_1_lh_70ms', 'PLAYER_SLOT', settings);
				break;

				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_close_combo_attack_1', 'PLAYER_SLOT', settings);	
				break;

				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_close_combo_attack_6', 'PLAYER_SLOT', settings);	
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_close_combo_attack_5', 'PLAYER_SLOT', settings);	
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_close_combo_attack_4', 'PLAYER_SLOT', settings);	
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_close_combo_attack_3', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_fistfight_close_combo_attack_2', 'PLAYER_SLOT', settings);
				break;
			}
			
			this.previous_heavy_fist_attack_index_3 = heavy_fist_attack_index_3;
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// Counters
	
	function geraltRandomKick() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			kick_index_1 = RandDifferent(this.previous_kick_index_1 , 2);

			switch (kick_index_1) 
			{										
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_kick_lp_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_kick_rp_ACS', 'PLAYER_SLOT', settings);
				break;	
			}
		
			this.previous_kick_index_1 = kick_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			kick_index_2 = RandDifferent(this.previous_kick_index_2 , 2);

			switch (kick_index_2) 
			{						
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_kick_lp_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_kick_rp_ACS', 'PLAYER_SLOT', settings);
				break;
			}
			
			this.previous_kick_index_2 = kick_index_2;
		}	
	}
	
	function geraltRandomPush() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
				
			push_index_1 = RandDifferent(this.previous_push_index_1 , 2);

			switch (push_index_1) 
			{													
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_push_1_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_push_2_ACS', 'PLAYER_SLOT', settings);
				break;
			}
				
			this.previous_push_index_1 = push_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			push_index_2 = RandDifferent(this.previous_push_index_2 , 2);

			switch (push_index_2) 
			{	
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_push_1_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_push_2_ACS', 'PLAYER_SLOT', settings);
				break;
			}
			
			this.previous_push_index_2 = push_index_2;
		}	
	}
	
	function geraltRandomPunch() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
				
			punch_index_1 = RandDifferent(this.previous_punch_index_1 , 2);

			switch (punch_index_1) 
			{														
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'combat_locomotion_sucker_punch_70ms_far', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'combat_locomotion_sucker_punch_40ms_close', 'PLAYER_SLOT', settings);
				break;
			}
				
			this.previous_punch_index_1 = punch_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			punch_index_2 = RandDifferent(this.previous_punch_index_2 , 2);

			switch (punch_index_2) 
			{	
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'combat_locomotion_sucker_punch_70ms_far', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'combat_locomotion_sucker_punch_40ms_close', 'PLAYER_SLOT', settings);
				break;
			}
			
			this.previous_punch_index_2 = punch_index_2;
		}	
	}
	
	function geraltRandomYrdenCounter() 
	{
		MovementAdjust();
		
		//ACS_Giant_Lightning_Strike_Single();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}

			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2h_parry_ACS', 'PLAYER_SLOT', settings);
			
			/*
			yrden_counter_index_1 = RandDifferent(this.previous_yrden_counter_index_1 , 2);

			switch (yrden_counter_index_1) 
			{														
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_caretaker_ACS', 'PLAYER_SLOT', settings);
				break;	

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_caretaker_ACS', 'PLAYER_SLOT', settings);
				break;
			}
				
			this.previous_yrden_counter_index_1 = yrden_counter_index_1;
			*/
		}
		else
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2h_parry_ACS', 'PLAYER_SLOT', settings);
			
			/*
			yrden_counter_index_2 = RandDifferent(this.previous_yrden_counter_index_2 , 2);

			switch (yrden_counter_index_2) 
			{	
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_caretaker_ACS', 'PLAYER_SLOT', settings);
				break;	

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_caretaker_ACS', 'PLAYER_SLOT', settings);
				break;
			}
			
			this.previous_yrden_counter_index_2 = yrden_counter_index_2;
			*/
		}	
	}
	
	function geraltRandomAardCounter() 
	{
		MovementAdjust();
		
		AddTimer('ACS_shout', 1, false);

		VampVoiceEffects_Monster();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
				
			aard_counter_index_1 = RandDifferent(this.previous_aard_counter_index_1 , 2);

			switch (aard_counter_index_1) 
			{	
				case 1:	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_special_attack_02_ACS', 'PLAYER_SLOT', settings);		
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_special_01_ACS', 'PLAYER_SLOT', settings);	
				break;
			}
				
			this.previous_aard_counter_index_1 = aard_counter_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			aard_counter_index_2 = RandDifferent(this.previous_aard_counter_index_2 , 2);

			switch (aard_counter_index_2) 
			{	
				case 1:	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_special_attack_02_ACS', 'PLAYER_SLOT', settings);		
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_special_01_ACS', 'PLAYER_SLOT', settings);	
				break;
			}
			
			this.previous_aard_counter_index_2 = aard_counter_index_2;
		}	
	}
	
	function geraltRandomQuenCounter() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
				
			quen_counter_index_1 = RandDifferent(this.previous_quen_counter_index_1 , 3);

			switch (quen_counter_index_1) 
			{	
				/*
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_sand_1_ACS', 'PLAYER_SLOT', settings);
				break;	
				*/
				
				case 2:
				if (thePlayer.GetStat(BCS_Vitality) <= thePlayer.GetStatMax(BCS_Vitality) * 0.75)
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'ethereal_attack_with_shout_001_ACS', 'PLAYER_SLOT', settings);
					AddTimer('ACS_shout', 1, false);
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_sand_hand_right_ACS', 'PLAYER_SLOT', settings);
				}
				break;	
								
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_sand_hand_left_ACS', 'PLAYER_SLOT', settings);
				break;	

				default:
				if (thePlayer.GetStat(BCS_Vitality) <= thePlayer.GetStatMax(BCS_Vitality) * 0.75)
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'ethereal_attack_shout_ACS', 'PLAYER_SLOT', settings);
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_elbow_r_ACS', 'PLAYER_SLOT', settings);
				}
				break;
			}
				
			this.previous_quen_counter_index_1 = quen_counter_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			quen_counter_index_2 = RandDifferent(this.previous_quen_counter_index_2 , 3);

			switch (quen_counter_index_2) 
			{	
				/*
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_sand_1_ACS', 'PLAYER_SLOT', settings);
				break;	
				*/
				
				case 2:
				if (thePlayer.GetStat(BCS_Vitality) <= thePlayer.GetStatMax(BCS_Vitality) * 0.75)
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'ethereal_attack_with_shout_001_ACS', 'PLAYER_SLOT', settings);
					AddTimer('ACS_shout', 1, false);
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_sand_hand_right_ACS', 'PLAYER_SLOT', settings);
				}
				break;	
								
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_sand_hand_left_ACS', 'PLAYER_SLOT', settings);
				break;	

				default:
				if (thePlayer.GetStat(BCS_Vitality) <= thePlayer.GetStatMax(BCS_Vitality) * 0.75)
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'ethereal_attack_shout_ACS', 'PLAYER_SLOT', settings);
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_elbow_r_ACS', 'PLAYER_SLOT', settings);
				}
				break;
			}
			
			this.previous_quen_counter_index_2 = quen_counter_index_2;
		}	
	}
	
	function geraltRandomAxiiCounter() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
				
			axii_counter_index_1 = RandDifferent(this.previous_axii_counter_index_1 , 5);

			switch (axii_counter_index_1) 
			{	
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_kick_03_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_kick_02_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_kick_01_ACS', 'PLAYER_SLOT', settings);
				break;

				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_stepthrust_01_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_kickswing_01_ACS', 'PLAYER_SLOT', settings);
				break;
			}
				
			this.previous_axii_counter_index_1 = axii_counter_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			axii_counter_index_2 = RandDifferent(this.previous_axii_counter_index_2 , 2);

			switch (axii_counter_index_2) 
			{	
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_kick_03_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_kick_02_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_kick_01_ACS', 'PLAYER_SLOT', settings);
				break;

				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_stepthrust_01_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_kickswing_01_ACS', 'PLAYER_SLOT', settings);
				break;
			}
			
			this.previous_axii_counter_index_2 = axii_counter_index_2;
		}	
	}
	
	function geraltRandomIgniCounter() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 1 ) 
			{	
				igni_counter_index_1 = RandDifferent(this.previous_igni_counter_index_1 , 2);

				switch (igni_counter_index_1) 
				{										
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_sidestep_counter_right_lp', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_sidestep_counter_left_rp', 'PLAYER_SLOT', settings);
					break;	
				}
		
				this.previous_igni_counter_index_1 = igni_counter_index_1;
			}
			else
			{
				igni_counter_index_2 = RandDifferent(this.previous_igni_counter_index_2 , 2);

				switch (igni_counter_index_2) 
				{												
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_sidestep_counter_left_lp', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_sidestep_counter_right_rp', 'PLAYER_SLOT', settings);
					break;
				}
				
				this.previous_igni_counter_index_2 = igni_counter_index_2;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			igni_counter_index_3 = RandDifferent(this.previous_igni_counter_index_3 , 4);

			switch (igni_counter_index_3) 
			{						
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_sidestep_counter_right_lp', 'PLAYER_SLOT', settings);
				break;

				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_sidestep_counter_left_rp', 'PLAYER_SLOT', settings);
				break;	
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_sidestep_counter_left_lp', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_sidestep_counter_right_rp', 'PLAYER_SLOT', settings);
				break;
			}
			
			this.previous_igni_counter_index_3 = igni_counter_index_3;
		}	
	}
	
	function geraltRandomSpearCounter() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
				
			quen_counter_index_1 = RandDifferent(this.previous_quen_counter_index_1 , 3);

			switch (quen_counter_index_1) 
			{	
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_04_rp_ACS', 'PLAYER_SLOT', settings);	
				break;

				case 1:	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_03_rp_ACS', 'PLAYER_SLOT', settings);		
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);	
				break;
			}
				
			this.previous_quen_counter_index_1 = quen_counter_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			quen_counter_index_2 = RandDifferent(this.previous_quen_counter_index_2 , 3);

			switch (quen_counter_index_2) 
			{	
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_04_rp_ACS', 'PLAYER_SLOT', settings);	
				break;

				case 1:	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_03_rp_ACS', 'PLAYER_SLOT', settings);		
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);	
				break;
			}
			
			this.previous_quen_counter_index_2 = quen_counter_index_2;
		}	
	}
	
	function geraltRandomGiantCounter() 
	{
		MovementAdjust();

		AddTimer( 'ACS_alive_check', 1, false );
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
				
			yrden_counter_index_1 = RandDifferent(this.previous_yrden_counter_index_1 , 2);

			switch (yrden_counter_index_1) 
			{	
				case 1:	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_caretaker_ACS', 'PLAYER_SLOT', settings);		
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_caretaker_ACS', 'PLAYER_SLOT', settings);	
				break;
			}
				
			this.previous_yrden_counter_index_1 = yrden_counter_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			yrden_counter_index_2 = RandDifferent(this.previous_yrden_counter_index_2 , 2);

			switch (yrden_counter_index_2) 
			{	
				case 1:	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_caretaker_ACS', 'PLAYER_SLOT', settings);		
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_caretaker_ACS', 'PLAYER_SLOT', settings);	
				break;
			}
			
			this.previous_yrden_counter_index_2 = yrden_counter_index_2;
		}	
	}

	function HeadbuttDamageActual()
	{
		actors = thePlayer.GetNPCsAndPlayersInCone(1.75, VecHeading(thePlayer.GetHeadingVector()), 10, 20, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];

			dmg = new W3DamageAction in theGame.damageMgr;
			
			dmg.Initialize(thePlayer, actortarget, NULL, thePlayer.GetName(), EHRT_Reflect, CPS_Undefined, false, false, true, false);
			
			dmg.SetProcessBuffsIfNoDamage(true);
			
			dmg.SetHitReactionType( EHRT_Reflect, true);

			dmg.SetIgnoreImmortalityMode(true);
			
			//dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, RandRangeF(damageMax,damageMin) );

			if (actortarget.UsesVitality()) 
			{ 
				maxTargetVitality = actortarget.GetStatMax( BCS_Vitality );

				damageMax = maxTargetVitality * 0.10; 
				
				damageMin = maxTargetVitality * 0.075; 
			} 
			else if (actortarget.UsesEssence()) 
			{ 
				maxTargetEssence = actortarget.GetStatMax( BCS_Essence );
				
				damageMax = maxTargetEssence * 0.125; 
				
				damageMin = maxTargetEssence * 0.075; 
			} 

			dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(damageMax,damageMin) );

			dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(damageMax,damageMin) );

			if (RandF() < 0.25 )
			{
				if( !npc.IsImmuneToBuff( EET_Stagger ) && !npc.HasBuff( EET_Stagger ) ) 
				{ 
					dmg.AddEffectInfo( EET_Stagger, 0.1 );
				}
			}
				
			theGame.damageMgr.ProcessAction( dmg );
				
			delete dmg;	
		}
	}
	
	function geraltRandomGregCounter() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
				
			//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'gregoire_attack_punch_ACS', 'PLAYER_SLOT', settings);

			punch_index_1 = RandDifferent(this.previous_punch_index_1 , 2);

			switch (punch_index_1) 
			{														
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_finisher_hilt_01_lp', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_finisher_hilt_01_rp', 'PLAYER_SLOT', settings);
				break;
			}
				
			this.previous_punch_index_1 = punch_index_1;

			AddTimer('ACS_HeadbuttDamage', 0.75, false);
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'gregoire_attack_punch_ACS', 'PLAYER_SLOT', settings);

			punch_index_1 = RandDifferent(this.previous_punch_index_1 , 2);

			switch (punch_index_1) 
			{														
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_finisher_hilt_01_lp', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_finisher_hilt_01_rp', 'PLAYER_SLOT', settings);
				break;
			}
				
			this.previous_punch_index_1 = punch_index_1;

			AddTimer('ACS_HeadbuttDamage', 0.75, false);
		}	
	}
	
	function geraltRandomAxeCounter() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
				
			aard_counter_index_1 = RandDifferent(this.previous_aard_counter_index_1 , 2);

			switch (aard_counter_index_1) 
			{	
				case 1:	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_special_03_rp_ACS', 'PLAYER_SLOT', settings);		
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_special_02_rp_ACS', 'PLAYER_SLOT', settings);	
				break;
			}
				
			this.previous_aard_counter_index_1 = aard_counter_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			aard_counter_index_2 = RandDifferent(this.previous_aard_counter_index_2 , 2);

			switch (aard_counter_index_2) 
			{	
				case 1:	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_special_03_rp_ACS', 'PLAYER_SLOT', settings);		
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_special_02_rp_ACS', 'PLAYER_SLOT', settings);	
				break;
			}
			
			this.previous_aard_counter_index_2 = aard_counter_index_2;
		}	
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// Claw Weapon Stuff
	
	function geraltRandomClawAttack() 
	{		
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 1.5*1.5 ) 
			{	
				claw_attack_index_1 = RandDifferent(this.previous_claw_attack_index_1 , 7);

				switch (claw_attack_index_1) 
				{	
					case 6:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_special_turn_right_ACS', 'PLAYER_SLOT', settings);	
					break;
						
					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_special_turn_left_ACS', 'PLAYER_SLOT', settings);	
					break;
				
					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_medium_ACS', 'PLAYER_SLOT', settings);	
					break;

					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_close_ACS', 'PLAYER_SLOT', settings);	
					break;	
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_03_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_02_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_01_ACS', 'PLAYER_SLOT', settings);
					break;
				}
		
				this.previous_claw_attack_index_1 = claw_attack_index_1;
			}
			else
			{
				claw_attack_index_2 = RandDifferent(this.previous_claw_attack_index_2 , 7);

				switch (claw_attack_index_2) 
				{								
					case 6:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_single_03_ACS', 'PLAYER_SLOT', settings);	
					break;
					
					case 5:	
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_single_02_ACS', 'PLAYER_SLOT', settings);	
					break;

					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_single_01', 'PLAYER_SLOT', settings);	
					break;

					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_02_ACS', 'PLAYER_SLOT', settings);	
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_01_ACS', 'PLAYER_SLOT', settings);	
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_02_ACS', 'PLAYER_SLOT', settings);	
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_01_ACS', 'PLAYER_SLOT', settings);	
					break;
				}
				
				this.previous_claw_attack_index_2 = claw_attack_index_2;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			claw_attack_index_3 = RandDifferent(this.previous_claw_attack_index_3 , 14);

			switch (claw_attack_index_3) 
			{	
				case 13:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_special_turn_right_ACS', 'PLAYER_SLOT', settings);	
				break;
						
				case 12:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_special_turn_left_ACS', 'PLAYER_SLOT', settings);	
				break;
					
				case 11:	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_single_03_ACS', 'PLAYER_SLOT', settings);	
				break;
				
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_single_02_ACS', 'PLAYER_SLOT', settings);	
				break;

				case 9:	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_single_01_ACS', 'PLAYER_SLOT', settings);	
				break;

				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_02_ACS', 'PLAYER_SLOT', settings);	
				break;
				
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_01_ACS', 'PLAYER_SLOT', settings);	
				break;
				
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_03_ACS', 'PLAYER_SLOT', settings);	
				break;
				
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_02_ACS', 'PLAYER_SLOT', settings);	
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_01_ACS', 'PLAYER_SLOT', settings);	
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_medium_ACS', 'PLAYER_SLOT', settings);	
				break;

				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_close_ACS', 'PLAYER_SLOT', settings);	
				break;	
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_02_ACS', 'PLAYER_SLOT', settings);	
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_01_ACS', 'PLAYER_SLOT', settings);	
				break;
			}
			
			this.previous_claw_attack_index_3 = claw_attack_index_3;
		}	
	}
	
	function geraltRandomClawComboAttack() 
	{		
		MovementAdjust();

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			claw_combo_attack_index_1 = RandDifferent(this.previous_claw_combo_attack_index_1 , 3);

			switch (claw_combo_attack_index_1) 
			{												
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_combo_03_ACS', 'PLAYER_SLOT', settings);	
				break;
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_combo_02_ACS', 'PLAYER_SLOT', settings);	
				break;
					
				default:	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_combo_01_ACS', 'PLAYER_SLOT', settings);	
				break;
			}
				
			this.previous_claw_combo_attack_index_1 = claw_combo_attack_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			claw_combo_attack_index_3 = RandDifferent(this.previous_claw_combo_attack_index_3 , 3);

			switch (claw_combo_attack_index_3) 
			{	
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_combo_03_ACS', 'PLAYER_SLOT', settings);	
				break;
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_combo_02_ACS', 'PLAYER_SLOT', settings);	
				break;
					
				default:	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_combo_01_ACS', 'PLAYER_SLOT', settings);	
				break;
			}
			
			this.previous_claw_combo_attack_index_3 = claw_combo_attack_index_3;
		}	
	}
	
	function jump_attack()
	{
		MovementAdjust();
		
		thePlayer.BreakAttachment();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if( targetDistance <= 2.5*2.5 ) 
			{
				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  
					movementAdjustor.SlideTowards( ticket, actor, distJump, distJump );
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  
						movementAdjustor.SlideTowards( ticket, actor, distJump, distJump );
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
						movementAdjustor.SlideTo( ticket, theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * 2.5 );
					}
				}
			}
			else if( targetDistance > 2.5*2.5 && targetDistance <= 5*5 ) 
			{
				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  
					thePlayer.EnableCollisions(false);
					movementAdjustor.SlideTowards( ticket, actor, distJump, distJump );
					//thePlayer.EnableCollisions(true);
					AddTimer('ACS_collision_delay', 0.4, false);
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  
						thePlayer.EnableCollisions(false);
						movementAdjustor.SlideTowards( ticket, actor, distJump, distJump );
						//thePlayer.EnableCollisions(true);
						AddTimer('ACS_collision_delay', 0.4, false);
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
						thePlayer.EnableCollisions(false);
						AddTimer('ACS_collision_delay', 0.4, false);
						movementAdjustor.SlideTo( ticket, thePlayer.GetWorldPosition() + theCamera.GetCameraDirection() * 5 );
					}
				}
			}
			else
			{
				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  
					thePlayer.EnableCollisions(false);
					movementAdjustor.SlideTowards( ticket, actor, distJump, distJump );
					//thePlayer.EnableCollisions(true);
					AddTimer('ACS_collision_delay', 0.4, false);
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  
						thePlayer.EnableCollisions(false);
						movementAdjustor.SlideTowards( ticket, actor, distJump, distJump );
						//thePlayer.EnableCollisions(true);
						AddTimer('ACS_collision_delay', 0.4, false);
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
						thePlayer.EnableCollisions(false);
						AddTimer('ACS_collision_delay', 0.4, false);
						movementAdjustor.SlideTo( ticket, theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * 7.5 );
					}
				}
			}
			
			if (thePlayer.HasTag('vampire_claws_equipped'))
			{
				thePlayer.SoundEvent("monster_dettlaff_monster_combat_construct_dash_vfx");
				
				thePlayer.SoundEvent("monster_dettlaff_monster_construct_whoosh_claws_large");

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_jump_up_attack_ACS', 'PLAYER_SLOT', settings);
			}
			else
			{
				thePlayer.SoundEvent("monster_dettlaff_monster_combat_construct_dash_vfx");

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_jump_up_stop_ACS', 'PLAYER_SLOT', settings);
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			thePlayer.EnableCollisions(false);

			AddTimer('ACS_collision_delay', 0.4, false);

			movementAdjustor.SlideTo( ticket, theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * 7.5 );
			
			if (thePlayer.HasTag('vampire_claws_equipped'))
			{
				thePlayer.SoundEvent("monster_dettlaff_monster_combat_construct_dash_vfx");

				thePlayer.SoundEvent("monster_dettlaff_monster_construct_whoosh_claws_large");

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_jump_up_attack_ACS', 'PLAYER_SLOT', settings);
			}
			else
			{
				thePlayer.SoundEvent("monster_dettlaff_monster_combat_construct_dash_vfx");

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_jump_up_stop_ACS', 'PLAYER_SLOT', settings);
			}
		}
	}
	
	function air_jump_attack()
	{
		MovementAdjust();
		
		thePlayer.BreakAttachment();
		
		if 
		(
		GetWeatherConditionName() == 'WT_Wild_Hunt' 
		|| GetWeatherConditionName() == 'WT_q501_Storm' 
		|| GetWeatherConditionName() == 'WT_Rain_Storm' 
		|| GetWeatherConditionName() == 'WT_Rain_Heavy' 
		|| GetWeatherConditionName() == 'WT_Heavy_Clouds_Dark' 
		|| GetWeatherConditionName() == 'WT_Battle' 
		|| GetWeatherConditionName() == 'WT_Battle_Forest' 
		)
		{
			ACS_Lightning_Area();
		
			ACS_Giant_Lightning_Strike_Mult();
		}
		
		ACS_Rock_Pillar();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			movementAdjustor.RotateTowards( ticket, actor );  
			
			thePlayer.EnableCollisions(false);
			movementAdjustor.SlideTowards( ticket, actor, distJump, distJump );
			thePlayer.EnableCollisions(true);
			//AddTimer('ACS_collision_delay', 0.4, false);
			
			if (thePlayer.HasTag('vampire_claws_equipped'))
			{
				thePlayer.SoundEvent("monster_dettlaff_monster_combat_construct_dash_vfx");

				thePlayer.SoundEvent("monster_dettlaff_monster_construct_whoosh_claws_large");

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_jump_up_attack_ACS', 'PLAYER_SLOT', settings);
			}
			else
			{
				thePlayer.SoundEvent("monster_dettlaff_monster_combat_construct_dash_vfx");

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_jump_up_stop_ACS', 'PLAYER_SLOT', settings);
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			thePlayer.EnableCollisions(false);

			AddTimer('ACS_collision_delay', 0.4, false);

			movementAdjustor.SlideTo( ticket, theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * 7.5 );
			
			if (thePlayer.HasTag('vampire_claws_equipped'))
			{
				thePlayer.SoundEvent("monster_dettlaff_monster_combat_construct_dash_vfx");

				thePlayer.SoundEvent("monster_dettlaff_monster_construct_whoosh_claws_large");

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_jump_up_attack_ACS', 'PLAYER_SLOT', settings);
			}
			else
			{
				thePlayer.SoundEvent("monster_dettlaff_monster_combat_construct_dash_vfx");

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_jump_up_stop_ACS', 'PLAYER_SLOT', settings);
			}
		}
	}
	
	function geraltRandomAttackSpecialDash() 
	{
		//theGame.SetTimeScale( 0.75, theGame.GetTimescaleSource( ETS_InstantKill ), theGame.GetTimescalePriority( ETS_InstantKill ), false, true );

		//AddTimer( 'RemoveInstantKillSloMo', 0.3 );

		Bruxa_Camo_Decoy_Deactivate();

		MovementAdjust();

		dodge_timer_attack_actual();

		thePlayer.SetIsCurrentlyDodging(true);

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{		
			if( targetDistance <= 2.5*2.5 ) 
			{
				thePlayer.DrainStamina(ESAT_HeavyAttack);

				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  

					//movementAdjustor.SlideTowards( ticket, actor, dist, dist );
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  

						//movementAdjustor.SlideTowards( ticket, actor, dist, dist );
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
					}	
				}

				thePlayer.PlayEffect('shadowdash_short');

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_close_ACS', 'PLAYER_SLOT', settings);

				thePlayer.StopEffect('shadowdash_short');
			}
			else if( targetDistance > 2.5*2.5 && targetDistance <= 7.5*7.5 ) 
			{
				RemoveTimer('ACS_dodge_timer_end');

				thePlayer.DrainStamina(ESAT_HeavyAttack);

				thePlayer.DrainStamina(ESAT_HeavyAttack);

				thePlayer.ClearAnimationSpeedMultipliers();	
							
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 1.5 / theGame.GetTimeScale() ); }	
						
				AddTimer('ACS_ResetAnimation', 0.75 / theGame.GetTimeScale() , false);

				//dodge_timer_attack_actual();

				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  

					//thePlayer.EnableCollisions(false);
					//movementAdjustor.SlideTowards( ticket, actor, distVampSpecialDash, distVampSpecialDash );
					//AddTimer('ACS_collision_delay', 0.4, false);
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  

						//thePlayer.EnableCollisions(false);
						//movementAdjustor.SlideTowards( ticket, actor, distVampSpecialDash, distVampSpecialDash );
						//AddTimer('ACS_collision_delay', 0.4, false);
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

						//thePlayer.EnableCollisions(false);

						//AddTimer('ACS_collision_delay', 0.4, false);

						//movementAdjustor.SlideTo( ticket, thePlayer.GetWorldPosition() + theCamera.GetCameraDirection() * 5 );
					}
				}

				attack_special_dash_index_1 = RandDifferent(this.previous_attack_special_dash_index_1 , 2);

				switch (attack_special_dash_index_1) 
				{	
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_medium_02_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_medium_01_ACS', 'PLAYER_SLOT', settings);	
					break;
				}
				
				this.previous_attack_special_dash_index_1 = attack_special_dash_index_1;

				//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_close_ACS', 'PLAYER_SLOT', settings);	

				AddTimer('ACS_bruxa_tackle', 0.75 / theGame.GetTimeScale() , false);
			}
			else
			{
				RemoveTimer('ACS_dodge_timer_end');

				thePlayer.DrainStamina(ESAT_HeavyAttack);

				thePlayer.DrainStamina(ESAT_HeavyAttack);

				//dodge_timer_attack_actual();

				thePlayer.ClearAnimationSpeedMultipliers();	
							
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 1.5 / theGame.GetTimeScale() ); }	
						
				AddTimer('ACS_ResetAnimation', 0.75 / theGame.GetTimeScale(), false);

				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  

					//thePlayer.EnableCollisions(false);
					//movementAdjustor.SlideTowards( ticket, actor, distVampSpecialDash, distVampSpecialDash );
					//AddTimer('ACS_collision_delay', 0.4, false);
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  

						//thePlayer.EnableCollisions(false);
						//movementAdjustor.SlideTowards( ticket, actor, distVampSpecialDash, distVampSpecialDash );
						//AddTimer('ACS_collision_delay', 0.4, false);
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

						//thePlayer.EnableCollisions(false);

						//AddTimer('ACS_collision_delay', 0.4, false);

						//movementAdjustor.SlideTo( ticket, theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * 7.5 );
					}	
				}

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_medium_01_ACS', 'PLAYER_SLOT', settings);

				//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_close_ACS', 'PLAYER_SLOT', settings);	

				AddTimer('ACS_bruxa_tackle', 0.75 / theGame.GetTimeScale(), false);
			}
		}
		else
		{
			thePlayer.ClearAnimationSpeedMultipliers();	

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			attack_special_dash_index_1 = RandDifferent(this.previous_attack_special_dash_index_1 , 3);

			switch (attack_special_dash_index_1) 
			{	
				case 2:
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 2 / theGame.GetTimeScale() ); }	
						
				AddTimer('ACS_ResetAnimation', 0.25 / theGame.GetTimeScale(), false);

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_close_ACS', 'PLAYER_SLOT', settings);
				break;

				case 1:
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 2 / theGame.GetTimeScale() ); }	
						
				AddTimer('ACS_ResetAnimation', 0.75 / theGame.GetTimeScale(), false);

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_medium_02_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 2 / theGame.GetTimeScale() ); }	
						
				AddTimer('ACS_ResetAnimation', 0.75 / theGame.GetTimeScale(), false);

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_medium_01_ACS', 'PLAYER_SLOT', settings);	
				break;
			}
			
			this.previous_attack_special_dash_index_1 = attack_special_dash_index_1;
		}			
	}

	function geraltRandomClawAttackSpecialDash() 
	{
		//theGame.SetTimeScale( 0.75, theGame.GetTimescaleSource( ETS_InstantKill ), theGame.GetTimescalePriority( ETS_InstantKill ), false, true );

		//AddTimer( 'RemoveInstantKillSloMo', 0.3 );

		Bruxa_Camo_Decoy_Deactivate();

		MovementAdjust();

		dodge_timer_attack_actual();

		thePlayer.SetIsCurrentlyDodging(true);

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{		
			if( targetDistance <= 2.5*2.5 ) 
			{
				thePlayer.DrainStamina(ESAT_HeavyAttack);

				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  

					//movementAdjustor.SlideTowards( ticket, actor, dist, dist );
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  

						//movementAdjustor.SlideTowards( ticket, actor, dist, dist );
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
					}	
				}

				thePlayer.PlayEffect('shadowdash_short');

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_close_ACS', 'PLAYER_SLOT', settings);

				thePlayer.StopEffect('shadowdash_short');
			}
			else if( targetDistance > 2.5*2.5 && targetDistance <= 7.5*7.5 ) 
			{
				RemoveTimer('ACS_dodge_timer_end');

				thePlayer.DrainStamina(ESAT_HeavyAttack);

				thePlayer.DrainStamina(ESAT_HeavyAttack);

				thePlayer.ClearAnimationSpeedMultipliers();	
							
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 1.5 / theGame.GetTimeScale() ); }	
						
				AddTimer('ACS_ResetAnimation', 1 / theGame.GetTimeScale(), false);

				//dodge_timer_attack_actual();

				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  

					//thePlayer.EnableCollisions(false);
					//movementAdjustor.SlideTowards( ticket, actor, distVampSpecialDash, distVampSpecialDash );
					//AddTimer('ACS_collision_delay', 0.4, false);
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  

						//thePlayer.EnableCollisions(false);
						//movementAdjustor.SlideTowards( ticket, actor, distVampSpecialDash, distVampSpecialDash );
						//AddTimer('ACS_collision_delay', 0.4, false);
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

						//thePlayer.EnableCollisions(false);

						//AddTimer('ACS_collision_delay', 0.4, false);

						//movementAdjustor.SlideTo( ticket, thePlayer.GetWorldPosition() + theCamera.GetCameraDirection() * 5 );
					}
				}

				attack_special_dash_index_1 = RandDifferent(this.previous_attack_special_dash_index_1 , 2);

				switch (attack_special_dash_index_1) 
				{	
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_medium_02_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_medium_01_ACS', 'PLAYER_SLOT', settings);	
					break;
				}
				
				this.previous_attack_special_dash_index_1 = attack_special_dash_index_1;

				//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_close_ACS', 'PLAYER_SLOT', settings);	

				AddTimer('ACS_bruxa_tackle', 0.75 / theGame.GetTimeScale(), false);

				//vampire_fist_slide();
			}
			else
			{
				RemoveTimer('ACS_dodge_timer_end');

				thePlayer.DrainStamina(ESAT_HeavyAttack);

				thePlayer.DrainStamina(ESAT_HeavyAttack);

				//dodge_timer_attack_actual();

				thePlayer.ClearAnimationSpeedMultipliers();	
							
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 1.5 / theGame.GetTimeScale() ); }	
						
				AddTimer('ACS_ResetAnimation', 1 / theGame.GetTimeScale(), false);

				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  

					//thePlayer.EnableCollisions(false);
					//movementAdjustor.SlideTowards( ticket, actor, distVampSpecialDash, distVampSpecialDash );
					//AddTimer('ACS_collision_delay', 0.4, false);
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  

						//thePlayer.EnableCollisions(false);
						//movementAdjustor.SlideTowards( ticket, actor, distVampSpecialDash, distVampSpecialDash );
						//AddTimer('ACS_collision_delay', 0.4, false);
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

						//thePlayer.EnableCollisions(false);

						//AddTimer('ACS_collision_delay', 0.4, false);

						//movementAdjustor.SlideTo( ticket, theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * 7.5 );
					}	
				}

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_medium_01_ACS', 'PLAYER_SLOT', settings);

				//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_close_ACS', 'PLAYER_SLOT', settings);	

				AddTimer('ACS_bruxa_tackle', 0.75 / theGame.GetTimeScale(), false);

				//vampire_fist_slide();
			}
		}
		else
		{
			thePlayer.ClearAnimationSpeedMultipliers();	

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			attack_special_dash_index_1 = RandDifferent(this.previous_attack_special_dash_index_1 , 3);

			switch (attack_special_dash_index_1) 
			{	
				case 2:
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 2 / theGame.GetTimeScale() ); }	
						
				AddTimer('ACS_ResetAnimation', 0.25 / theGame.GetTimeScale(), false);

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_close_ACS', 'PLAYER_SLOT', settings);
				break;

				case 1:
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 2 / theGame.GetTimeScale() ); }	
						
				AddTimer('ACS_ResetAnimation', 0.75 / theGame.GetTimeScale(), false);

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_medium_02_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 2 / theGame.GetTimeScale() ); }	
						
				AddTimer('ACS_ResetAnimation', 0.75 / theGame.GetTimeScale(), false);

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_medium_01_ACS', 'PLAYER_SLOT', settings);	
				break;
			}
			
			this.previous_attack_special_dash_index_1 = attack_special_dash_index_1;
		}			
	}
	
	function geraltClawWhirlAttack() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{			
			if( targetDistance <= 3.5 * 3.5 ) 
			{
				thePlayer.DrainStamina(ESAT_HeavyAttack);

				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
					}	
				}

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_03_ACS', 'PLAYER_SLOT', settings);
			}
			else if( targetDistance > 3.5 * 3.5  && targetDistance <= 5*5 ) 
			{
				thePlayer.DrainStamina(ESAT_HeavyAttack);

				thePlayer.DrainStamina(ESAT_HeavyAttack);

				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  

					//movementAdjustor.SlideTowards( ticket, actor, distClawWhirl, distClawWhirl );
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  

						//movementAdjustor.SlideTowards( ticket, actor, distClawWhirl, distClawWhirl );
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

						//movementAdjustor.SlideTo( ticket, thePlayer.GetWorldPosition() + theCamera.GetCameraDirection() * 5 );
					}
				}

				//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_03_ACS', 'PLAYER_SLOT', settings);

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_medium_02_ACS', 'PLAYER_SLOT', settings);

				thePlayer.AddTag('ACS_Whirl_Attack');

				AddTimer('ACS_bruxa_tackle', 0.75 / theGame.GetTimeScale(), false);
			}
			else
			{
				thePlayer.DrainStamina(ESAT_HeavyAttack);

				thePlayer.DrainStamina(ESAT_HeavyAttack);

				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  

					//movementAdjustor.SlideTowards( ticket, actor, distClawWhirl, distClawWhirl );
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  

						//movementAdjustor.SlideTowards( ticket, actor, distClawWhirl, distClawWhirl );
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

						//movementAdjustor.SlideTo( ticket, theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * 7.5 );
					}
				}

				//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_03_ACS', 'PLAYER_SLOT', settings);

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_medium_01_ACS', 'PLAYER_SLOT', settings);

				thePlayer.AddTag('ACS_Whirl_Attack');

				AddTimer('ACS_bruxa_tackle', 0.75 / theGame.GetTimeScale(), false);
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_03_ACS', 'PLAYER_SLOT', settings);
		}
	}

	function geraltClawWhirlReactionAttack() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{			
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}

			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_03_ACS', 'PLAYER_SLOT', settings);
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_03_ACS', 'PLAYER_SLOT', settings);
		}
	}
	
	function geraltRandomClawHeavyAttackAlt()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck (actor) )
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			heavy_claw_attack_index = RandDifferent(this.previous_heavy_claw_attack_index , 5);

			switch (heavy_claw_attack_index) 
			{		
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_single_03_ACS', 'PLAYER_SLOT', settings);	
				break;
					
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_single_02_ACS', 'PLAYER_SLOT', settings);
				break;

				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_single_01_ACS', 'PLAYER_SLOT', settings);
				break;	
					
				case 1:	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_02_ACS', 'PLAYER_SLOT', settings);	
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_01_ACS', 'PLAYER_SLOT', settings);	
				break;
			}
					
			this.previous_heavy_claw_attack_index = heavy_claw_attack_index;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			heavy_claw_attack_index = RandDifferent(this.previous_heavy_claw_attack_index , 5);

			switch (heavy_claw_attack_index) 
			{									
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_single_03_ACS', 'PLAYER_SLOT', settings);	
				break;
					
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_single_02_ACS', 'PLAYER_SLOT', settings);
				break;

				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_single_01_ACS', 'PLAYER_SLOT', settings);
				break;	
					
				case 1:	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_02_ACS', 'PLAYER_SLOT', settings);	
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_01_ACS', 'PLAYER_SLOT', settings);	
				break;
			}
			
			this.previous_heavy_claw_attack_index = heavy_claw_attack_index;
		}
	}
	
	function geraltRandomClawHeavyAttack()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck (actor) )
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
							
			heavy_claw_attack_index = RandDifferent(this.previous_heavy_claw_attack_index , 3);

			switch (heavy_claw_attack_index) 
			{		
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_medium_ACS', 'PLAYER_SLOT', settings);
				break;	
					
				case 1:	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_close_ACS', 'PLAYER_SLOT', settings);	
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_strong_uppercut_ACS', 'PLAYER_SLOT', settings);	
				break;
			}
					
			this.previous_heavy_claw_attack_index = heavy_claw_attack_index;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			heavy_claw_attack_index = RandDifferent(this.previous_heavy_claw_attack_index , 3);

			switch (heavy_claw_attack_index) 
			{									
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_medium_ACS', 'PLAYER_SLOT', settings);
				break;	
					
				case 1:	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_close_ACS', 'PLAYER_SLOT', settings);	
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_strong_uppercut_ACS', 'PLAYER_SLOT', settings);	
				break;
			}
			
			this.previous_heavy_claw_attack_index = heavy_claw_attack_index;
		}
	}
	
	function geraltRandomClawLightAttackAlt()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			claw_combo_attack_index_1 = RandDifferent(this.previous_claw_combo_attack_index_1 , 3);

			switch (claw_combo_attack_index_1) 
			{												
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_combo_03_ACS', 'PLAYER_SLOT', settings);	
				break;
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_combo_02_ACS', 'PLAYER_SLOT', settings);	
				break;
					
				default:	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_combo_01_ACS', 'PLAYER_SLOT', settings);	
				break;
			}
				
			this.previous_claw_combo_attack_index_1 = claw_combo_attack_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			claw_combo_attack_index_3 = RandDifferent(this.previous_claw_combo_attack_index_3 , 3);

			switch (claw_combo_attack_index_3) 
			{	
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_combo_03_ACS', 'PLAYER_SLOT', settings);	
				break;
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_combo_02_ACS', 'PLAYER_SLOT', settings);	
				break;
					
				default:	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_combo_01_ACS', 'PLAYER_SLOT', settings);	
				break;
			}
			
			this.previous_claw_combo_attack_index_3 = claw_combo_attack_index_3;
		}
	}		
	
	function geraltRandomClawLightAttack()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck (actor) )
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			claw_fist_attack_index_1 = RandDifferent(this.previous_claw_fist_attack_index_1 , 5);

			switch (claw_fist_attack_index_1) 
			{	
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_03_ACS', 'PLAYER_SLOT', settings);	
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_02_ACS', 'PLAYER_SLOT', settings);	
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_01_ACS', 'PLAYER_SLOT', settings);	
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_02_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_01_ACS', 'PLAYER_SLOT', settings);
				break;
			}
		
			this.previous_claw_fist_attack_index_1 = claw_fist_attack_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			claw_fist_attack_index_3 = RandDifferent(this.previous_claw_fist_attack_index_3 , 5);

			switch (claw_fist_attack_index_3) 
			{							
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_03_ACS', 'PLAYER_SLOT', settings);	
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_02_ACS', 'PLAYER_SLOT', settings);	
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_attack_01_ACS', 'PLAYER_SLOT', settings);	
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_02_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_01_ACS', 'PLAYER_SLOT', settings);
				break;
			}
			
			this.previous_claw_fist_attack_index_3 = claw_fist_attack_index_3;
		}	
	}
	
	function geraltRandomClawSpecialAttackAlt()
	{
		//theGame.SetTimeScale( 0.75, theGame.GetTimescaleSource( ETS_InstantKill ), theGame.GetTimescalePriority( ETS_InstantKill ), false, true );

		//AddTimer( 'RemoveInstantKillSloMo', 0.3 );

		Bruxa_Camo_Decoy_Deactivate();

		MovementAdjust();

		dodge_timer_attack_actual();

		thePlayer.SetIsCurrentlyDodging(true);
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if( targetDistance <= 2.5*2.5 ) 
			{
				thePlayer.DrainStamina(ESAT_HeavyAttack);

				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  

					//movementAdjustor.SlideTowards( ticket, actor, dist * 0.25, dist * 0.25 );
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  

						//movementAdjustor.SlideTowards( ticket, actor, dist * 0.25, dist * 0.25 );
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
					}	
				}

				thePlayer.PlayEffect('shadowdash_short');
				
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_close_ACS', 'PLAYER_SLOT', settings);

				thePlayer.StopEffect('shadowdash_short');
			}
			else if( targetDistance > 2.5*2.5 && targetDistance <= 5*5 ) 
			{
				thePlayer.DrainStamina(ESAT_HeavyAttack);

				thePlayer.DrainStamina(ESAT_HeavyAttack);

				thePlayer.ClearAnimationSpeedMultipliers();	
							
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 1.5 / theGame.GetTimeScale() ); }	
						
				AddTimer('ACS_ResetAnimation', 0.75 / theGame.GetTimeScale(), false);

				//dodge_timer_attack_actual();

				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  

					//thePlayer.EnableCollisions(false);
					//movementAdjustor.SlideTowards( ticket, actor, distVampSpecialDash, distVampSpecialDash );
					//AddTimer('ACS_collision_delay', 0.4, false);
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  

						//thePlayer.EnableCollisions(false);
						//movementAdjustor.SlideTowards( ticket, actor, distVampSpecialDash, distVampSpecialDash );
						//AddTimer('ACS_collision_delay', 0.4, false);
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

						//thePlayer.EnableCollisions(false);

						//AddTimer('ACS_collision_delay', 0.4, false);

						//movementAdjustor.SlideTo( ticket, thePlayer.GetWorldPosition() + theCamera.GetCameraDirection() * 5 );
					}
				}

				attack_special_dash_index_1 = RandDifferent(this.previous_attack_special_dash_index_1 , 2);

				switch (attack_special_dash_index_1) 
				{	
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_medium_02_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_medium_01_ACS', 'PLAYER_SLOT', settings);	
					break;
				}
				
				this.previous_attack_special_dash_index_1 = attack_special_dash_index_1;

				//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_close_ACS', 'PLAYER_SLOT', settings);	

				AddTimer('ACS_bruxa_tackle', 0.75 / theGame.GetTimeScale(), false);
			}
			else
			{
				thePlayer.DrainStamina(ESAT_HeavyAttack);

				thePlayer.DrainStamina(ESAT_HeavyAttack);

				thePlayer.ClearAnimationSpeedMultipliers();	
							
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 1.5 / theGame.GetTimeScale() ); }	
						
				AddTimer('ACS_ResetAnimation', 0.75 / theGame.GetTimeScale(), false);

				//dodge_timer_attack_actual();
				
				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  

					//thePlayer.EnableCollisions(false);
					//movementAdjustor.SlideTowards( ticket, actor, distVampSpecialDash, distVampSpecialDash );
					//AddTimer('ACS_collision_delay', 0.4, false);
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  

						//thePlayer.EnableCollisions(false);
						//movementAdjustor.SlideTowards( ticket, actor, distVampSpecialDash, distVampSpecialDash );
						//AddTimer('ACS_collision_delay', 0.4, false);
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

						//thePlayer.EnableCollisions(false);

						//AddTimer('ACS_collision_delay', 0.4, false);

						//movementAdjustor.SlideTo( ticket, theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * 7.5 );
					}	
				}

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_medium_01_ACS', 'PLAYER_SLOT', settings);

				//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_close_ACS', 'PLAYER_SLOT', settings);	

				AddTimer('ACS_bruxa_tackle', 0.75 / theGame.GetTimeScale(), false);
			}
		}
		else
		{
			thePlayer.ClearAnimationSpeedMultipliers();	

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			attack_special_dash_index_1 = RandDifferent(this.previous_attack_special_dash_index_1 , 2);

			switch (attack_special_dash_index_1) 
			{	
				case 2:
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 1.5 / theGame.GetTimeScale() ); }	
						
				AddTimer('ACS_ResetAnimation', 0.25 / theGame.GetTimeScale(), false);
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_close_ACS', 'PLAYER_SLOT', settings);
				break;

				case 1:
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 1.5 / theGame.GetTimeScale() ); }	
						
				AddTimer('ACS_ResetAnimation', 0.75 / theGame.GetTimeScale(), false);
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_medium_02_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier( 1.5 / theGame.GetTimeScale() ); }	
						
				AddTimer('ACS_ResetAnimation', 0.75 / theGame.GetTimeScale(), false);
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_medium_01_ACS', 'PLAYER_SLOT', settings);	
				break;
			}
			
			this.previous_attack_special_dash_index_1 = attack_special_dash_index_1;
		}			
	}
	
	/*
	function geraltRandomClawSpecialAttack()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{			
			if( targetDistance <= 3.5 * 3.5 ) 
			{
				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
					}	
				}

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_03_ACS', 'PLAYER_SLOT', settings);
			}
			else if( targetDistance > 3.5 * 3.5  && targetDistance <= 5*5 ) 
			{
				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  

					thePlayer.EnableCollisions(false);
					movementAdjustor.SlideTowards( ticket, actor, distClawWhirl, distClawWhirl );
					AddTimer('ACS_collision_delay', 0.3, false);
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  

						thePlayer.EnableCollisions(false);
						movementAdjustor.SlideTowards( ticket, actor, distClawWhirl, distClawWhirl );
						AddTimer('ACS_collision_delay', 0.3, false);
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

						thePlayer.EnableCollisions(false);

						AddTimer('ACS_collision_delay', 0.4, false);

						movementAdjustor.SlideTo( ticket, thePlayer.GetWorldPosition() + theCamera.GetCameraDirection() * 5 );
					}
				}

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_03_ACS', 'PLAYER_SLOT', settings);
			}
			else
			{
				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  

					thePlayer.EnableCollisions(false);
					movementAdjustor.SlideTowards( ticket, actor, distClawWhirl, distClawWhirl );
					AddTimer('ACS_collision_delay', 0.3, false);
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  

						thePlayer.EnableCollisions(false);
						movementAdjustor.SlideTowards( ticket, actor, distClawWhirl, distClawWhirl );
						AddTimer('ACS_collision_delay', 0.3, false);
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

						thePlayer.EnableCollisions(false);

						AddTimer('ACS_collision_delay', 0.4, false);

						movementAdjustor.SlideTo( ticket, theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * 7.5 );
					}
				}

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_03_ACS', 'PLAYER_SLOT', settings);
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_03_ACS', 'PLAYER_SLOT', settings);
		}
	}
	*/
	function geraltRandomClawSpecialAttack() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{			
			if( targetDistance <= 3.5 * 3.5 ) 
			{
				thePlayer.DrainStamina(ESAT_HeavyAttack);

				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
					}	
				}

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_03_ACS', 'PLAYER_SLOT', settings);
			}
			else if( targetDistance > 3.5 * 3.5  && targetDistance <= 5*5 ) 
			{
				thePlayer.DrainStamina(ESAT_HeavyAttack);

				thePlayer.DrainStamina(ESAT_HeavyAttack);

				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  

					//movementAdjustor.SlideTowards( ticket, actor, distClawWhirl, distClawWhirl );
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  

						//movementAdjustor.SlideTowards( ticket, actor, distClawWhirl, distClawWhirl );
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

						//movementAdjustor.SlideTo( ticket, thePlayer.GetWorldPosition() + theCamera.GetCameraDirection() * 5 );
					}
				}

				//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_03_ACS', 'PLAYER_SLOT', settings);

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_medium_02_ACS', 'PLAYER_SLOT', settings);

				thePlayer.AddTag('ACS_Whirl_Attack');

				AddTimer('ACS_bruxa_tackle', 0.75 / theGame.GetTimeScale(), false);
			}
			else
			{
				thePlayer.DrainStamina(ESAT_HeavyAttack);

				thePlayer.DrainStamina(ESAT_HeavyAttack);

				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  

					//movementAdjustor.SlideTowards( ticket, actor, distClawWhirl, distClawWhirl );
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  

						//movementAdjustor.SlideTowards( ticket, actor, distClawWhirl, distClawWhirl );
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

						//movementAdjustor.SlideTo( ticket, theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * 7.5 );
					}
				}

				//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_03_ACS', 'PLAYER_SLOT', settings);

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_dash_medium_01_ACS', 'PLAYER_SLOT', settings);

				thePlayer.AddTag('ACS_Whirl_Attack');

				AddTimer('ACS_bruxa_tackle', 0.75 / theGame.GetTimeScale(), false);
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_light_03_ACS', 'PLAYER_SLOT', settings);
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// Olgierd attack stuff
	
	function geraltRandomOlgierdAttack() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck (actor) )
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 1.5*1.5 ) 
			{
				quen_sword_glow();

				olgierd_attack_index_1 = RandDifferent(this.previous_olgierd_attack_index_1 , 9);

				switch (olgierd_attack_index_1) 
				{
					case 8:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_tripple_1_ACS', 'PLAYER_SLOT', settings);
					break;	

					case 7:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_single_2_ACS', 'PLAYER_SLOT', settings);
					break;	
					
					case 6:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_single_1_ACS', 'PLAYER_SLOT', settings);
					break;	

					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_strong_up_right_ACS', 'PLAYER_SLOT', settings);
					break;			
					
					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_strong_down_left_ACS', 'PLAYER_SLOT', settings);
					break;	
					
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_strong_single_1_ACS', 'PLAYER_SLOT', settings);
					break;	
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_strong_up_right_with_step_back_ACS', 'PLAYER_SLOT', settings);
					break;	
				
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_strong_down_left_with_step_back_ACS', 'PLAYER_SLOT', settings);
					break;	
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_strong_single_2_ACS', 'PLAYER_SLOT', settings);
					break;	
				}

				this.previous_olgierd_attack_index_1 = olgierd_attack_index_1;
			}
			else
			{
				olgierd_attack_index_1 = RandDifferent(this.previous_olgierd_attack_index_1 , 7);

				switch (olgierd_attack_index_1) 
				{	
					case 6:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_2_right_ACS', 'PLAYER_SLOT', settings);
					break;	

					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_2_left_ACS', 'PLAYER_SLOT', settings);
					break;	

					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_1_right_ACS', 'PLAYER_SLOT', settings);
					break;			
					
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_1_left_ACS', 'PLAYER_SLOT', settings);
					break;

					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_pirouette_5_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_pirouette_2_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_pirouette_1_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_olgierd_attack_index_1 = olgierd_attack_index_1;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			olgierd_attack_index_3 = RandDifferent(this.previous_olgierd_attack_index_3 , 14);

			switch (olgierd_attack_index_3) 
			{	
				case 13:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_tripple_1_ACS', 'PLAYER_SLOT', settings);
				break;	

				case 12:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_pirouette_5_ACS', 'PLAYER_SLOT', settings);
				break;	
					
				case 11:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_pirouette_4_ACS', 'PLAYER_SLOT', settings);
				break;
						
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_pirouette_3_ACS', 'PLAYER_SLOT', settings);
				break;	

				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_pirouette_2_ACS', 'PLAYER_SLOT', settings);
				break;	
				
				case 8:
				quen_sword_glow();
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_strong_up_right_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 7:
				quen_sword_glow();
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_strong_down_left_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 6:
				quen_sword_glow();
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_strong_single_2_ACS', 'PLAYER_SLOT', settings);
				break;	
				
				case 5:
				quen_sword_glow();
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_strong_single_1_ACS', 'PLAYER_SLOT', settings);
				break;	
				
				case 4:
				quen_sword_glow();
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_strong_up_right_with_step_back_ACS', 'PLAYER_SLOT', settings);
				break;	
			
				case 3:
				quen_sword_glow();
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_strong_down_left_with_step_back_ACS', 'PLAYER_SLOT', settings);
				break;	

				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_single_2_ACS', 'PLAYER_SLOT', settings);
				break;	

				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_single_1_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_pirouette_1_ACS', 'PLAYER_SLOT', settings);
				break;	
			}

			this.previous_olgierd_attack_index_3 = olgierd_attack_index_3;
		}
	}
	
	function geraltRandomOlgierdPirouette()
	{	
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 1.5*1.5 ) 
			{
				olgierd_pirouette_index_2 = RandDifferent(this.previous_olgierd_pirouette_index_2 , 9);

				switch (olgierd_pirouette_index_2) 
				{	
					/*
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_pirouette_down_r_001_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_pirouette_down_l_001_ACS', 'PLAYER_SLOT', settings);
					break;
					*/

					case 8:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_knee_left_003_ACS', 'PLAYER_SLOT', settings);
					break;	

					case 7:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_knee_right_002_ACS', 'PLAYER_SLOT', settings);
					break;	
					
					case 6:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_knee_slash_180_1_ACS', 'PLAYER_SLOT', settings);
					break;			
					
					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_pirouette_r_002_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_pirouette_l_003_ACS', 'PLAYER_SLOT', settings);
					break;

					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_1_right_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
					break;	
						
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_2_left_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
					break;
						
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_1_left_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
					break;	
						
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_2_right_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
					break;
				}
				
				this.previous_olgierd_pirouette_index_2 = olgierd_pirouette_index_2;
			}
			else
			{
				olgierd_attack_index_1 = RandDifferent(this.previous_olgierd_attack_index_1 , 5);

				switch (olgierd_attack_index_1) 
				{						
					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_lll_1_left_NEW_test_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_lll_1_right_NEW_test_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_lll_2_left_NEW_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_lll_2_right_NEW_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_lll_3_right_NEW_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_olgierd_attack_index_1 = olgierd_attack_index_1;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			olgierd_attack_index_3 = RandDifferent(this.previous_olgierd_attack_index_3 , 10);

			switch (olgierd_attack_index_3) 
			{
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_knee_left_003_ACS', 'PLAYER_SLOT', settings);
				break;	

				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_knee_right_002_ACS', 'PLAYER_SLOT', settings);
				break;	
					
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_knee_slash_180_1_ACS', 'PLAYER_SLOT', settings);
				break;			
					
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_pirouette_r_002_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_pirouette_l_003_ACS', 'PLAYER_SLOT', settings);
				break;

				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_lll_1_left_NEW_test_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_lll_1_right_NEW_test_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_lll_2_left_NEW_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_lll_2_right_NEW_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_lll_3_right_NEW_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_olgierd_attack_index_3 = olgierd_attack_index_3;
		}
	}	
	
	function geraltRandomShadowAttack() 
	{
		//theGame.SetTimeScale( 0.75, theGame.GetTimescaleSource( ETS_InstantKill ), theGame.GetTimescalePriority( ETS_InstantKill ), false, true );

		//AddTimer( 'RemoveInstantKillSloMo', 0.3 );

		MovementAdjust();

		dodge_timer_attack_actual();

		thePlayer.SetIsCurrentlyDodging(true);

		quen_sword_glow();	
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{			
			if( targetDistance <= 3.25*3.25 ) 
			{
				thePlayer.DrainStamina(ESAT_HeavyAttack);

				thePlayer.ClearAnimationSpeedMultipliers();	
										
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
				
				AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);

				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
					}	
				}

				olgierd_shadow_attack_index_1 = RandDifferent(this.previous_olgierd_shadow_attack_index_1 , 3);

				switch (olgierd_shadow_attack_index_1) 
				{	
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowdash_strong_3_ACS', 'PLAYER_SLOT', settings);
					break;

					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowdash_strong_2_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'shadow_attack_jump_forward_middle_right_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_olgierd_shadow_attack_index_1 = olgierd_shadow_attack_index_1;
			}
			else if( targetDistance > 3.25*3.25 && targetDistance <= 8*8 ) 
			{
				RemoveTimer('ACS_dodge_timer_end');

				thePlayer.DrainStamina(ESAT_HeavyAttack);
																
				thePlayer.DrainStamina(ESAT_HeavyAttack);

				thePlayer.ClearAnimationSpeedMultipliers();	
										
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }
				
				AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);

				/*
				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  

					thePlayer.EnableCollisions(false);
					movementAdjustor.SlideTowards( ticket, actor, dist, dist );
					AddTimer('ACS_collision_delay', 0.4, false);
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  

						thePlayer.EnableCollisions(false);
						movementAdjustor.SlideTowards( ticket, actor, dist, dist );
						AddTimer('ACS_collision_delay', 0.4, false);
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

						thePlayer.EnableCollisions(false);

						AddTimer('ACS_collision_delay', 0.4, false);

						movementAdjustor.SlideTo( ticket, thePlayer.GetWorldPosition() + theCamera.GetCameraDirection() * 5 );
					}
				}
			
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowdash_002_ACS', 'PLAYER_SLOT', settings);
				*/
				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
					}
				}

				olgierd_shadow_attack_part_2_index_2 = RandDifferent(this.previous_olgierd_shadow_attack_part_2_index_2 , 2);

				switch (olgierd_shadow_attack_part_2_index_2) 
				{	
					case 1:
					thePlayer.PlayEffect('special_attack_fx');
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowdash_strong_1_ACS', 'PLAYER_SLOT', settings);
					thePlayer.StopEffect('special_attack_fx');
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowstep_001_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_olgierd_shadow_attack_part_2_index_2 = olgierd_shadow_attack_part_2_index_2;

				AddTimer('ACS_bruxa_tackle', 0.5  / theGame.GetTimeScale(), false);
			}
			else
			{
				RemoveTimer('ACS_dodge_timer_end');

				thePlayer.DrainStamina(ESAT_HeavyAttack);
																
				thePlayer.DrainStamina(ESAT_HeavyAttack);

				thePlayer.ClearAnimationSpeedMultipliers();	
										
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.25 / theGame.GetTimeScale() ); }
				
				AddTimer('ACS_ResetAnimation', 0.25 / theGame.GetTimeScale(), false);

				/*
				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  

					thePlayer.EnableCollisions(false);
					movementAdjustor.SlideTowards( ticket, actor, dist, dist );
					AddTimer('ACS_collision_delay', 0.4, false);
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  

						thePlayer.EnableCollisions(false);
						movementAdjustor.SlideTowards( ticket, actor, dist, dist );
						AddTimer('ACS_collision_delay', 0.4, false);
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

						thePlayer.EnableCollisions(false);

						AddTimer('ACS_collision_delay', 0.4, false);

						movementAdjustor.SlideTo( ticket, thePlayer.GetWorldPosition() + theCamera.GetCameraDirection() * 5 );
					}
				}
			
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowdash_002_ACS', 'PLAYER_SLOT', settings);
				*/
				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
					}
				}
			
				if (thePlayer.GetStat(BCS_Vitality) <= thePlayer.GetStatMax(BCS_Vitality) * 0.5)
				{
					thePlayer.PlayEffect('special_attack_fx');
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'ethereal_shadow_attack_001_ACS', 'PLAYER_SLOT', settings);
					thePlayer.StopEffect('special_attack_fx');
					AddTimer('ACS_bruxa_tackle', 1.5  / theGame.GetTimeScale(), false);
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowstep_001_ACS', 'PLAYER_SLOT', settings);
					AddTimer('ACS_bruxa_tackle', 1.5  / theGame.GetTimeScale(), false);
				}

				thePlayer.AddTag('ACS_Shadowstep_Long_Buff');
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			olgierd_shadow_attack_index_2 = RandDifferent(this.previous_olgierd_shadow_attack_index_2 , 4);

			switch (olgierd_shadow_attack_index_2) 
			{	
				case 3:
				thePlayer.ClearAnimationSpeedMultipliers();							
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
				AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowdash_strong_3_ACS', 'PLAYER_SLOT', settings);
				break;

				case 2:
				thePlayer.ClearAnimationSpeedMultipliers();							
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
				AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowdash_strong_2_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.ClearAnimationSpeedMultipliers();							
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
				AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'shadow_attack_jump_forward_middle_right_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.ClearAnimationSpeedMultipliers();						
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.25 / theGame.GetTimeScale() ); }
				AddTimer('ACS_ResetAnimation', 0.25 / theGame.GetTimeScale(), false);

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowstep_001_ACS', 'PLAYER_SLOT', settings);

				AddTimer('ACS_bruxa_tackle', 1.5 / theGame.GetTimeScale(), false);
				break;
			}

			this.previous_olgierd_shadow_attack_index_2 = olgierd_shadow_attack_index_2;
		}
	}

	function geraltRandomOlgierdComboAttack() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}

			if( targetDistance <= 2.25*2.25 ) 
			{
				olgierd_combo_attack_index_1 = RandDifferent(this.previous_olgierd_combo_attack_index_1 , 4);

				switch (olgierd_combo_attack_index_1) 
				{	
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_to_strong_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_3_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_2_ACS', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_1_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_olgierd_combo_attack_index_1 = olgierd_combo_attack_index_1;
			}
			else if( targetDistance > 2.25*2.25 
			&& targetDistance <= 3.5*3.5 ) 
			{
				olgierd_combo_attack_index_1 = RandDifferent(this.previous_olgierd_combo_attack_index_1 , 11);

				switch (olgierd_combo_attack_index_1) 
				{									
					case 10:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_012_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 9:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_011_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 8:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_010_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 7:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_009_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 6:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_008_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_007_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_013_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_014_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_015_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_003_ACS', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_002_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_olgierd_combo_attack_index_1 = olgierd_combo_attack_index_1;
			}
			else
			{
				olgierd_combo_attack_index_1 = RandDifferent(this.previous_olgierd_combo_attack_index_1 , 3);

				switch (olgierd_combo_attack_index_1) 
				{	
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_006_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_005_ACS', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_004_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_olgierd_combo_attack_index_1 = olgierd_combo_attack_index_1;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			olgierd_combo_attack_index_2 = RandDifferent(this.previous_olgierd_combo_attack_index_2 , 18);

			switch (olgierd_combo_attack_index_2) 
			{	
				case 17:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_to_strong_ACS', 'PLAYER_SLOT', settings);
				break;	
			
				case 16:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_3_ACS', 'PLAYER_SLOT', settings);
				break;	

				case 15:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_2_ACS', 'PLAYER_SLOT', settings);
				break;	

				case 14:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_1_ACS', 'PLAYER_SLOT', settings);
				break;	
				
				case 13:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_015_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 12:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_014_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 11:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_013_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_012_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_011_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_010_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_009_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_008_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_007_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_006_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_005_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_004_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_003_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_002_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_olgierd_combo_attack_index_2 = olgierd_combo_attack_index_2;
		}
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	function geraltRandomOlgierdHeavyAttackAlt()
	{			
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 1.5*1.5 ) 
			{
				//quen_sword_glow();

				olgierd_heavy_attack_alt_index_1 = RandDifferent(this.previous_olgierd_heavy_attack_alt_index_1 , 2);

				switch (olgierd_heavy_attack_alt_index_1) 
				{						
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_strong_up_right_with_step_back_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_strong_down_left_with_step_back_ACS', 'PLAYER_SLOT', settings);
					break;	
				}

				this.previous_olgierd_heavy_attack_alt_index_1 = olgierd_heavy_attack_alt_index_1;
			}
			else
			{
				olgierd_heavy_attack_alt_index_2 = RandDifferent(this.previous_olgierd_heavy_attack_alt_index_2 , 2);

				switch (olgierd_heavy_attack_alt_index_2) 
				{						
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_2_right_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_2_left_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_olgierd_heavy_attack_alt_index_2 = olgierd_heavy_attack_alt_index_2;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			olgierd_heavy_attack_alt_index_3 = RandDifferent(this.previous_olgierd_heavy_attack_alt_index_3 , 6);

			switch (olgierd_heavy_attack_alt_index_3) 
			{									
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_strong_up_right_with_step_back_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_strong_down_left_with_step_back_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_2_right_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_2_left_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_olgierd_heavy_attack_alt_index_3 = olgierd_heavy_attack_alt_index_3;
		}
	}
	
	function geraltRandomOlgierdHeavyAttack()
	{			
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 1.5*1.5 ) 
			{
				//quen_sword_glow();

				olgierd_heavy_attack_index_1 = RandDifferent(this.previous_olgierd_heavy_attack_index_1 , 2);

				switch (olgierd_heavy_attack_index_1) 
				{						
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_strong_single_2_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_strong_single_1_ACS', 'PLAYER_SLOT', settings);
					break;	
				}

				this.previous_olgierd_heavy_attack_index_1 = olgierd_heavy_attack_index_1;
			}
			else
			{
				olgierd_heavy_attack_index_2 = RandDifferent(this.previous_olgierd_heavy_attack_index_2 , 4);

				switch (olgierd_heavy_attack_index_2) 
				{						
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_strong_up_right_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_strong_down_left_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_1_right_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_1_left_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_olgierd_heavy_attack_index_2 = olgierd_heavy_attack_index_2;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			olgierd_heavy_attack_index_3 = RandDifferent(this.previous_olgierd_heavy_attack_index_3 , 6);

			switch (olgierd_heavy_attack_index_3) 
			{									
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_strong_single_2_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_strong_single_1_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_strong_up_right_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_strong_down_left_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_1_right_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_1_left_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_olgierd_heavy_attack_index_3 = olgierd_heavy_attack_index_3;
		}
	}
	
	function geraltRandomOlgierdLightAttackAlt()
	{	
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 1.5*1.5 ) 
			{
				olgierd_light_attack_alt_index_1 = RandDifferent(this.previous_olgierd_light_attack_alt_index_1 , 5);

				switch (olgierd_light_attack_alt_index_1) 
				{						
					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_knee_left_003_ACS', 'PLAYER_SLOT', settings);
					break;	

					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_knee_right_002_ACS', 'PLAYER_SLOT', settings);
					break;	
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_knee_slash_180_1_ACS', 'PLAYER_SLOT', settings);
					break;			
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_pirouette_r_002_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_pirouette_l_003_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_olgierd_light_attack_alt_index_1 = olgierd_light_attack_alt_index_1;
			}
			else
			{
				olgierd_light_attack_alt_index_2 = RandDifferent(this.previous_olgierd_light_attack_alt_index_2 , 5);

				switch (olgierd_light_attack_alt_index_2) 
				{	
					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_lll_1_left_NEW_test_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_lll_1_right_NEW_test_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_lll_2_left_NEW_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_lll_2_right_NEW_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_lll_3_right_NEW_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_olgierd_light_attack_alt_index_2 = olgierd_light_attack_alt_index_2;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			olgierd_light_attack_alt_index_3 = RandDifferent(this.previous_olgierd_light_attack_alt_index_3 , 10);

			switch (olgierd_light_attack_alt_index_3) 
			{	
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_knee_left_003_ACS', 'PLAYER_SLOT', settings);
				break;	

				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_knee_right_002_ACS', 'PLAYER_SLOT', settings);
				break;	
				
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_knee_slash_180_1_ACS', 'PLAYER_SLOT', settings);
				break;			
				
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_pirouette_r_002_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_pirouette_l_003_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_lll_1_left_NEW_test_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_lll_1_right_NEW_test_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_lll_2_left_NEW_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_lll_2_right_NEW_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_lll_3_right_NEW_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_olgierd_light_attack_alt_index_3 = olgierd_light_attack_alt_index_3;
		}
	}
	
	function geraltRandomOlgierdLightAttack()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 1.5*1.5 ) 
			{
				//quen_sword_glow();

				olgierd_light_attack_index_1 = RandDifferent(this.previous_olgierd_light_attack_index_1 , 3);

				switch (olgierd_light_attack_index_1) 
				{	
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_tripple_1_ACS', 'PLAYER_SLOT', settings);
					break;

					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_single_2_ACS', 'PLAYER_SLOT', settings);
					break;	
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_single_1_ACS', 'PLAYER_SLOT', settings);
					break;	
				}

				this.previous_olgierd_light_attack_index_1 = olgierd_light_attack_index_1;
			}
			else
			{
				olgierd_light_attack_index_2 = RandDifferent(this.previous_olgierd_light_attack_index_2 , 7);

				switch (olgierd_light_attack_index_2) 
				{						
					case 6:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_1_right_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
					break;	
						
					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_2_left_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
					break;
						
					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_1_left_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
					break;	
						
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_2_right_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
					break;

					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_pirouette_5_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_pirouette_2_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_pirouette_1_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_olgierd_light_attack_index_2 = olgierd_light_attack_index_2;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			olgierd_light_attack_index_3 = RandDifferent(this.previous_olgierd_light_attack_index_3 , 10);

			switch (olgierd_light_attack_index_3) 
			{	
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_1_right_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
				break;	
					
				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_2_left_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
				break;

				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_tripple_1_ACS', 'PLAYER_SLOT', settings);
				break;

				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_single_2_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_single_1_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_pirouette_5_ACS', 'PLAYER_SLOT', settings);
				break;

				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_1_left_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
				break;

				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_2_right_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_pirouette_2_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_pirouette_1_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_olgierd_light_attack_index_3 = olgierd_light_attack_index_3;
		}
	}
	
	function geraltRandomOlgierdSpecialAttackAlt()
	{
		//theGame.SetTimeScale( 0.75, theGame.GetTimescaleSource( ETS_InstantKill ), theGame.GetTimescalePriority( ETS_InstantKill ), false, true );

		//AddTimer( 'RemoveInstantKillSloMo', 0.3 );

		MovementAdjust();

		quen_sword_glow();	

		dodge_timer_attack_actual();

		thePlayer.SetIsCurrentlyDodging(true);
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if( targetDistance <= 3.25*3.25 ) 
			{
				thePlayer.DrainStamina(ESAT_HeavyAttack);

				thePlayer.ClearAnimationSpeedMultipliers();	
										
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
				
				AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);

				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
					}	
				}

				olgierd_shadow_attack_index_1 = RandDifferent(this.previous_olgierd_shadow_attack_index_1 , 3);

				switch (olgierd_shadow_attack_index_1) 
				{	
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowdash_strong_3_ACS', 'PLAYER_SLOT', settings);
					break;

					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowdash_strong_2_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'shadow_attack_jump_forward_middle_right_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_olgierd_shadow_attack_index_1 = olgierd_shadow_attack_index_1;
			}
			else if( targetDistance > 3.25*3.25 && targetDistance <= 8*8 ) 
			{
				RemoveTimer('ACS_dodge_timer_end');

				thePlayer.DrainStamina(ESAT_HeavyAttack);
																
				thePlayer.DrainStamina(ESAT_HeavyAttack);

				thePlayer.ClearAnimationSpeedMultipliers();	
										
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.5 / theGame.GetTimeScale() ); }
				
				AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);

				/*
				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  

					thePlayer.EnableCollisions(false);
					movementAdjustor.SlideTowards( ticket, actor, dist, dist );
					AddTimer('ACS_collision_delay', 0.4, false);
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  

						thePlayer.EnableCollisions(false);
						movementAdjustor.SlideTowards( ticket, actor, dist, dist );
						AddTimer('ACS_collision_delay', 0.4, false);
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

						thePlayer.EnableCollisions(false);

						AddTimer('ACS_collision_delay', 0.4, false);

						movementAdjustor.SlideTo( ticket, thePlayer.GetWorldPosition() + theCamera.GetCameraDirection() * 5 );
					}
				}
			
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowdash_002_ACS', 'PLAYER_SLOT', settings);
				*/
				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
					}
				}
			
				olgierd_shadow_attack_part_2_index_2 = RandDifferent(this.previous_olgierd_shadow_attack_part_2_index_2 , 2);

				switch (olgierd_shadow_attack_part_2_index_2) 
				{	
					case 1:
					thePlayer.PlayEffect('special_attack_fx');
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowdash_strong_1_ACS', 'PLAYER_SLOT', settings);
					thePlayer.StopEffect('special_attack_fx');
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowstep_001_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_olgierd_shadow_attack_part_2_index_2 = olgierd_shadow_attack_part_2_index_2;

				AddTimer('ACS_bruxa_tackle', 0.5  / theGame.GetTimeScale(), false);
			}
			else
			{
				RemoveTimer('ACS_dodge_timer_end');

				thePlayer.DrainStamina(ESAT_HeavyAttack);
																
				thePlayer.DrainStamina(ESAT_HeavyAttack);

				thePlayer.ClearAnimationSpeedMultipliers();	
										
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.25 / theGame.GetTimeScale() ); }
				
				AddTimer('ACS_ResetAnimation', 0.25 / theGame.GetTimeScale(), false);

				/*
				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  

					thePlayer.EnableCollisions(false);
					movementAdjustor.SlideTowards( ticket, actor, dist, dist );
					AddTimer('ACS_collision_delay', 0.4, false);
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  

						thePlayer.EnableCollisions(false);
						movementAdjustor.SlideTowards( ticket, actor, dist, dist );
						AddTimer('ACS_collision_delay', 0.4, false);
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

						thePlayer.EnableCollisions(false);

						AddTimer('ACS_collision_delay', 0.4, false);

						movementAdjustor.SlideTo( ticket, thePlayer.GetWorldPosition() + theCamera.GetCameraDirection() * 5 );
					}
				}
			
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowdash_002_ACS', 'PLAYER_SLOT', settings);
				*/
				if ( ACS_GetTargetMode() == 0 )
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else if ( ACS_GetTargetMode() == 1 )
				{
					if (thePlayer.IsHardLockEnabled())
					{
						movementAdjustor.RotateTowards( ticket, actor );  
					}
					else
					{
						movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
					}
				}
			
				if (thePlayer.GetStat(BCS_Vitality) <= thePlayer.GetStatMax(BCS_Vitality) * 0.5)
				{
					thePlayer.PlayEffect('special_attack_fx');
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'ethereal_shadow_attack_001_ACS', 'PLAYER_SLOT', settings);
					thePlayer.StopEffect('special_attack_fx');
					AddTimer('ACS_bruxa_tackle', 1.5  / theGame.GetTimeScale(), false);
				}
				else
				{
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowstep_001_ACS', 'PLAYER_SLOT', settings);
					AddTimer('ACS_bruxa_tackle', 1.5  / theGame.GetTimeScale(), false);
				}

				thePlayer.AddTag('ACS_Shadowstep_Long_Buff');
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			olgierd_shadow_attack_index_2 = RandDifferent(this.previous_olgierd_shadow_attack_index_2 , 4);

			switch (olgierd_shadow_attack_index_2) 
			{	
				case 3:
				thePlayer.ClearAnimationSpeedMultipliers();							
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
				AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowdash_strong_3_ACS', 'PLAYER_SLOT', settings);
				break;

				case 2:
				thePlayer.ClearAnimationSpeedMultipliers();							
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
				AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowdash_strong_2_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.ClearAnimationSpeedMultipliers();							
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.75 / theGame.GetTimeScale() ); }	
				AddTimer('ACS_ResetAnimation', 0.5 / theGame.GetTimeScale() , false);

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'shadow_attack_jump_forward_middle_right_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.ClearAnimationSpeedMultipliers();						
				if (!thePlayer.IsGuarded()){thePlayer.SetAnimationSpeedMultiplier(1.25 / theGame.GetTimeScale() ); }
				AddTimer('ACS_ResetAnimation', 0.25 / theGame.GetTimeScale(), false);

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shadowstep_001_ACS', 'PLAYER_SLOT', settings);

				AddTimer('ACS_bruxa_tackle', 1.5 / theGame.GetTimeScale(), false);
				break;
			}

			this.previous_olgierd_shadow_attack_index_2 = olgierd_shadow_attack_index_2;
		}
	}
	
	function geraltRandomOlgierdSpecialAttack()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}

			if( targetDistance <= 2.25*2.25 ) 
			{
				olgierd_combo_attack_index_1 = RandDifferent(this.previous_olgierd_combo_attack_index_1 , 4);

				switch (olgierd_combo_attack_index_1) 
				{	
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_to_strong_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_3_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_2_ACS', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_1_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_olgierd_combo_attack_index_1 = olgierd_combo_attack_index_1;
			}
			else if( targetDistance > 2.25*2.25 
			&& targetDistance <= 3.5*3.5 ) 
			{
				olgierd_combo_attack_index_1 = RandDifferent(this.previous_olgierd_combo_attack_index_1 , 11);

				switch (olgierd_combo_attack_index_1) 
				{									
					case 10:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_012_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 9:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_011_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 8:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_010_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 7:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_009_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 6:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_008_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_007_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_013_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_014_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_015_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_003_ACS', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_002_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_olgierd_combo_attack_index_1 = olgierd_combo_attack_index_1;
			}
			else
			{
				olgierd_combo_attack_index_1 = RandDifferent(this.previous_olgierd_combo_attack_index_1 , 3);

				switch (olgierd_combo_attack_index_1) 
				{	
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_006_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_005_ACS', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_004_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_olgierd_combo_attack_index_1 = olgierd_combo_attack_index_1;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			olgierd_combo_attack_index_2 = RandDifferent(this.previous_olgierd_combo_attack_index_2 , 18);

			switch (olgierd_combo_attack_index_2) 
			{	
				case 17:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_to_strong_ACS', 'PLAYER_SLOT', settings);
				break;	
			
				case 16:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_3_ACS', 'PLAYER_SLOT', settings);
				break;	

				case 15:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_2_ACS', 'PLAYER_SLOT', settings);
				break;	

				case 14:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_1_ACS', 'PLAYER_SLOT', settings);
				break;	
				
				case 13:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_015_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 12:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_014_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 11:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_013_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_012_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_011_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_010_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_009_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_008_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_007_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_006_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_005_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_004_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_003_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_combo_002_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_olgierd_combo_attack_index_2 = olgierd_combo_attack_index_2;
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// Shield stuff

	function geraltRandomShieldAttack() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 1.5*1.5 ) 
			{	
				eredin_attack_index_1 = RandDifferent(this.previous_eredin_attack_index_1 , 2);

				switch (eredin_attack_index_1) 
				{	
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_attack_push_rp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_attack_push_lp_ACS', 'PLAYER_SLOT', settings);
					break;
				}
				
				this.previous_eredin_attack_index_1 = eredin_attack_index_1;

				ACS_Shield().PlayEffect('aard_cone_hit');
				ACS_Shield().StopEffect('aard_cone_hit');
			}
			else
			{		
				eredin_attack_index_2 = RandDifferent(this.previous_eredin_attack_index_2 , 4);

				switch (eredin_attack_index_2) 
				{	
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_attack_rp_03_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_attack_lp_02_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_attack_lp_03_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_attack_rp_02_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_eredin_attack_index_2 = eredin_attack_index_2;
			}				
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			eredin_attack_index_3 = RandDifferent(this.previous_eredin_attack_index_3 , 6);

			switch (eredin_attack_index_3) 
			{					
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_attack_push_rp_ACS', 'PLAYER_SLOT', settings);
				ACS_Shield().PlayEffect('aard_cone_hit');
				ACS_Shield().StopEffect('aard_cone_hit');
				break;
					
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_attack_push_lp_ACS', 'PLAYER_SLOT', settings);
				ACS_Shield().PlayEffect('aard_cone_hit');
				ACS_Shield().StopEffect('aard_cone_hit');
				break;
					
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_attack_rp_03_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_attack_lp_02_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_attack_lp_03_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_attack_rp_02_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_eredin_attack_index_3 = eredin_attack_index_3;
		}
	}
	
	function geraltRandomShieldComboAttack() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
				
			eredin_attack_index_2 = RandDifferent(this.previous_eredin_attack_index_2 , 4);

			switch (eredin_attack_index_2) 
			{	
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_2_right_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_2_left_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_1_right_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_1_left_ACS', 'PLAYER_SLOT', settings);
				break;
			}
			this.previous_eredin_attack_index_2 = eredin_attack_index_2;			
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			eredin_attack_index_3 = RandDifferent(this.previous_eredin_attack_index_3 , 4);

			switch (eredin_attack_index_3) 
			{					
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_2_right_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_2_left_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_1_right_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_1_left_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_eredin_attack_index_3 = eredin_attack_index_3;
		}
	}
	
	function geraltRandomShieldAttackAlt()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
					
			eredin_attack_index_2 = RandDifferent(this.previous_eredin_attack_index_2 , 4);

			switch (eredin_attack_index_2) 
			{	
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_charge_attack_lf_l_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_charge_attack_rf_r_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_eredin_attack_index_2 = eredin_attack_index_2;				
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			eredin_attack_index_3 = RandDifferent(this.previous_eredin_attack_index_3 , 6);

			switch (eredin_attack_index_3) 
			{						
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_charge_attack_lf_l_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_charge_attack_rf_r_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_eredin_attack_index_3 = eredin_attack_index_3;
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	function geraltRandomShieldHeavyAttackAlt()
	{		
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
				
			eredin_attack_index_2 = RandDifferent(this.previous_eredin_attack_index_2 , 2);

			switch (eredin_attack_index_2) 
			{	
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_2_right_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_2_left_ACS', 'PLAYER_SLOT', settings);
				break;
			}
			this.previous_eredin_attack_index_2 = eredin_attack_index_2;			
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			eredin_attack_index_3 = RandDifferent(this.previous_eredin_attack_index_3 , 2);

			switch (eredin_attack_index_3) 
			{							
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_2_right_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_2_left_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_eredin_attack_index_3 = eredin_attack_index_3;
		}
	}
	
	function geraltRandomShieldHeavyAttack()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 1.5*1.5 ) 
			{	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_attack_push_rp_ACS', 'PLAYER_SLOT', settings);
				ACS_Shield().PlayEffect('aard_cone_hit');
				ACS_Shield().StopEffect('aard_cone_hit');
			}
			else
			{		
				eredin_attack_index_2 = RandDifferent(this.previous_eredin_attack_index_2 , 2);

				switch (eredin_attack_index_2) 
				{	
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_attack_lp_03_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_attack_lp_02_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_eredin_attack_index_2 = eredin_attack_index_2;
			}				
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			eredin_attack_index_3 = RandDifferent(this.previous_eredin_attack_index_3 , 3);

			switch (eredin_attack_index_3) 
			{					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_attack_push_rp_ACS', 'PLAYER_SLOT', settings);
				ACS_Shield().PlayEffect('aard_cone_hit');
				ACS_Shield().StopEffect('aard_cone_hit');
				break;
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_attack_lp_03_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_attack_lp_02_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_eredin_attack_index_3 = eredin_attack_index_3;
		}
	}
	
	function geraltRandomShieldLightAttackAlt()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
				
			eredin_attack_index_2 = RandDifferent(this.previous_eredin_attack_index_2 , 2);

			switch (eredin_attack_index_2) 
			{	
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_1_right_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_1_left_ACS', 'PLAYER_SLOT', settings);
				break;
			}
			this.previous_eredin_attack_index_2 = eredin_attack_index_2;			
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			eredin_attack_index_3 = RandDifferent(this.previous_eredin_attack_index_3 , 2);

			switch (eredin_attack_index_3) 
			{							
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_1_right_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_1_left_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_eredin_attack_index_3 = eredin_attack_index_3;
		}
	}
	
	function geraltRandomShieldLightAttack()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 1.5*1.5 ) 
			{	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_attack_push_lp_ACS', 'PLAYER_SLOT', settings);
				ACS_Shield().PlayEffect('aard_cone_hit');
				ACS_Shield().StopEffect('aard_cone_hit');
			}
			else
			{		
				eredin_attack_index_2 = RandDifferent(this.previous_eredin_attack_index_2 , 2);

				switch (eredin_attack_index_2) 
				{	
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_attack_rp_03_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_attack_rp_02_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_eredin_attack_index_2 = eredin_attack_index_2;
			}				
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			eredin_attack_index_3 = RandDifferent(this.previous_eredin_attack_index_3 , 3);

			switch (eredin_attack_index_3) 
			{					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_attack_push_lp_ACS', 'PLAYER_SLOT', settings);
				ACS_Shield().PlayEffect('aard_cone_hit');
				ACS_Shield().StopEffect('aard_cone_hit');
				break;
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_attack_rp_03_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_attack_rp_02_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_eredin_attack_index_3 = eredin_attack_index_3;
		}
	}
	
	function geraltRandomShieldSpecialAttackAlt()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
					
			eredin_attack_index_2 = RandDifferent(this.previous_eredin_attack_index_2 , 4);

			switch (eredin_attack_index_2) 
			{	
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_charge_attack_lf_l_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_charge_attack_rf_r_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_eredin_attack_index_2 = eredin_attack_index_2;				
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			eredin_attack_index_3 = RandDifferent(this.previous_eredin_attack_index_3 , 6);

			switch (eredin_attack_index_3) 
			{						
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_charge_attack_lf_l_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_charge_attack_rf_r_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_eredin_attack_index_3 = eredin_attack_index_3;
		}
	}
	
	function geraltRandomShieldSpecialAttack()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
				
			eredin_attack_index_2 = RandDifferent(this.previous_eredin_attack_index_2 , 4);

			switch (eredin_attack_index_2) 
			{	
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_taunt_rp_01_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_taunt_lp_03_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_taunt_lp_02_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_taunt_lp_01_ACS', 'PLAYER_SLOT', settings);
				break;
			}
			this.previous_eredin_attack_index_2 = eredin_attack_index_2;			
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			eredin_attack_index_3 = RandDifferent(this.previous_eredin_attack_index_3 , 2);

			switch (eredin_attack_index_3) 
			{							
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_taunt_rp_01_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_taunt_lp_03_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_taunt_lp_02_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_taunt_lp_01_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_eredin_attack_index_3 = eredin_attack_index_3;
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// Eredin attack stuff
	
	function geraltRandomEredinAttack() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if (targetDistance <= 1.5 * 1.5  )
			{	
				eredin_attack_index_1 = RandDifferent(this.previous_eredin_attack_index_1 , 6);

				switch (eredin_attack_index_1) 
				{	
					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_combo_stop_lll_1_ACS', 'PLAYER_SLOT', settings);
					break;

					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_combo_start_lll_1_ACS', 'PLAYER_SLOT', settings);
					break;

					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_1_right_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
					break;	
						
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_2_left_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
					break;
						
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_1_left_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
					break;	
						
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_2_right_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
					break;
				}
				
				this.previous_eredin_attack_index_1 = eredin_attack_index_1;
			}
			else if (targetDistance > 1.5 * 1.5 && targetDistance <= 5*5 )
			{		
				eredin_attack_index_2 = RandDifferent(this.previous_eredin_attack_index_2 , 6);

				switch (eredin_attack_index_2) 
				{	
					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_relaxed_left_45_READY_ACS', 'PLAYER_SLOT', settings);
					break;

					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_relaxed_forward_01_READY_ACS', 'PLAYER_SLOT', settings);
					break;			
				
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_lowswing_overhead_01_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_relaxed_right_45_READY_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_swingswingturnswing_01_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_swingswing_01_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_eredin_attack_index_2 = eredin_attack_index_2;
			}		
			else
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'walkattack_ready_lf_01_TO_IDLE_ACS', 'PLAYER_SLOT', settings);
			}		
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			eredin_attack_index_3 = RandDifferent(this.previous_eredin_attack_index_3 , 12);

			switch (eredin_attack_index_3) 
			{	
				case 11:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_1_right_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
				break;	
					
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_2_left_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_1_left_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
				break;	
					
				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_2_right_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
				break;

				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_relaxed_left_45_READY_ACS', 'PLAYER_SLOT', settings);
				break;

				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_relaxed_forward_01_READY_ACS', 'PLAYER_SLOT', settings);
				break;			
			
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_lowswing_overhead_01_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_relaxed_right_45_READY_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_swingswingturnswing_01_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_swingswing_01_ACS', 'PLAYER_SLOT', settings);
				break;

				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_combo_stop_lll_1_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_combo_start_lll_1_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_eredin_attack_index_3 = eredin_attack_index_3;
		}
	}

	function geraltRandomEredinComboAttack() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 2*2 ) 
			{
				eredin_combo_attack_index_1 = RandDifferent(this.previous_eredin_combo_attack_index_1 , 3);
				
				switch (eredin_combo_attack_index_1) 
				{					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_kickcombo_02_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_kickcombo_01_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_punchcombo_01_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_eredin_combo_attack_index_1 = eredin_combo_attack_index_1;
			}
			else if( targetDistance > 2*2 && targetDistance <= 3.5*3.5) 
			{
				eredin_combo_attack_index_2 = RandDifferent(this.previous_eredin_combo_attack_index_2 , 2);
				
				switch (eredin_combo_attack_index_2) 
				{	
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_swingswingturnswing_01_caretaker_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_swingswing_01_caretaker_ACS', 'PLAYER_SLOT', settings);
					break;
				}
				this.previous_eredin_combo_attack_index_2 = eredin_combo_attack_index_2;
			}
			else
			{
				eredin_combo_attack_index_2 = RandDifferent(this.previous_eredin_combo_attack_index_2 , 2);
				
				switch (eredin_combo_attack_index_2) 
				{	
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_combo_01_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_r_combo_01_caretaker_ACS', 'PLAYER_SLOT', settings);
					break;
				}
				this.previous_eredin_combo_attack_index_2 = eredin_combo_attack_index_2;
			}		
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			eredin_combo_attack_index_3 = RandDifferent(this.previous_eredin_combo_attack_index_3 , 7);
				
			switch (eredin_combo_attack_index_3) 
			{		
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_combo_01_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_kickcombo_02_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_kickcombo_01_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_punchcombo_01_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_swingswingturnswing_01_caretaker_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_swingswing_01_caretaker_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_r_combo_01_caretaker_ACS', 'PLAYER_SLOT', settings);
				break;
			}
			
			this.previous_eredin_combo_attack_index_3 = eredin_combo_attack_index_3;
		}
	}
	
	function geraltEredinStab() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}

			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_stab_caretaker_ACS', 'PLAYER_SLOT', settings);

			thePlayer.AddTag('ACS_Eredin_Stab');

			AddTimer('ACS_bruxa_tackle', 0.5 / theGame.GetTimeScale() , false);
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_stab_caretaker_ACS', 'PLAYER_SLOT', settings);
		}
	}
	
	function geraltEredinFuryCombo() 
	{
		MovementAdjust();

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 3 * 3 ) 
			{	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_furycombo_01_ACS', 'PLAYER_SLOT', settings);
			}
			else if( targetDistance > 3 * 3 
			&& targetDistance <= 4 * 4 ) 
			{	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_light2heavy_01_ACS', 'PLAYER_SLOT', settings);
			}
			else
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_furycombo_02_ACS', 'PLAYER_SLOT', settings);
			}	
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_furycombo_02_ACS', 'PLAYER_SLOT', settings);
		}
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	function geraltRandomEredinHeavyAttackAlt()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if (targetDistance <= 1.5 * 1.5 )
			{	
				eredin_attack_index_1 = RandDifferent(this.previous_eredin_attack_index_1 , 2);

				switch (eredin_attack_index_1) 
				{	
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_1_right_ACS', 'PLAYER_SLOT', settings);
					break;			
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_1_left_ACS', 'PLAYER_SLOT', settings);
					break;
				}
				
				this.previous_eredin_attack_index_1 = eredin_attack_index_1;
			}
			else
			{		
				eredin_attack_index_2 = RandDifferent(this.previous_eredin_attack_index_2 , 2);

				switch (eredin_attack_index_2) 
				{		
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_2_right_ACS', 'PLAYER_SLOT', settings);
					break;	

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_2_left_ACS', 'PLAYER_SLOT', settings);
					break;	
				}
				
				this.previous_eredin_attack_index_2 = eredin_attack_index_2;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			eredin_combo_attack_index_3 = RandDifferent(this.previous_eredin_combo_attack_index_3 , 4);
				
			switch (eredin_combo_attack_index_3) 
			{		
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_2_right_ACS', 'PLAYER_SLOT', settings);
				break;	

				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_2_left_ACS', 'PLAYER_SLOT', settings);
				break;	

				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_1_right_ACS', 'PLAYER_SLOT', settings);
				break;			
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_h_1_left_ACS', 'PLAYER_SLOT', settings);
				break;
			}
			
			this.previous_eredin_combo_attack_index_3 = eredin_combo_attack_index_3;
		}
	}
	
	function geraltRandomEredinHeavyAttack()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if (targetDistance <= 1.5 * 1.5 )
			{	
				eredin_attack_index_1 = RandDifferent(this.previous_eredin_attack_index_1 , 4);

				switch (eredin_attack_index_1) 
				{	
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_lowswing_overhead_01_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_relaxed_left_45_READY_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_relaxed_right_45_READY_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_relaxed_forward_01_READY_ACS', 'PLAYER_SLOT', settings);
					break;
				}
				
				this.previous_eredin_attack_index_1 = eredin_attack_index_1;
			}
			else
			{		
				eredin_attack_index_2 = RandDifferent(this.previous_eredin_attack_index_2 , 6);

				switch (eredin_attack_index_2) 
				{		
					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_l_06_lp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_l_04_rp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_l_01_rp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_01_rp_ACS', 'PLAYER_SLOT', settings);
					break;
				
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_01_lp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_eredin_attack_index_2 = eredin_attack_index_2;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			eredin_combo_attack_index_3 = RandDifferent(this.previous_eredin_combo_attack_index_3 , 10);
				
			switch (eredin_combo_attack_index_3) 
			{	
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_lowswing_overhead_01_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_relaxed_left_45_READY_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_relaxed_right_45_READY_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_relaxed_forward_01_READY_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_l_06_lp_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_l_04_rp_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_l_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
			}
			
			this.previous_eredin_combo_attack_index_3 = eredin_combo_attack_index_3;
		}
	}
	
	function geraltRandomEredinLightAttackAlt()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			eredin_combo_attack_index_1 = RandDifferent(this.previous_eredin_combo_attack_index_1 , 3);
				
			switch (eredin_combo_attack_index_1) 
			{					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_kickcombo_02_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_kickcombo_01_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_punchcombo_01_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_eredin_combo_attack_index_1 = eredin_combo_attack_index_1;		
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			eredin_combo_attack_index_3 = RandDifferent(this.previous_eredin_combo_attack_index_3 , 3);
				
			switch (eredin_combo_attack_index_3) 
			{		
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_kickcombo_02_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_kickcombo_01_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_punchcombo_01_ACS', 'PLAYER_SLOT', settings);
				break;
			}
			
			this.previous_eredin_combo_attack_index_3 = eredin_combo_attack_index_3;
		}
	}
	
	function geraltRandomEredinLightAttack()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if (targetDistance <= 1.5 * 1.5 )
			{	
				eredin_attack_index_1 = RandDifferent(this.previous_eredin_attack_index_1 , 3);

				switch (eredin_attack_index_1) 
				{	
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_combo_stop_lll_1_ACS', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_combo_start_lll_1_ACS', 'PLAYER_SLOT', settings);
					break;
				}
				
				this.previous_eredin_attack_index_1 = eredin_attack_index_1;
			}
			else if (targetDistance > 1.5 * 1.5 && targetDistance <= 5*5 )
			{		
				eredin_attack_index_2 = RandDifferent(this.previous_eredin_attack_index_2 , 4);

				switch (eredin_attack_index_2) 
				{		
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_1_right_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
					break;	
						
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_2_left_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
					break;
						
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_1_left_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
					break;	
						
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_2_right_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_eredin_attack_index_2 = eredin_attack_index_2;
			}		
			else
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'walkattack_ready_lf_01_TO_IDLE_ACS', 'PLAYER_SLOT', settings);
			}		
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			eredin_attack_index_3 = RandDifferent(this.previous_eredin_attack_index_3 , 6);

			switch (eredin_attack_index_3) 
			{		
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_combo_stop_lll_1_ACS', 'PLAYER_SLOT', settings);
				break;

				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_combo_start_lll_1_ACS', 'PLAYER_SLOT', settings);
				break;

				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_1_right_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
				break;	
					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_2_left_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_1_left_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
				break;	
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_attack_l_2_right_NEW_LONG_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_eredin_attack_index_3 = eredin_attack_index_3;
		}
	}
	
	function geraltRandomEredinSpecialAttackAlt()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}

			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_stab_caretaker_ACS', 'PLAYER_SLOT', settings);

			thePlayer.AddTag('ACS_Eredin_Stab');

			AddTimer('ACS_bruxa_tackle', 0.5 / theGame.GetTimeScale() , false);
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_special_stab_caretaker_ACS', 'PLAYER_SLOT', settings);
		}
	}
	
	function geraltRandomEredinSpecialAttack()
	{
		MovementAdjust();

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 3 * 3 ) 
			{	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_furycombo_01_ACS', 'PLAYER_SLOT', settings);
			}
			else if( targetDistance > 3 * 3 
			&& targetDistance <= 4 * 4 ) 
			{	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_light2heavy_01_ACS', 'PLAYER_SLOT', settings);
			}
			else
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_furycombo_02_ACS', 'PLAYER_SLOT', settings);
			}	
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_ready_furycombo_02_ACS', 'PLAYER_SLOT', settings);
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// Imlerith Attack Stuff

	function geraltRandomImlerithAttack() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 3.5 * 3.5 ) 
			{	
				imlerith_attack_index_1 = RandDifferent(this.previous_imlerith_attack_index_1 , 8);

				switch (imlerith_attack_index_1) 
				{				
					case 7:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 6:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_special_01_lp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_05_rp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_04_rp_ACS', 'PLAYER_SLOT', settings);
					break;
						
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_03_rp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_03_lp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_02_rp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_02_lp_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_imlerith_attack_index_1 = imlerith_attack_index_1;
			}
			else
			{
				imlerith_attack_index_2 = RandDifferent(this.previous_imlerith_attack_index_2 , 12);

				switch (imlerith_attack_index_2) 
				{		
					/*
					case 17:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_guard_attack_right_45_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 16:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_guard_attack_left_45_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 15:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_guard_attack_forward_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 14:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_idle_right_45_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;

					case 13:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_idle_left_45_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					*/
					
					/*
					case 11:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_idle_backhandturn_right_45_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 10:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_idle_backhandturn_left_45_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					*/
					
					/*
					case 8:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_guard_right_45_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
						
					case 7:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_guard_left_45_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					*/
					
					/*
					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_right_45_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_left_45_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					*/

					case 11:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shield_thrust_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 10:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_swing_shield_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 9:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_swing_shield_swing_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 8:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_thrust_shield_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 7:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'taunt_after_death_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;

					case 6:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_idle_forward_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;

					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_idle_backhandturn_forward_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;

					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_guard_forward_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;

					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_front_03_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_front_02_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_03_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_01_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_imlerith_attack_index_2 = imlerith_attack_index_2;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			imlerith_attack_index_3 = RandDifferent(this.previous_imlerith_attack_index_3 , 21);

			switch (imlerith_attack_index_3) 
			{	
				/*
				case 25:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_guard_attack_right_45_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 24:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_guard_attack_left_45_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				*/

				/*	
				case 22:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_idle_right_45_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;

				case 21:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_idle_left_45_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				*/

				/*
				case 19:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_idle_backhandturn_right_45_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 18:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_idle_backhandturn_left_45_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				*/

				/*	
				case 16:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_guard_right_45_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
						
				case 15:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_guard_left_45_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				*/
				
				/*
				case 13:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_right_45_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 12:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_left_45_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				*/

				case 20:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shield_thrust_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 19:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_swing_shield_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 18:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_swing_shield_swing_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 17:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_thrust_shield_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 16:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'taunt_after_death_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;

				case 15:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_guard_attack_forward_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;

				case 14:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_idle_forward_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;

				case 13:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_idle_backhandturn_forward_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;

				case 12:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_guard_forward_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;

				case 11:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_special_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_05_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_04_rp_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_03_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_front_03_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_front_02_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_03_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_01_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_imlerith_attack_index_3 = imlerith_attack_index_3;
		}	
	}

	function geraltRandomImlerithBerserkAttack() 
	{
		

		yrden_sword_effect_around();

		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 3.5 * 3.5 ) 
			{	
				imlerith_berserk_attack_index_1 = RandDifferent(this.previous_imlerith_berserk_attack_index_1 , 6);

				switch (imlerith_berserk_attack_index_1) 
				{	
					/*						
					case 7:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_stuck_attack_right_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 6:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_stuck_attack_left_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					*/

					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_stuck_attack_forward_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_start_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_stuck_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;		
									
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_1_caretaker_ACS', 'PLAYER_SLOT', settings);
					break;			
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_single_02_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_single_01_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;		
				}
				
				this.previous_imlerith_berserk_attack_index_1 = imlerith_berserk_attack_index_1;
			}
			else
			{
				imlerith_berserk_attack_index_2 = RandDifferent(this.previous_imlerith_berserk_attack_index_2 , 3);

				switch (imlerith_berserk_attack_index_2) 
				{								
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_tornado_01_unused_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_whirlwind_02_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_whirlwind_01_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;	
				}
				
				this.previous_imlerith_berserk_attack_index_2 = imlerith_berserk_attack_index_2;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			imlerith_berserk_attack_index_3 = RandDifferent(this.previous_imlerith_berserk_attack_index_3 , 9);

			switch (imlerith_berserk_attack_index_3) 
			{	
				/*
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_stuck_attack_right_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_stuck_attack_left_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				*/

				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_stuck_attack_forward_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_start_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_stuck_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_1_caretaker_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_single_02_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_single_01_imlerith_ACS', 'PLAYER_SLOT', settings);				
				break;	
					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_tornado_01_unused_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_whirlwind_02_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_whirlwind_01_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;	
			}

			this.previous_imlerith_berserk_attack_index_3 = imlerith_berserk_attack_index_3;
		}	
	}
	
	function geraltImlerithWalkAttack() 
	{
		

		yrden_sword_effect_big();

		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			imlerith_walk_attack_index_1 = RandDifferent(this.previous_imlerith_walk_attack_index_1 , 3);

			switch (imlerith_walk_attack_index_1) 
			{	
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'walk_attack_rightfoot_forward_01_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'walk_attack_leftfoot_forward_02_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
		
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'walk_attack_leftfoot_forward_01_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_imlerith_walk_attack_index_1 = imlerith_walk_attack_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			imlerith_walk_attack_index_2 = RandDifferent(this.previous_imlerith_walk_attack_index_2 , 3);

			switch (imlerith_walk_attack_index_2) 
			{	
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'walk_attack_rightfoot_forward_01_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'walk_attack_leftfoot_forward_02_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
		
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'walk_attack_leftfoot_forward_01_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_imlerith_walk_attack_index_2 = imlerith_walk_attack_index_2;
		}
	}

	function geraltRandomImlerithComboAttack() 
	{
		

		yrden_sword_effect_around();

		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
		
			imlerith_combo_attack_index_1 = RandDifferent(this.previous_imlerith_combo_attack_index_1 , 6);

			switch (imlerith_combo_attack_index_1) 
			{	
				/*
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_7_attacks_01_unused_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				*/

				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_combo_01_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_4_attacks_01_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_3_attacks_03_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_3_attacks_02_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_3_attacks_01_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_2_attacks_03_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				/*
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_2_attacks_02_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				*/
			}	
			this.previous_imlerith_combo_attack_index_1 = imlerith_combo_attack_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			imlerith_combo_attack_index_2 = RandDifferent(this.previous_imlerith_combo_attack_index_2 , 6);

			switch (imlerith_combo_attack_index_2) 
			{	
				/*
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_7_attacks_01_unused_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				*/

				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_combo_01_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_4_attacks_01_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_3_attacks_03_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_3_attacks_02_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_3_attacks_01_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_2_attacks_03_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				/*
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_2_attacks_02_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				*/
			}	
			this.previous_imlerith_combo_attack_index_2 = imlerith_combo_attack_index_2;
		}	
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	function geraltRandomImlerithHeavyAttackAlt()
	{
		yrden_sword_effect_big();

		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 2 * 2 ) 
			{	
				imlerith_attack_index_1 = RandDifferent(this.previous_imlerith_attack_index_1 , 5);

				switch (imlerith_attack_index_1) 
				{					
					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_idle_backhandturn_forward_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
						
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_idle_forward_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_guard_forward_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_03_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_01_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_imlerith_attack_index_1 = imlerith_attack_index_1;
			}
			else
			{
				imlerith_attack_index_2 = RandDifferent(this.previous_imlerith_attack_index_2 , 5);

				switch (imlerith_attack_index_2) 
				{	
					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_front_03_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_front_02_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'walk_attack_rightfoot_forward_01_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'walk_attack_leftfoot_forward_02_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
			
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'walk_attack_leftfoot_forward_01_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_imlerith_attack_index_2 = imlerith_attack_index_2;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			imlerith_attack_index_3 = RandDifferent(this.previous_imlerith_attack_index_3 , 10);

			switch (imlerith_attack_index_3) 
			{	
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'walk_attack_rightfoot_forward_01_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'walk_attack_leftfoot_forward_02_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
			
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'walk_attack_leftfoot_forward_01_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_idle_backhandturn_forward_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_idle_forward_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_guard_forward_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_03_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_fast_01_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_front_03_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_front_02_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_imlerith_attack_index_3 = imlerith_attack_index_3;
		}
	}
	
	function geraltRandomImlerithHeavyAttack()
	{	
		

		yrden_sword_effect_big();

		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 2.5 * 2.5 ) 
			{	
				/*
				imlerith_attack_index_1 = RandDifferent(this.previous_imlerith_attack_index_1 , 2);

				switch (imlerith_attack_index_1) 
				{	
								
					case 7:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_right_45_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 6:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_left_45_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_idle_right_45_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_idle_left_45_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
						
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_idle_backhandturn_right_45_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_idle_backhandturn_left_45_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_guard_right_45_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_guard_left_45_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					

					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_swing_shield_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_swing_shield_swing_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_imlerith_attack_index_1 = imlerith_attack_index_1;
				*/

				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_1_caretaker_ACS', 'PLAYER_SLOT', settings);
			}
			else
			{
				//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_1_caretaker_ACS', 'PLAYER_SLOT', settings);

				imlerith_attack_index_2 = RandDifferent(this.previous_imlerith_attack_index_2 , 2);

				switch (imlerith_attack_index_2) 
				{	
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_swing_shield_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_swing_shield_swing_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_imlerith_attack_index_2 = imlerith_attack_index_2;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			imlerith_attack_index_3 = RandDifferent(this.previous_imlerith_attack_index_3 , 10);

			switch (imlerith_attack_index_3) 
			{	
				/*
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_right_45_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_counter_left_45_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_idle_right_45_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_idle_left_45_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_idle_backhandturn_right_45_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_idle_backhandturn_left_45_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_guard_right_45_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_guard_left_45_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				*/
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_swing_shield_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_swing_shield_swing_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_heavy_1_caretaker_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_imlerith_attack_index_3 = imlerith_attack_index_3;
		}
	}
	
	function geraltRandomImlerithLightAttackAlt()
	{	
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 3.5 * 3.5 ) 
			{	
				imlerith_attack_index_1 = RandDifferent(this.previous_imlerith_attack_index_1 , 6);

				switch (imlerith_attack_index_1) 
				{					
					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_05_rp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_04_rp_ACS', 'PLAYER_SLOT', settings);
					break;
						
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_03_rp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_03_lp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_02_rp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_02_lp_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_imlerith_attack_index_1 = imlerith_attack_index_1;
			}
			else
			{
				imlerith_attack_index_2 = RandDifferent(this.previous_imlerith_attack_index_2 , 2);

				switch (imlerith_attack_index_2) 
				{	
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_special_01_lp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_imlerith_attack_index_2 = imlerith_attack_index_2;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			imlerith_attack_index_3 = RandDifferent(this.previous_imlerith_attack_index_3 , 8);

			switch (imlerith_attack_index_3) 
			{	
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_05_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_04_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_03_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_special_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_imlerith_attack_index_3 = imlerith_attack_index_3;
		}				
	}
	
	function geraltRandomImlerithLightAttack()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
	
			imlerith_attack_index_1 = RandDifferent(this.previous_imlerith_attack_index_1 , 4);

			switch (imlerith_attack_index_1) 
			{					
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_guard_attack_forward_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				/*
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_guard_attack_left_45_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_guard_attack_right_45_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				*/

				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'taunt_after_death_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shield_thrust_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_thrust_shield_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_imlerith_attack_index_1 = imlerith_attack_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			imlerith_attack_index_3 = RandDifferent(this.previous_imlerith_attack_index_3 , 4);

			switch (imlerith_attack_index_3) 
			{	
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_guard_attack_forward_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				/*
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_guard_attack_left_45_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'hit_guard_attack_right_45_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				*/

				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'taunt_after_death_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_shield_thrust_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_thrust_shield_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
			}

			this.previous_imlerith_attack_index_3 = imlerith_attack_index_3;
		}
	}
	
	function geraltRandomImlerithSpecialAttackAlt()
	{
		

		yrden_sword_effect_around();

		MovementAdjust();
		
		if( ACS_AttitudeCheck (actor) )
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 3.5 * 3.5 ) 
			{	
				imlerith_berserk_attack_index_1 = RandDifferent(this.previous_imlerith_berserk_attack_index_1 , 5);

				switch (imlerith_berserk_attack_index_1) 
				{	
					/*						
					case 7:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_stuck_attack_right_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 6:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_stuck_attack_left_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					*/

					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_stuck_attack_forward_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_start_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_stuck_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;				
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_single_02_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_single_01_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;		
				}
				
				this.previous_imlerith_berserk_attack_index_1 = imlerith_berserk_attack_index_1;
			}
			else
			{
				imlerith_berserk_attack_index_2 = RandDifferent(this.previous_imlerith_berserk_attack_index_2 , 3);

				switch (imlerith_berserk_attack_index_2) 
				{								
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_tornado_01_unused_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_whirlwind_02_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_whirlwind_01_imlerith_ACS', 'PLAYER_SLOT', settings);
					break;	
				}
				
				this.previous_imlerith_berserk_attack_index_2 = imlerith_berserk_attack_index_2;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			imlerith_berserk_attack_index_3 = RandDifferent(this.previous_imlerith_berserk_attack_index_3 , 8);

			switch (imlerith_berserk_attack_index_3) 
			{	
				/*
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_stuck_attack_right_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_stuck_attack_left_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				*/

				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_stuck_attack_forward_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_start_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_stuck_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_single_02_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_single_01_imlerith_ACS', 'PLAYER_SLOT', settings);				
				break;	
					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_tornado_01_unused_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_whirlwind_02_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_whirlwind_01_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;	
			}

			this.previous_imlerith_berserk_attack_index_3 = imlerith_berserk_attack_index_3;
		}
	}
	
	function geraltRandomImlerithSpecialAttack()
	{
		

		yrden_sword_effect_around();;

		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
		
			imlerith_combo_attack_index_1 = RandDifferent(this.previous_imlerith_combo_attack_index_1 , 7);

			switch (imlerith_combo_attack_index_1) 
			{	
				/*
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_7_attacks_01_unused_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				*/

				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_combo_01_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_4_attacks_01_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_3_attacks_03_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_3_attacks_02_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_3_attacks_01_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_2_attacks_03_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				/*
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_2_attacks_02_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				*/
			}	
			this.previous_imlerith_combo_attack_index_1 = imlerith_combo_attack_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			imlerith_combo_attack_index_2 = RandDifferent(this.previous_imlerith_combo_attack_index_2 , 6);

			switch (imlerith_combo_attack_index_2) 
			{	
				/*
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_7_attacks_01_unused_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				*/

				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'attack_combo_01_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_4_attacks_01_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_3_attacks_03_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_3_attacks_02_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_3_attacks_01_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_2_attacks_03_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				
				/*
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'berserk_attack_combo_2_attacks_02_imlerith_ACS', 'PLAYER_SLOT', settings);
				break;
				*/
			}	
			this.previous_imlerith_combo_attack_index_2 = imlerith_combo_attack_index_2;
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// Spear Attack Stuff
	
	function geraltRandomSpearAttack() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 2.5*2.5 ) 
			{	
				spear_attack_index_1 = RandDifferent(this.previous_spear_attack_index_1 , 5);

				switch (spear_attack_index_1) 
				{	
					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_melee_attack_02_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_melee_attack_01_ACS', 'PLAYER_SLOT', settings);
					break;
				
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_05_rp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_02_rp_ACS', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_01_rp_ACS', 'PLAYER_SLOT', settings);
					break;
				}
		
				this.previous_spear_attack_index_1 = spear_attack_index_1;
			}
			else
			{
				spear_attack_index_2 = RandDifferent(this.previous_spear_attack_index_2 , 7);

				switch (spear_attack_index_2) 
				{						
					case 6:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_special_04_rp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_special_03_rp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_special_02_rp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
					break;
				
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_03_rp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_02_rp_ACS', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_01_rp_ACS', 'PLAYER_SLOT', settings);
					break;
				}
				
				this.previous_spear_attack_index_2 = spear_attack_index_2;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			spear_attack_index_3 = RandDifferent(this.previous_spear_attack_index_3 , 12);

			switch (spear_attack_index_3) 
			{	
				case 11:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_melee_attack_02_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_melee_attack_01_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_special_04_rp_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_special_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_special_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_05_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;

				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
			}
			
			this.previous_spear_attack_index_3 = spear_attack_index_3;
		}	
	}
	
	function geraltRandomSpearAttackAlt() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 2.5*2.5 ) 
			{	
				spear_special_attack_index_1 = RandDifferent(this.previous_spear_special_attack_index_1 , 9);

				switch (spear_special_attack_index_1) 
				{	
					case 8:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_lightning_01_ACS', 'PLAYER_SLOT', settings);
					break;	
					
					case 7:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_lightning_02_ACS', 'PLAYER_SLOT', settings);
					break;	
					
					case 6:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_fireball_02_ACS', 'PLAYER_SLOT', settings);
					break;	
					
					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_force_blast_01_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_force_blast_02_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_force_blast_03_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_04_rp_ACS', 'PLAYER_SLOT', settings);
					break;
				
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_03_rp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
					break;
				}
		
				this.previous_spear_special_attack_index_1 = spear_special_attack_index_1;
			}
			else
			{
				spear_special_attack_index_2 = RandDifferent(this.previous_spear_special_attack_index_2 , 2);

				switch (spear_special_attack_index_2) 
				{
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_melee_attack_04_ACS', 'PLAYER_SLOT', settings);
					break;		
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_melee_attack_03_ACS', 'PLAYER_SLOT', settings);
					break;					
				}
				
				this.previous_spear_special_attack_index_2 = spear_special_attack_index_2;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			spear_special_attack_index_3 = RandDifferent(this.previous_spear_special_attack_index_3 , 11);

			switch (spear_special_attack_index_3) 
			{	
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_force_blast_01_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_force_blast_02_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_force_blast_03_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_lightning_01_ACS', 'PLAYER_SLOT', settings);
				break;	
					
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_lightning_02_ACS', 'PLAYER_SLOT', settings);
				break;	
					
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_fireball_02_ACS', 'PLAYER_SLOT', settings);
				break;	
					
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_04_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_melee_attack_04_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_melee_attack_03_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
			}
			
			this.previous_spear_special_attack_index_3 = spear_special_attack_index_3;
		}		
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	
	function geraltRandomSpearLightAttackAlt()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 3.5 * 3.5 ) 
			{	
				spear_attack_index_1 = RandDifferent(this.previous_spear_attack_index_1 , 2);

				switch (spear_attack_index_1) 
				{	
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_fireball_02_ACS', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_01_rp_ACS', 'PLAYER_SLOT', settings);
					break;
				}
		
				this.previous_spear_attack_index_1 = spear_attack_index_1;
			}
			else
			{
				spear_attack_index_2 = RandDifferent(this.previous_spear_attack_index_2 , 2);

				switch (spear_attack_index_2) 
				{						
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_melee_attack_02_ACS', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_melee_attack_01_ACS', 'PLAYER_SLOT', settings);
					break;
				}
				
				this.previous_spear_attack_index_2 = spear_attack_index_2;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			spear_attack_index_3 = RandDifferent(this.previous_spear_attack_index_3 , 4);

			switch (spear_attack_index_3) 
			{	
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_fireball_02_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_melee_attack_02_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_melee_attack_01_ACS', 'PLAYER_SLOT', settings);
				break;
			}
			
			this.previous_spear_attack_index_3 = spear_attack_index_3;
		}	
	}
	
	function geraltRandomSpearLightAttack()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 1.75 * 1.75 ) 
			{		
				spear_attack_index_1 = RandDifferent(this.previous_spear_attack_index_1 , 2);

				switch (spear_attack_index_1) 
				{	
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_force_blast_03_ACS', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_force_blast_01_ACS', 'PLAYER_SLOT', settings);
					break;
				}
		
				this.previous_spear_attack_index_1 = spear_attack_index_1;
			}
			else
			{
				spear_attack_index_2 = RandDifferent(this.previous_spear_attack_index_2 , 4);

				switch (spear_attack_index_2) 
				{	
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_lightning_01_ACS', 'PLAYER_SLOT', settings);
					break;

					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_05_rp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_02_rp_ACS', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_01_rp_ACS', 'PLAYER_SLOT', settings);
					break;
				}
				
				this.previous_spear_attack_index_2 = spear_attack_index_2;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			spear_attack_index_3 = RandDifferent(this.previous_spear_attack_index_3 , 6);

			switch (spear_attack_index_3) 
			{	
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_lightning_01_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_force_blast_03_ACS', 'PLAYER_SLOT', settings);
				break;

				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_force_blast_01_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_05_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
			}
			
			this.previous_spear_attack_index_3 = spear_attack_index_3;
		}	
	}
	
	function geraltRandomSpearHeavyAttackAlt()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 3.5 * 3.5 ) 
			{	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_02_rp_ACS', 'PLAYER_SLOT', settings);
			}
			else
			{
				spear_attack_index_2 = RandDifferent(this.previous_spear_attack_index_2 , 2);

				switch (spear_attack_index_2) 
				{						
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_special_04_rp_ACS', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
					break;
				}
				
				this.previous_spear_attack_index_2 = spear_attack_index_2;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			spear_attack_index_3 = RandDifferent(this.previous_spear_attack_index_3 , 3);

			switch (spear_attack_index_3) 
			{	
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_special_04_rp_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
			}
			
			this.previous_spear_attack_index_3 = spear_attack_index_3;
		}
	}
	
	function geraltRandomSpearHeavyAttack()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 3.5 * 3.5 ) 
			{	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_03_rp_ACS', 'PLAYER_SLOT', settings);
			}
			else
			{
				spear_attack_index_2 = RandDifferent(this.previous_spear_attack_index_2 , 2);

				switch (spear_attack_index_2) 
				{						
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_special_03_rp_ACS', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_special_02_rp_ACS', 'PLAYER_SLOT', settings);
					break;
				}
				
				this.previous_spear_attack_index_2 = spear_attack_index_2;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			spear_attack_index_3 = RandDifferent(this.previous_spear_attack_index_3 , 3);

			switch (spear_attack_index_3) 
			{	
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_special_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hspear_attack_special_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
			}
			
			this.previous_spear_attack_index_3 = spear_attack_index_3;
		}	
	}
	
	function geraltRandomSpearSpecialAttackAlt()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 2.5*2.5 ) 
			{	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_lightning_02_ACS', 'PLAYER_SLOT', settings);
			}
			else
			{
				spear_special_attack_index_2 = RandDifferent(this.previous_spear_special_attack_index_2 , 2);

				switch (spear_special_attack_index_2) 
				{
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_melee_attack_04_ACS', 'PLAYER_SLOT', settings);
					break;		
					
					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_melee_attack_03_ACS', 'PLAYER_SLOT', settings);
					break;					
				}
				
				this.previous_spear_special_attack_index_2 = spear_special_attack_index_2;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			spear_special_attack_index_3 = RandDifferent(this.previous_spear_special_attack_index_3 , 3);

			switch (spear_special_attack_index_3) 
			{		
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_lightning_02_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_melee_attack_04_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_melee_attack_03_ACS', 'PLAYER_SLOT', settings);
				break;
			}
			
			this.previous_spear_special_attack_index_3 = spear_special_attack_index_3;
		}
	}
	
	function geraltRandomSpearSpecialAttack()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 2.5*2.5 ) 
			{	
				spear_attack_index_1 = RandDifferent(this.previous_spear_attack_index_1 , 5);

				switch (spear_attack_index_1) 
				{	
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_force_blast_03_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_04_rp_ACS', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_03_rp_ACS', 'PLAYER_SLOT', settings);
					break;
				}
		
				this.previous_spear_attack_index_1 = spear_attack_index_1;
			}
			else
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			spear_special_attack_index_3 = RandDifferent(this.previous_spear_special_attack_index_3 , 4);

			switch (spear_special_attack_index_3) 
			{	
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_mage_force_blast_03_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_04_rp_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhalberd_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
			}
			
			this.previous_spear_special_attack_index_3 = spear_special_attack_index_3;
		}	
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// Hammer Attack Stuff
	
	function geraltRandomHammerAttack() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			hammer_attack_index_1 = RandDifferent(this.previous_hammer_attack_index_1 , 14);

			switch (hammer_attack_index_1) 
			{								
				case 13:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_05_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 12:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_04_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 11:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_03_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_h_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_h_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_h_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_h_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_special_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_hammer_attack_index_1 = hammer_attack_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			hammer_attack_index_1 = RandDifferent(this.previous_hammer_attack_index_1 , 14);

			switch (hammer_attack_index_1) 
			{								
				case 13:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_05_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 12:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_04_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 11:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_03_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_h_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_h_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_h_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_h_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_special_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_hammer_attack_index_1 = hammer_attack_index_1;
		}	
	}
	
	function geraltRandomHammerSpecialAttack() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			hammer_special_attack_index_1 = RandDifferent(this.previous_hammer_special_attack_index_1 , 6);

			switch (hammer_special_attack_index_1) 
			{					
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_attack_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_attack_03_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_attack_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_attack_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_attack_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_attack_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_hammer_special_attack_index_1 = hammer_special_attack_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			hammer_special_attack_index_2 = RandDifferent(this.previous_hammer_special_attack_index_2 , 6);

			switch (hammer_special_attack_index_2) 
			{					
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_attack_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_attack_03_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_attack_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_attack_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_attack_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_attack_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_hammer_special_attack_index_2 = hammer_special_attack_index_2;
		}				
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	function geraltRandomGiantLightAttackAlt()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			hammer_attack_index_1 = RandDifferent(this.previous_hammer_attack_index_1 , 4);

			switch (hammer_attack_index_1) 
			{										
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_05_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_04_rp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_hammer_attack_index_1 = hammer_attack_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			hammer_attack_index_1 = RandDifferent(this.previous_hammer_attack_index_1 , 4);

			switch (hammer_attack_index_1) 
			{								
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_05_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_04_rp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_hammer_attack_index_1 = hammer_attack_index_1;
		}
	}
	
	function geraltRandomGiantLightAttack()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			hammer_attack_index_1 = RandDifferent(this.previous_hammer_attack_index_1 , 4);

			switch (hammer_attack_index_1) 
			{										
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_03_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_hammer_attack_index_1 = hammer_attack_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			hammer_attack_index_1 = RandDifferent(this.previous_hammer_attack_index_1 , 4);

			switch (hammer_attack_index_1) 
			{								
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_03_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_hammer_attack_index_1 = hammer_attack_index_1;
		}
	}
	
	function geraltRandomGiantHeavyAttackAlt()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			hammer_special_attack_index_1 = RandDifferent(this.previous_hammer_special_attack_index_1 , 3);

			switch (hammer_special_attack_index_1) 
			{					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_attack_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_attack_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_attack_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_hammer_special_attack_index_1 = hammer_special_attack_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			hammer_special_attack_index_2 = RandDifferent(this.previous_hammer_special_attack_index_2 , 3);

			switch (hammer_special_attack_index_2) 
			{					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_attack_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_attack_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_attack_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_hammer_special_attack_index_2 = hammer_special_attack_index_2;
		}
	}
	
	function geraltRandomGiantHeavyAttack()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			hammer_special_attack_index_1 = RandDifferent(this.previous_hammer_special_attack_index_1 , 3);

			switch (hammer_special_attack_index_1) 
			{					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_attack_03_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_attack_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_attack_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_hammer_special_attack_index_1 = hammer_special_attack_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			hammer_special_attack_index_2 = RandDifferent(this.previous_hammer_special_attack_index_2 , 3);

			switch (hammer_special_attack_index_2) 
			{					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_attack_03_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_attack_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2hhammer_attack_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_hammer_special_attack_index_2 = hammer_special_attack_index_2;
		}
	}
	
	function geraltRandomGiantSpecialAttackAlt()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			hammer_attack_index_1 = RandDifferent(this.previous_hammer_attack_index_1 , 4);

			switch (hammer_attack_index_1) 
			{										
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_h_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_h_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_h_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_h_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_hammer_attack_index_1 = hammer_attack_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			hammer_attack_index_1 = RandDifferent(this.previous_hammer_attack_index_1 , 4);

			switch (hammer_attack_index_1) 
			{								
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_h_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_h_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_h_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_h_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_hammer_attack_index_1 = hammer_attack_index_1;
		}
	}
	
	function geraltRandomGiantSpecialAttack()
	{			
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			hammer_attack_index_1 = RandDifferent(this.previous_hammer_attack_index_1 , 4);

			switch (hammer_attack_index_1) 
			{										
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_special_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_hammer_attack_index_1 = hammer_attack_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			hammer_attack_index_1 = RandDifferent(this.previous_hammer_attack_index_1 , 4);

			switch (hammer_attack_index_1) 
			{								
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_special_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_hammer_attack_index_1 = hammer_attack_index_1;
		}
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// Axe Attack Stuff
	
	function geraltRandomAxeAttack() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
	
			axe_attack_index_1 = RandDifferent(this.previous_axe_attack_index_1 , 7);

			switch (axe_attack_index_1) 
			{						
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_l_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_l_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_l_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_special_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_special_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_special_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_axe_attack_index_1 = axe_attack_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			axe_attack_index_2 = RandDifferent(this.previous_axe_attack_index_2 , 7);

			switch (axe_attack_index_2) 
			{						
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_l_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_l_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_l_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_special_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_special_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_special_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_axe_attack_index_2 = axe_attack_index_2;
		}				
	}
	
	function geraltRandomAxeAttackAlt() 
	{
		MovementAdjust();

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			axe_special_attack_index_1 = RandDifferent(this.previous_axe_special_attack_index_1 , 7);

			switch (axe_special_attack_index_1) 
			{								
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_04_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_03_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_axe_special_attack_index_1 = axe_special_attack_index_1;		
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			axe_special_attack_index_2 = RandDifferent(this.previous_axe_special_attack_index_2 , 7);

			switch (axe_special_attack_index_2) 
			{								
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_04_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_03_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_axe_special_attack_index_2 = axe_special_attack_index_2;		
		}
	}
	
	function geraltRandomAxeLightAttackAlt()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
	
			axe_attack_index_1 = RandDifferent(this.previous_axe_attack_index_1 , 4);

			switch (axe_attack_index_1) 
			{						
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_axe_attack_index_1 = axe_attack_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			axe_attack_index_2 = RandDifferent(this.previous_axe_attack_index_2 , 4);

			switch (axe_attack_index_2) 
			{						
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_mace_1hand_attack_l_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_axe_attack_index_2 = axe_attack_index_2;
		}	
	}
	
	function geraltRandomAxeLightAttack()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
	
			axe_attack_index_1 = RandDifferent(this.previous_axe_attack_index_1 , 3);

			switch (axe_attack_index_1) 
			{						
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_l_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_l_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_l_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
			}	
			this.previous_axe_attack_index_1 = axe_attack_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			axe_attack_index_2 = RandDifferent(this.previous_axe_attack_index_2 , 3);

			switch (axe_attack_index_2) 
			{						
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_l_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_l_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_l_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_axe_attack_index_2 = axe_attack_index_2;
		}	
	}
	
	function geraltRandomAxeHeavyAttackAlt()
	{	
		MovementAdjust();

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			axe_special_attack_index_1 = RandDifferent(this.previous_axe_special_attack_index_1 , 3);

			switch (axe_special_attack_index_1) 
			{									
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_04_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_03_lp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_axe_special_attack_index_1 = axe_special_attack_index_1;		
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			axe_special_attack_index_2 = RandDifferent(this.previous_axe_special_attack_index_2 , 3);

			switch (axe_special_attack_index_2) 
			{								
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_04_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_03_lp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_axe_special_attack_index_2 = axe_special_attack_index_2;		
		}
	}
	
	function geraltRandomAxeHeavyAttack()
	{
		MovementAdjust();

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			axe_special_attack_index_1 = RandDifferent(this.previous_axe_special_attack_index_1 , 4);

			switch (axe_special_attack_index_1) 
			{									
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_axe_special_attack_index_1 = axe_special_attack_index_1;		
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			axe_special_attack_index_2 = RandDifferent(this.previous_axe_special_attack_index_2 , 4);

			switch (axe_special_attack_index_2) 
			{								
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_2haxe_attack_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_axe_special_attack_index_2 = axe_special_attack_index_2;		
		}
	}
	
	function geraltRandomAxeSpecialAttackAlt()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
	
			axe_attack_index_1 = RandDifferent(this.previous_axe_attack_index_1 , 2);

			switch (axe_attack_index_1) 
			{						
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_special_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
			}	
			this.previous_axe_attack_index_1 = axe_attack_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			axe_attack_index_2 = RandDifferent(this.previous_axe_attack_index_2 , 2);

			switch (axe_attack_index_2) 
			{						
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_special_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_axe_attack_index_2 = axe_attack_index_2;
		}
	}
	
	function geraltRandomAxeSpecialAttack()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
	
			axe_attack_index_1 = RandDifferent(this.previous_axe_attack_index_1 , 2);

			switch (axe_attack_index_1) 
			{						
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_special_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_special_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
			}	
			this.previous_axe_attack_index_1 = axe_attack_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			axe_attack_index_2 = RandDifferent(this.previous_axe_attack_index_2 , 2);

			switch (axe_attack_index_2) 
			{						
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_special_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_axe_1hand_attack_special_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_axe_attack_index_2 = axe_attack_index_2;
		}
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// Greg Attack Stuff
	
	function geraltRandomGregAttack() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}

			if( targetDistance <= 1.5*1.5 ) 
			{
				greg_attack_index_1 = RandDifferent(this.previous_greg_attack_index_1 , 7);

				switch (greg_attack_index_1) 
				{				
					case 6:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_l_06_lp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_l_04_rp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_l_01_rp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_05_rp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_02_lp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_01_rp_ACS', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_01_lp_ACS', 'PLAYER_SLOT', settings);
					break;
				}	
				this.previous_greg_attack_index_1 = greg_attack_index_1;
			}
			else
			{
				greg_attack_index_1 = RandDifferent(this.previous_greg_attack_index_1 , 4);

				switch (greg_attack_index_1) 
				{				
					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_04_lp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_03_rp_ACS', 'PLAYER_SLOT', settings);
					break;
					
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_03_lp_ACS', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_02_rp_ACS', 'PLAYER_SLOT', settings);
					break;
				}	
				this.previous_greg_attack_index_1 = greg_attack_index_1;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			greg_attack_index_2 = RandDifferent(this.previous_greg_attack_index_2, 12);

			switch (greg_attack_index_2) 
			{				
				case 11:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_l_06_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_l_04_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_l_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_05_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_04_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_03_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_greg_attack_index_2 = greg_attack_index_2;
		}			
	}

	function geraltRandomGregAttackAlt() 
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{	
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}
			
			if( targetDistance <= 1.5 * 1.5 ) 
			{		
				//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'gregoire_attack_punch_ACS', 'PLAYER_SLOT', settings);

				punch_index_1 = RandDifferent(this.previous_punch_index_1 , 2);

				switch (punch_index_1) 
				{														
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_finisher_head_01_lp', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_finisher_head_01_rp', 'PLAYER_SLOT', settings);
					break;
				}
					
				this.previous_punch_index_1 = punch_index_1;

				AddTimer('ACS_HeadbuttDamage', 0.75, false);
			}
			else if( targetDistance > 1.5 * 1.5 
			&& targetDistance <= 4.5*4.5 ) 
			{			
				greg_special_attack_index_1 = RandDifferent(this.previous_greg_special_attack_index_1 , 10);

				switch (greg_special_attack_index_1) 
				{	
					case 9:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_l_up_1_ACS', 'PLAYER_SLOT', settings);
					break;

					case 8:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_l_left_1_ACS', 'PLAYER_SLOT', settings);
					break;

					case 7:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_h_up_1_ACS', 'PLAYER_SLOT', settings);
					break;

					case 6:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_h_left_1_ACS', 'PLAYER_SLOT', settings);
					break;

					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_l_2_ACS', 'PLAYER_SLOT', settings);
					break;

					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_l_1_ACS', 'PLAYER_SLOT', settings);
					break;

					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_h_1_ACS', 'PLAYER_SLOT', settings);
					break;

					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_h_2_ACS', 'PLAYER_SLOT', settings);
					break;

					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_attack_heavy_special_rp_end', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
					break;
				}

				this.previous_greg_special_attack_index_1 = greg_special_attack_index_1;	
			}	
			else
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_approach_attack_1', 'PLAYER_SLOT', settings);
			}			
		}	
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			greg_special_attack_index_2 = RandDifferent(this.previous_greg_special_attack_index_2, 11);

			switch (greg_special_attack_index_2) 
			{	
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_h_2_ACS', 'PLAYER_SLOT', settings);
				break;

				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_l_up_1_ACS', 'PLAYER_SLOT', settings);
				break;

				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_l_left_1_ACS', 'PLAYER_SLOT', settings);
				break;

				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_h_up_1_ACS', 'PLAYER_SLOT', settings);
				break;

				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_h_left_1_ACS', 'PLAYER_SLOT', settings);
				break;

				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_l_2_ACS', 'PLAYER_SLOT', settings);
				break;

				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_l_1_ACS', 'PLAYER_SLOT', settings);
				break;

				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_h_1_ACS', 'PLAYER_SLOT', settings);
				break;

				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_attack_heavy_special_rp_end', 'PLAYER_SLOT', settings);
				break;
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_approach_attack_1', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			
			this.previous_greg_special_attack_index_2 = greg_special_attack_index_2;
		}
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	function geraltRandomGregLightAttackAlt()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}

			greg_attack_index_1 = RandDifferent(this.previous_greg_attack_index_1 , 4);

			switch (greg_attack_index_1) 
			{				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_03_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_04_lp_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			
			this.previous_greg_attack_index_1 = greg_attack_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			greg_attack_index_2 = RandDifferent(this.previous_greg_attack_index_2, 4);

			switch (greg_attack_index_2) 
			{	
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_03_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_02_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_04_lp_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_03_rp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_greg_attack_index_2 = greg_attack_index_2;
		}
	}
	
	function geraltRandomGregLightAttack()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}

			greg_attack_index_1 = RandDifferent(this.previous_greg_attack_index_1 , 5);

			switch (greg_attack_index_1) 
			{				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_l_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_l_04_rp_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_l_06_lp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
				
			this.previous_greg_attack_index_1 = greg_attack_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			greg_attack_index_2 = RandDifferent(this.previous_greg_attack_index_2, 5);

			switch (greg_attack_index_2) 
			{				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_01_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_l_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_l_04_rp_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_l_06_lp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_greg_attack_index_2 = greg_attack_index_2;
		}
	}
	
	function geraltRandomGregHeavyAttackAlt()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}

			if( targetDistance <= 1.5 * 1.5 ) 
			{
				//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'gregoire_attack_punch_ACS', 'PLAYER_SLOT', settings);

				punch_index_1 = RandDifferent(this.previous_punch_index_1 , 2);

				switch (punch_index_1) 
				{														
					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_finisher_head_01_lp', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_finisher_head_01_rp', 'PLAYER_SLOT', settings);
					break;
				}
					
				this.previous_punch_index_1 = punch_index_1;

				AddTimer('ACS_HeadbuttDamage', 0.75, false);
			}
			else
			{
				greg_attack_index_1 = RandDifferent(this.previous_greg_attack_index_1 , 9);

				switch (greg_attack_index_1) 
				{				
					case 8:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_l_left_1_ACS', 'PLAYER_SLOT', settings);
					break;

					case 7:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_h_up_1_ACS', 'PLAYER_SLOT', settings);
					break;

					case 6:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_h_left_1_ACS', 'PLAYER_SLOT', settings);
					break;

					case 5:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_l_2_ACS', 'PLAYER_SLOT', settings);
					break;

					case 4:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_l_1_ACS', 'PLAYER_SLOT', settings);
					break;

					case 3:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_h_1_ACS', 'PLAYER_SLOT', settings);
					break;

					case 2:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_l_up_1_ACS', 'PLAYER_SLOT', settings);
					break;

					case 1:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_h_2_ACS', 'PLAYER_SLOT', settings);
					break;

					default:
					thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_attack_heavy_special_rp_end', 'PLAYER_SLOT', settings);
					break;
				}	
					
				this.previous_greg_attack_index_1 = greg_attack_index_1;
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			greg_attack_index_2 = RandDifferent(this.previous_greg_attack_index_2, 10);

			switch (greg_attack_index_2) 
			{	
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_h_2_ACS', 'PLAYER_SLOT', settings);
				break;

				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_l_left_1_ACS', 'PLAYER_SLOT', settings);
				break;

				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_h_up_1_ACS', 'PLAYER_SLOT', settings);
				break;

				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_h_left_1_ACS', 'PLAYER_SLOT', settings);
				break;

				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_l_2_ACS', 'PLAYER_SLOT', settings);
				break;

				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_l_1_ACS', 'PLAYER_SLOT', settings);
				break;

				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_h_1_ACS', 'PLAYER_SLOT', settings);
				break;

				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_2hand_attack_l_up_1_ACS', 'PLAYER_SLOT', settings);
				break;

				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'combat_locomotion_sucker_punch_40ms_close', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_attack_heavy_special_rp_end', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_greg_attack_index_2 = greg_attack_index_2;
		}
	}
	
	function geraltRandomGregHeavyAttack()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}

			greg_attack_index_1 = RandDifferent(this.previous_greg_attack_index_1 , 4);

			switch (greg_attack_index_1) 
			{				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_l_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_05_rp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
				
			this.previous_greg_attack_index_1 = greg_attack_index_1;
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			greg_attack_index_2 = RandDifferent(this.previous_greg_attack_index_2, 4);

			switch (greg_attack_index_2) 
			{				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_02_lp_ACS', 'PLAYER_SLOT', settings);
				break;
				
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_l_01_rp_ACS', 'PLAYER_SLOT', settings);
				break;

				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_h_05_rp_ACS', 'PLAYER_SLOT', settings);
				break;
			}	
			this.previous_greg_attack_index_2 = greg_attack_index_2;
		}
	}
	
	function geraltRandomGregSpecialAttackAlt()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}

			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_approach_attack_1', 'PLAYER_SLOT', settings);
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_approach_attack_1', 'PLAYER_SLOT', settings);
		}
	}
	
	function geraltRandomGregSpecialAttack()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				movementAdjustor.RotateTowards( ticket, actor );  
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					movementAdjustor.RotateTowards( ticket, actor );  
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}	
			}

			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_longsword_attack_special_01_rp_ACS', 'PLAYER_SLOT', settings);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// Bow & Crossbow Stuff

	function geraltShootBowStationary()
	{
		thePlayer.DrainStamina(ESAT_HeavyAttack);
		thePlayer.DrainStamina(ESAT_HeavyAttack);
		thePlayer.DrainStamina(ESAT_HeavyAttack);

		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				UpdateHeading(); movementAdjustor.RotateTowards( ticket, actor );   
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					UpdateHeading(); movementAdjustor.RotateTowards( ticket, actor );   
				}
				else
				{
					movementAdjustor.RotateTo( ticket, theCamera.GetCameraHeading() );
				}	
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, theCamera.GetCameraHeading() );
		}

		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_bow_idle_aiming_01_ACS', 'PLAYER_SLOT', settings);

		PlayBowAnim_IdleAiming();

		ACS_Arrow_Create_Ready();

		AddTimer('ACS_ShootBowToIdle', 0.75, false);
	}

	function geraltShootBowMoving()
	{
		thePlayer.DrainStamina(ESAT_LightAttack);

		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				UpdateHeading(); movementAdjustor.RotateTowards( ticket, actor );   
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					UpdateHeading(); movementAdjustor.RotateTowards( ticket, actor );   
				}
				else
				{
					movementAdjustor.RotateTo( ticket, theCamera.GetCameraHeading() );
				}	
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, theCamera.GetCameraHeading() );
		}
		
		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_bow_idle_aiming_01_ACS', 'PLAYER_SLOT', settings);

		PlayBowAnim_IdleAiming();

		ACS_Arrow_Create_Ready();

		AddTimer('ACS_ShootBowToIdle', 0.25, false);
	}

	function geraltShootCrossbowStationary()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				UpdateHeading(); movementAdjustor.RotateTowards( ticket, actor );   
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					UpdateHeading(); movementAdjustor.RotateTowards( ticket, actor );   
				}
				else
				{
					movementAdjustor.RotateTo( ticket, theCamera.GetCameraHeading() );
				}	
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, theCamera.GetCameraHeading() );
		}

		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_crossbow_idle_aiming_01_ACS', 'PLAYER_SLOT', settings);

		PlayCrossbowAnim_IdleAiming();

		AddTimer('ACS_ShootCrossbowToIdle', 0.25, false);
	}

	function geraltShootCrossbowMoving()
	{
		MovementAdjust();
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat())
		{
			if ( ACS_GetTargetMode() == 0 )
			{
				UpdateHeading(); movementAdjustor.RotateTowards( ticket, actor );   
			}
			else if ( ACS_GetTargetMode() == 1 )
			{
				if (thePlayer.IsHardLockEnabled())
				{
					UpdateHeading(); movementAdjustor.RotateTowards( ticket, actor );   
				}
				else
				{
					movementAdjustor.RotateTo( ticket, theCamera.GetCameraHeading() );
				}	
			}
		}
		else
		{
			movementAdjustor.RotateTo( ticket, theCamera.GetCameraHeading() );
		}

		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_crossbow_idle_aiming_01_ACS', 'PLAYER_SLOT', settings);

		PlayCrossbowAnim_IdleAiming();

		AddTimer('ACS_ShootCrossbowToAim', 0.25, false);
	}

	function PlayBowAnim_IdleAiming()
	{
		igni_bow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		axii_bow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		aard_bow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		quen_bow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		yrden_bow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );

		igni_bow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		axii_bow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		aard_bow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		quen_bow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		yrden_bow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );

		igni_bow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		axii_bow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		aard_bow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		quen_bow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		yrden_bow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );

		igni_bow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		axii_bow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		aard_bow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		quen_bow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		yrden_bow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
	}

	function PlayBowAnim_Reset()
	{
		igni_bow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_lp_01' );
		axii_bow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_lp_01' );
		aard_bow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_lp_01' );
		quen_bow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_lp_01' );
		yrden_bow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_lp_01' );

		igni_bow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_lp_01' );
		axii_bow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_lp_01' );
		aard_bow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_lp_01' );
		quen_bow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_lp_01' );
		yrden_bow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_lp_01' );

		igni_bow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_lp_01' );
		axii_bow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_lp_01' );
		aard_bow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_lp_01' );
		quen_bow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_lp_01' );
		yrden_bow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_lp_01' );

		igni_bow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_lp_01' );
		axii_bow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_lp_01' );
		aard_bow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_lp_01' );
		quen_bow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_lp_01' );
		yrden_bow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_lp_01' );
	}

	function PlayBowAnim_ShootToIdle()
	{
		//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_bow_shoot_to_idle_lp_ACS', 'PLAYER_SLOT', settings);

		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_bow_shoot_to_idle_lp_ACS', 'PLAYER_SLOT', settings);

		igni_bow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		axii_bow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		aard_bow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		quen_bow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		yrden_bow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );

		igni_bow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		axii_bow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		aard_bow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		quen_bow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		yrden_bow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );

		igni_bow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		axii_bow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		aard_bow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		quen_bow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		yrden_bow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );

		igni_bow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		axii_bow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		aard_bow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		quen_bow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		yrden_bow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );

		AddTimer('ACS_Arrow_Shoot_Delay', 0.125, false);

		AddTimer('ACS_Arrow_Create_Delay', 0.5, false);
	}

	function PlayCrossbowAnim_IdleAiming()
	{
		igni_crossbow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		axii_crossbow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		aard_crossbow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		quen_crossbow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		yrden_crossbow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );

		igni_crossbow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		axii_crossbow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		aard_crossbow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		quen_crossbow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		yrden_crossbow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );

		igni_crossbow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		axii_crossbow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		aard_crossbow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		quen_crossbow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		yrden_crossbow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );

		igni_crossbow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		axii_crossbow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		aard_crossbow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		quen_crossbow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
		yrden_crossbow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_idle_aiming_01' );
	}

	function PlayCrossbowAnim_ShootToIdle()
	{
		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_crossbow_shoot_to_idle_lp_ACS', 'PLAYER_SLOT', settings);

		igni_crossbow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		axii_crossbow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		aard_crossbow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		quen_crossbow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		yrden_crossbow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );

		igni_crossbow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		axii_crossbow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		aard_crossbow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		quen_crossbow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		yrden_crossbow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );

		igni_crossbow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		axii_crossbow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		aard_crossbow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		quen_crossbow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		yrden_crossbow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );

		igni_crossbow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		axii_crossbow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		aard_crossbow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		quen_crossbow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		yrden_crossbow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
	}

	function PlayCrossbowAnim_ShootToAim()
	{
		thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_crossbow_shoot_to_aim_ACS', 'PLAYER_SLOT', settings);

		igni_crossbow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		axii_crossbow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		aard_crossbow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		quen_crossbow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		yrden_crossbow_1().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );

		igni_crossbow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		axii_crossbow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		aard_crossbow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		quen_crossbow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		yrden_crossbow_2().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );

		igni_crossbow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		axii_crossbow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		aard_crossbow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		quen_crossbow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		yrden_crossbow_3().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );

		igni_crossbow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		axii_crossbow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		aard_crossbow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		quen_crossbow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
		yrden_crossbow_4().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'man_npc_bow_shoot_to_idle_lp' );
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	// Wraith Stuff
	
	function wraith_actual()
	{
		camera.StopAnimation('camera_shake_loop_lvl1_1');

		theGame.GetGameCamera().StopAnimation( 'camera_shake_loop_lvl1_1' );

		camera.StopAnimation('camera_shake_loop_lvl1_5');

		theGame.GetGameCamera().StopAnimation( 'camera_shake_loop_lvl1_5' );

		thePlayer.EnableCharacterCollisions( false );

		MovementAdjustWraith();
		
		movementAdjustor.ScaleAnimation( ticket, true, false, true );
		
		movementAdjustor.MatchMoveRotation( ticket );
		
		settingsWraith.blendIn = 0.15;
		settingsWraith.blendOut = 1.0f;
		
		if (theInput.GetActionValue('GI_AxisLeftY') > 0.5)
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'swim_slow_f_ACS', 'PLAYER_SLOT', settingsWraith);
			
			dest1 = theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * 20;
			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
		}

		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.5 )
		{
			//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'swim_underwater_idle_ACS', 'PLAYER_SLOT', settingsWraith);

			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'swim_underwater_idle_ACS', 'PLAYER_SLOT', settingsWraith);
			
			dest1 = theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * -10;
			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
		}	
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'swim_slow_f_ACS', 'PLAYER_SLOT', settingsWraith);
			
			dest1 = theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * 10 + theCamera.GetCameraRight() * 10;
			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
		}	
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'swim_slow_f_ACS', 'PLAYER_SLOT', settingsWraith);
			
			dest1 = theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * 10 + theCamera.GetCameraRight() * -10;
			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
		}	
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.5 && theInput.GetActionValue('GI_AxisLeftY') > 0.5)
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'swim_slow_f_ACS', 'PLAYER_SLOT', settingsWraith);
			
			dest1 = theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * 10 + theCamera.GetCameraRight() * 10;
			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
		}	
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5 && theInput.GetActionValue('GI_AxisLeftY') > 0.5)
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'swim_slow_f_ACS', 'PLAYER_SLOT', settingsWraith);
			
			dest1 = theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * 10 + theCamera.GetCameraRight() * -10;
			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
		}
		/*
		else if (theInput.GetActionValue('Jump') > 0.5)
		{
			//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'swim_underwater_idle_ACS', 'PLAYER_SLOT', settingsWraith);

			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'swim_underwater_idle_ACS', 'PLAYER_SLOT', settingsWraith);
			
			dest1 = theCamera.GetCameraPosition() + theCamera.GetCameraUp() * 10 + theCamera.GetCameraDirection() * 5.5;
			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
		}
		*/
		else if (
			theInput.GetActionValue('Jump') > 0.5
			|| theGame.IsDialogOrCutscenePlaying() 
			|| thePlayer.IsInNonGameplayCutscene() 
			|| thePlayer.IsInGameplayScene()
			)
		{			
			if (thePlayer.HasTag('in_wraith'))
			{
				thePlayer.SoundEvent("magic_yennefer_necromancy_loop_stop");
				
				RemoveTimer('ACS_wraith');
				
				//AddTimer('ACS_collision_delay', 0.3, false);

				thePlayer.EnableCollisions(true);

				thePlayer.StopEffect('special_attack_short_fx');
					
				thePlayer.RemoveTag('in_wraith');

				thePlayer.UnblockAction( EIAB_Crossbow, 			'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_CallHorse,			'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_Signs, 				'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_FastTravel, 			'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_Fists, 				'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_InteractionAction, 	'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_UsableItem,			'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_ThrowBomb,			'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_SwordAttack,			'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_LightAttacks,			'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_HeavyAttacks,			'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_SpecialAttackLight,	'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_SpecialAttackHeavy,	'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_Dodge,				'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_Roll,					'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_MeditationWaiting,	'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_OpenMeditation,		'ACS_Wraith');
				thePlayer.UnblockAction( EIAB_RadialMenu,			'ACS_Wraith');
			}
		}
		else
		{
			//thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'swim_underwater_idle_ACS', 'PLAYER_SLOT', settingsWraith);

			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'swim_underwater_idle_ACS', 'PLAYER_SLOT', settingsWraith);
			
			if (thePlayer.IsInInterior())
			{
				dest1 = theCamera.GetCameraPosition() + theCamera.GetCameraUp() *-1.25 + theCamera.GetCameraDirection() * 4;
			}
			else
			{
				dest1 = theCamera.GetCameraPosition() + theCamera.GetCameraUp() *-1 + theCamera.GetCameraDirection() * 5.5;
			}
			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
		}
				
		movementAdjustor.SlideTo( ticket, dest1 );
	}
}