struct ACS_Cooldown_Manager 
{
	var light_attack_cooldown							: float;
	var last_light_attack_time							: float;
	var heavy_attack_cooldown							: float;
	var last_heavy_attack_time							: float;
	var guard_attack_cooldown							: float;
	var last_guard_attack_time							: float;
	var guard_doubletap_attack_cooldown					: float;
	var last_guard_doubletap_attack_time				: float;
	var special_attack_cooldown							: float;
	var last_special_attack_time						: float;
	var bruxa_dash_cooldown								: float;
	var last_bruxa_dash_time							: float;
	var dodge_cooldown									: float;
	var last_dodge_time									: float;
	var special_dodge_cooldown							: float;
	var last_special_dodge_time							: float;
	var beam_attack_cooldown							: float;
	var last_beam_attack_time							: float;

	var bow_stationary_cooldown							: float;
	var last_shoot_bow_stationary_time					: float;

	var bow_moving_cooldown								: float;
	var last_shoot_bow_moving_time						: float;

	var crossbow_cooldown								: float;
	var last_shoot_crossbow_time						: float;

	var last_forest_god_shadow_spawn_time 				: float;
	var forest_god_shadow_cooldown						: float;

	var last_rage_marker_spawn_time 					: float;
	var rage_marker_cooldown							: float;

	var last_ghoul_proj_spawn_time 						: float;
	var ghoul_proj_cooldown								: float;

	var last_tentacle_proj_spawn_time 					: float;
	var tentacle_proj_cooldown							: float;

	var last_nekker_guardian_time 						: float;
	var nekker_guardian_cooldown						: float;

	var last_katakan_time 								: float;
	var katakan_cooldown								: float;

	var last_bat_projectile_time 						: float;
	var bat_projectile_cooldown							: float;

	var last_bear_flame_on_time 						: float;
	var bear_flame_on_cooldown							: float;

	var last_bear_fireball_time 						: float;
	var bear_fireball_cooldown							: float;

	var last_bear_fireline_time 						: float;
	var bear_fireline_cooldown							: float;

	var last_knightmare_shout_time 						: float;
	var knightmare_shout_cooldown						: float;
	
	var last_knightmare_igni_time 						: float;
	var knightmare_igni_cooldown						: float;

	var last_she_who_knows_ability_time					: float;
	var she_who_knows_ability_cooldown					: float;

	var last_vampire_monster_ability_time				: float;
	var vampire_monster_ability_cooldown				: float;

	var last_witch_hunter_throw_bomb_time				: float;
	var witch_hunter_bomb_cooldown						: float;


	// Change the values below to adjust the cooldowns of specific attacks or skills.
	
	default light_attack_cooldown = 0.4;
	
	default heavy_attack_cooldown = 0.4;
	
	default guard_attack_cooldown = 0.4;
	
	default guard_doubletap_attack_cooldown = 0.4;
	
	default special_attack_cooldown = 0.8;
	
	default bruxa_dash_cooldown = 0.375;	
	
	default dodge_cooldown = 0.375;
	
	default special_dodge_cooldown = 2;	
	
	default beam_attack_cooldown = 2;	

	default bow_stationary_cooldown = 1.75;

	default bow_moving_cooldown = 1;

	default crossbow_cooldown = 0.75;


	// Forest God Shadow Cooldown Default
	default forest_god_shadow_cooldown = 420;


	// Rage Cooldown Default

	default rage_marker_cooldown = 14;


	// Ghoul Projectile Cooldown Default

	default ghoul_proj_cooldown = 15;


	// Tentacle Cooldown Default

	default tentacle_proj_cooldown = 7;


	// Nekker Guardian Cooldown Default

	default nekker_guardian_cooldown = 2;

	
	// Novigrad Underground Katakan Spawn Cooldown Default

	default katakan_cooldown = 20;


	// Vampire Bat Projectile Cooldown Default

	default bat_projectile_cooldown = 10;


	// Fire Bear Abilities Cooldown Default

	default bear_flame_on_cooldown = 15;

	default bear_fireball_cooldown = 1.5;

	default bear_fireline_cooldown = 7;

	
	// Knightmare Abilities Cooldown Default

	default knightmare_shout_cooldown = 10;

	default knightmare_igni_cooldown = 7;


	// She Who Knows Abilities Cooldown Default

	default she_who_knows_ability_cooldown	= 10;

	// Vampire Monster Abilities Cooldown Default

	default vampire_monster_ability_cooldown = 10;

	// Witch Hunter Bomb Cooldown Default

	default witch_hunter_bomb_cooldown = 7;
}

function ACS_can_perform_light_attack(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_light_attack_time > property.light_attack_cooldown;
}

function ACS_refresh_light_attack_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_light_attack_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();

	ACS_EventHackAttack();
}

function ACS_can_perform_heavy_attack(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_heavy_attack_time > property.heavy_attack_cooldown;
}

function ACS_refresh_heavy_attack_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_heavy_attack_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();

	ACS_EventHackAttack();
}

function ACS_can_perform_guard_attack(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_guard_attack_time > property.guard_attack_cooldown;
}

function ACS_refresh_guard_attack_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_guard_attack_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();
}

function ACS_can_perform_guard_doubletap_attack(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_guard_doubletap_attack_time > property.guard_doubletap_attack_cooldown;
}

function ACS_refresh_guard_doubletap_attack_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_guard_doubletap_attack_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();
}

function ACS_can_perform_special_attack(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_special_attack_time > property.special_attack_cooldown;
}

function ACS_refresh_special_attack_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_special_attack_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();

	ACS_EventHackAttack();
}

function ACS_can_bruxa_dash(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_bruxa_dash_time > property.bruxa_dash_cooldown;
}

function ACS_refresh_bruxa_dash_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_bruxa_dash_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();

	ACS_EventHackDodge();
}

function ACS_can_dodge(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_dodge_time > property.dodge_cooldown;
}

function ACS_refresh_dodge_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_dodge_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();

	ACS_EventHackDodge();
}

function ACS_can_special_dodge(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_special_dodge_time > property.special_dodge_cooldown;
}

function ACS_refresh_special_dodge_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_special_dodge_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();

	ACS_EventHackDodge();
}

function ACS_can_perform_beam_attack(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_beam_attack_time > property.beam_attack_cooldown;
}

function ACS_refresh_beam_attack_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_beam_attack_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();

	ACS_EventHackAttack();
}

function ACS_can_shoot_bow_stationary(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_shoot_bow_stationary_time > property.bow_stationary_cooldown;
}

function ACS_refresh_bow_stationary_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_shoot_bow_stationary_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();

	ACS_EventHackAttack();
}

function ACS_can_shoot_bow_moving(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_shoot_bow_moving_time > property.bow_moving_cooldown;
}

function ACS_refresh_bow_moving_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_shoot_bow_moving_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();

	ACS_EventHackAttack();
}

function ACS_can_shoot_crossbow(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_shoot_crossbow_time > property.crossbow_cooldown;
}

function ACS_refresh_crossbow_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_shoot_crossbow_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();

	ACS_EventHackAttack();
}

function ACS_Size_Revert_And_Enable_Interrupt()
{
	if (thePlayer.HasTag('ACS_Size_Adjusted'))
	{
		GetACSWatcher().Grow_Geralt_Immediate_Fast();

		thePlayer.RemoveTag('ACS_Size_Adjusted');
	}

	if (thePlayer.HasTag('ACS_Special_Dodge'))
	{
		thePlayer.RemoveTag('ACS_Special_Dodge');
	}
}

function ACS_can_spawn_forest_god_shadows(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_forest_god_shadow_spawn_time > property.forest_god_shadow_cooldown;
}

function ACS_refresh_forest_god_shadows_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_forest_god_shadow_spawn_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_spawn_rage_marker(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_rage_marker_spawn_time > property.rage_marker_cooldown;
}

function ACS_refresh_rage_marker_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_rage_marker_spawn_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_ghoul_proj(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_ghoul_proj_spawn_time > property.ghoul_proj_cooldown;
}

function ACS_refresh_ghoul_proj_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_ghoul_proj_spawn_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_tentacle_proj(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_tentacle_proj_spawn_time > property.tentacle_proj_cooldown;
}

function ACS_refresh_tentacle_proj_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_tentacle_proj_spawn_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_summon_nekker_guardian(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_nekker_guardian_time > property.nekker_guardian_cooldown;
}

function ACS_refresh_nekker_guardian_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_nekker_guardian_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_summon_katakan(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_katakan_time > property.katakan_cooldown;
}

function ACS_refresh_katakan_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_katakan_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_shoot_bat_projectile(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_bat_projectile_time > property.bat_projectile_cooldown;
}

function ACS_refresh_bat_projectile_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_bat_projectile_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_bear_can_flame_on(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_bear_flame_on_time > property.bear_flame_on_cooldown;
}

function ACS_refresh_bear_flame_on_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_bear_flame_on_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_bear_can_throw_fireball(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_bear_fireball_time > property.bear_fireball_cooldown;
}

function ACS_refresh_bear_fireball_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_bear_fireball_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_bear_can_throw_fireline(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_bear_fireline_time > property.bear_fireline_cooldown;
}

function ACS_refresh_bear_fireline_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_bear_fireline_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_knightmare_shout(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_knightmare_shout_time > property.knightmare_shout_cooldown;
}

function ACS_refresh_knightmare_shout_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_knightmare_shout_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_knightmare_igni(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_knightmare_igni_time > property.knightmare_igni_cooldown;
}

function ACS_refresh_knightmare_igni_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_knightmare_igni_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_she_who_knows_abilities(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_she_who_knows_ability_time > property.she_who_knows_ability_cooldown;
}

function ACS_refresh_she_who_knows_abilities_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_she_who_knows_ability_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_vampire_monster_abilities(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_vampire_monster_ability_time > property.vampire_monster_ability_cooldown;
}

function ACS_refresh_vampire_monster_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_vampire_monster_ability_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_witch_hunter_proj(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_witch_hunter_throw_bomb_time > property.witch_hunter_bomb_cooldown;
}

function ACS_refresh_witch_hunter_proj_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_witch_hunter_throw_bomb_time = theGame.GetEngineTimeAsSeconds();
}