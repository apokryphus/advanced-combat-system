// Tutorials

function ACSTutorialsGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('ACSmodTutorials', nam);

	return value;
}

function ACSRageTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSTutorialsGetConfigValue('ACSmodRageTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSDynamicEnemyBehaviorSystemTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSTutorialsGetConfigValue('ACSmodDynamicEnemyBehaviorSystemTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSGuardsTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSTutorialsGetConfigValue('ACSmodGuardsTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSTransformationWerewolfTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSTutorialsGetConfigValue('ACSmodTransformationWerewolfTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSGlideTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSTutorialsGetConfigValue('ACSmodGlideTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSBruxaDashTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSTutorialsGetConfigValue('ACSmodBruxaDashTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWraithModeTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSTutorialsGetConfigValue('ACSmodWraithModeTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSLightsTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSTutorialsGetConfigValue('ACSmodLightsTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSQuickMeditationTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSTutorialsGetConfigValue('ACSmodQuickMeditationTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSPerfectDodgesCountersTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSTutorialsGetConfigValue('ACSmodPerfectDodgesCountersTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSArmorSystemTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSTutorialsGetConfigValue('ACSmodArmorSystemTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSElementalComboSystemTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSTutorialsGetConfigValue('ACSmodElementalComboSystemTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSQuestTrackingSwapTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSTutorialsGetConfigValue('ACSmodQuestTrackingSwapTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSCloakWeaponHideTutorialEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSTutorialsGetConfigValue('ACSmodCloakWeaponHideTutorialEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}










function ACS_Rage_Tutorial() 
{
	if (FactsQuerySum("ACS_Rage_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Rage_Tutorial_Menu();

	FactsAdd("ACS_Rage_Tutorial_Shown", 1, -1);
}

function ACS_Rage_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035359);

	Message = GetLocStringById(2117035360);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Dynamic_Enemy_Behavior_System_Tutorial() 
{
	if (FactsQuerySum("ACS_Dynamic_Enemy_Behavior_System_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Dynamic_Enemy_Behavior_System_Tutorial_Menu();

	FactsAdd("ACS_Dynamic_Enemy_Behavior_System_Tutorial_Shown", 1, -1);
}

function ACS_Dynamic_Enemy_Behavior_System_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035361);

	Message = GetLocStringById(2117035362);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Guards_Tutorial() 
{
	if (FactsQuerySum("ACS_Guards_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Guards_Tutorial_Menu();

	FactsAdd("ACS_Guards_Tutorial_Shown", 1, -1);
}

function ACS_Guards_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035363);

	Message = GetLocStringById(2117035364);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_TransformationWerewolf_Tutorial() 
{
	if (FactsQuerySum("ACS_Werewolf_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_TransformationWerewolf_Tutorial_Menu();

	FactsAdd("ACS_Werewolf_Tutorial_Shown", 1, -1);
}

function ACS_TransformationWerewolf_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035365);

	Message = GetLocStringById(2117035366);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Glide_Tutorial() 
{
	if (FactsQuerySum("ACS_Glide_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Glide_Tutorial_Menu();

	FactsAdd("ACS_Glide_Tutorial_Shown", 1, -1);
}

function ACS_Glide_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035367);

	Message = GetLocStringById(2117035368);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Bruxa_Dash_Tutorial() 
{
	if (FactsQuerySum("ACS_Bruxa_Dash_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Bruxa_Dash_Tutorial_Menu();

	FactsAdd("ACS_Bruxa_Dash_Tutorial_Shown", 1, -1);
}

function ACS_Bruxa_Dash_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035369);

	Message = GetLocStringById(2117035370);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Wraith_Mode_Tutorial() 
{
	if (FactsQuerySum("ACS_Wraith_Mode_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Wraith_Mode_Tutorial_Menu();

	FactsAdd("ACS_Wraith_Mode_Tutorial_Shown", 1, -1);
}

function ACS_Wraith_Mode_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035371);

	Message = GetLocStringById(2117035372);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_Lights_Tutorial() 
{
	if (FactsQuerySum("ACS_Lights_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_Lights_Tutorial_Menu();

	FactsAdd("ACS_Lights_Tutorial_Shown", 1, -1);
}

function ACS_Lights_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035447);

	Message = GetLocStringById(2117035448);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_QuickMeditation_Tutorial() 
{
	if (FactsQuerySum("ACS_QuickMeditation_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_QuickMeditation_Tutorial_Menu();

	FactsAdd("ACS_QuickMeditation_Tutorial_Shown", 1, -1);
}

function ACS_QuickMeditation_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035449);

	Message = GetLocStringById(2117035450);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_PerfectDodgesCounters_Tutorial() 
{
	if (FactsQuerySum("ACS_PerfectDodgesCounters_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_PerfectDodgesCounters_Tutorial_Menu();

	FactsAdd("ACS_PerfectDodgesCounters_Tutorial_Shown", 1, -1);
}

function ACS_PerfectDodgesCounters_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035451);

	Message = GetLocStringById(2117035452);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_ArmorSystem_Tutorial() 
{
	if (FactsQuerySum("ACS_ArmorSystem_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_ArmorSystem_Tutorial_Menu();

	FactsAdd("ACS_ArmorSystem_Tutorial_Shown", 1, -1);
}

function ACS_ArmorSystem_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035453);

	Message = GetLocStringById(2117035454);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_ElementalComboSystem_Tutorial() 
{
	if (FactsQuerySum("ACS_ElementalComboSystem_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_ElementalComboSystem_Tutorial_Menu();

	FactsAdd("ACS_ElementalComboSystem_Tutorial_Shown", 1, -1);
}

function ACS_ElementalComboSystem_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035474);

	Message = GetLocStringById(2117035475);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_QuestTrackingSwap_Tutorial() 
{
	if (FactsQuerySum("ACS_QuestTrackingSwap_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_QuestTrackingSwap_Tutorial_Menu();

	FactsAdd("ACS_QuestTrackingSwap_Tutorial_Shown", 1, -1);
}

function ACS_QuestTrackingSwap_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035476);

	Message = GetLocStringById(2117035477);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_CloakWeaponHide_Tutorial() 
{
	if (FactsQuerySum("ACS_CloakWeaponHide_Tutorial_Shown") > 0)
	{
		return;
	}

	ACS_CloakWeaponHide_Tutorial_Menu();

	FactsAdd("ACS_CloakWeaponHide_Tutorial_Shown", 1, -1);
}

function ACS_CloakWeaponHide_Tutorial_Menu() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035478);

	Message = GetLocStringById(2117035479);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}