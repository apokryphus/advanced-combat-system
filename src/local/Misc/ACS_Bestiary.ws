// Bestiary

function ACSBestiaryGetConfigValue(nam : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue('ACSmodBestiary', nam);

	return value;
}

function ACSAlexanderBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBestiaryGetConfigValue('ACSmodAlexanderBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSBerstukBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBestiaryGetConfigValue('ACSmodBerstukBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSBladeOfTheUnseenBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBestiaryGetConfigValue('ACSmodBladeOfTheUnseenBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSBruxaeBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBestiaryGetConfigValue('ACSmodBruxaeBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}


function ACSDrownersBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBestiaryGetConfigValue('ACSmodDrownersBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSFireWyrmBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBestiaryGetConfigValue('ACSmodFireWyrmBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}


function ACSForestGodShadowsBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBestiaryGetConfigValue('ACSmodForestGodShadowsBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSGhoulsBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBestiaryGetConfigValue('ACSmodGhoulsBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSIceTitanBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBestiaryGetConfigValue('ACSmodIceTitanBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSKhagmarBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBestiaryGetConfigValue('ACSmodKhagmarBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSKnightmareBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBestiaryGetConfigValue('ACSmodKnightmareBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSLoviatarBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBestiaryGetConfigValue('ACSmodLoviatarBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSNekkerGuardianBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBestiaryGetConfigValue('ACSmodNekkerGuardianBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSNightHunterBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBestiaryGetConfigValue('ACSmodNightHunterBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSNovigradVampiresBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBestiaryGetConfigValue('ACSmodNovigradVampiresBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSRogueMagesBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBestiaryGetConfigValue('ACSmodRogueMagesBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSVolosBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBestiaryGetConfigValue('ACSmodVolosBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWerewolvesBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBestiaryGetConfigValue('ACSmodWerewolvesBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWildHuntHoundsBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBestiaryGetConfigValue('ACSmodWildHuntHoundsBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSWildHuntWarriorsBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBestiaryGetConfigValue('ACSmodWildHuntWarriorsBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSXenoSwarmSoldierBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBestiaryGetConfigValue('ACSmodXenoSwarmSoldierBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSXenoSwarmTyrantBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBestiaryGetConfigValue('ACSmodXenoSwarmTyrantBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}

function ACSXenoSwarmWorkerBestiaryEnabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSBestiaryGetConfigValue('ACSmodXenoSwarmWorkerBestiaryEnabled');
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return false;
	}
	else return (bool)configValueString;
}








function ACS_Alexander_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035342);

	Message = GetLocStringById(2117035416);

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

function ACS_Berstuk_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035316);

	Message = GetLocStringById(2117035424);

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

function ACS_BladeOfTheUnseenn_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035319);

	Message = GetLocStringById(2117035425);

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

function ACS_Bruxae_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035417);

	Message = GetLocStringById(2117035426);

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

function ACS_Drowners_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035418);

	Message = GetLocStringById(2117035427);

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

function ACS_FireWyrm_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035337);

	Message = GetLocStringById(2117035428);

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

function ACS_ForestGodShadows_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035317);

	Message = GetLocStringById(2117035429);

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

function ACS_Ghouls_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035419);

	Message = GetLocStringById(2117035430);

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

function ACS_IceTitan_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035420);

	Message = GetLocStringById(2117035431);

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

function ACS_Khagmar_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035335);

	Message = GetLocStringById(2117035432);

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

function ACS_Knightmare_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035324);

	Message = GetLocStringById(2117035433);

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

function ACS_Loviatar_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035334);

	Message = GetLocStringById(2117035434);

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

function ACS_NekkerGuardian_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035318);

	Message = GetLocStringById(2117035435);

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

function ACS_NightHunter_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035353);

	Message = GetLocStringById(2117035436);

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

function ACS_NovigradVampires_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035421);

	Message = GetLocStringById(2117035437);

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

function ACS_RogueMages_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035343);

	Message = GetLocStringById(2117035438);

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

function ACS_Volos_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035320);

	Message = GetLocStringById(2117035439);

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

function ACS_Werewolves_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035445);

	Message = GetLocStringById(2117035446);

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

function ACS_WildHuntHounds_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035422);

	Message = GetLocStringById(2117035440);

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

function ACS_WildHuntWarriors_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035423);

	Message = GetLocStringById(2117035441);

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

function ACS_XenoSwarmSoldiers_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035357);

	Message = GetLocStringById(2117035442);

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

function ACS_XenoSwarmTyrant_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035356);

	Message = GetLocStringById(2117035443);

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

function ACS_XenoSwarmWorkers_Bestiary() 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	Title = GetLocStringById(2117035358);

	Message = GetLocStringById(2117035444);

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