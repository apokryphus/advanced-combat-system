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

	ACS_Size_Revert_And_Enable_Interrupt_();

	ACS_EventHack();
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

	ACS_Size_Revert_And_Enable_Interrupt_();

	ACS_EventHack();
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

	ACS_Size_Revert_And_Enable_Interrupt_();
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

	ACS_Size_Revert_And_Enable_Interrupt_();
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

	ACS_Size_Revert_And_Enable_Interrupt_();

	ACS_EventHack();
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

	ACS_Size_Revert_And_Enable_Interrupt_();

	ACS_EventHack();
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

	ACS_Size_Revert_And_Enable_Interrupt_();

	ACS_EventHack();
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

	ACS_Size_Revert_And_Enable_Interrupt_();

	ACS_EventHack();
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

	ACS_Size_Revert_And_Enable_Interrupt_();

	ACS_EventHack();
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

	ACS_Size_Revert_And_Enable_Interrupt_();

	ACS_EventHack();
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

	ACS_Size_Revert_And_Enable_Interrupt_();

	ACS_EventHack();
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

	ACS_Size_Revert_And_Enable_Interrupt_();

	ACS_EventHack();
}

function ACS_Size_Revert_And_Enable_Interrupt_()
{
	if (thePlayer.HasTag('ACS_Size_Adjusted'))
	{
		GetACSWatcher().Grow_Geralt_Immediate();

		thePlayer.RemoveTag('ACS_Size_Adjusted');
	}

	if (thePlayer.HasTag('ACS_Special_Dodge'))
	{
		thePlayer.RemoveTag('ACS_Special_Dodge');
	}
}