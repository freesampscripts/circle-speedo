/*
native ShowPlayerCircleProgress(playerid, value, Float:pos_x, Float:pos_y, color = 0xFF0000FF, background_color = 0x000000FF, Float:size = 25.0, Float:thickness = 0.5);
native DestroyPlayerCircleProgress(playerid);
*/

enum ___ctd
{
	PlayerText:ctd_[120],
	ctd_value
}
static __ctd[MAX_PLAYERS][___ctd];

static stock ctd(Float:angle, Float:distance, Float:sx, Float:sy, & Float:x, & Float:y)
{
	x = sx + (distance * floatsin(-angle, degrees));
	y = sy + (distance * floatcos(angle, degrees));
	return 1;
}

public OnFilterScriptInit()
{
	for (new i = GetMaxPlayers(); i > -1; i--)
	{
		for (new x = 0; x < 120; x++)
		{
			__ctd[i][ctd_][x] = PlayerText:0xFFFF;
		}
	}
    #if defined ctd_OnFilterScriptInit
    	ctd_OnFilterScriptInit();
	#endif
	return 1;
}

#if defined _ALS_OnFilterScriptInit
#undef OnFilterScriptInit
#else
#define _ALS_OnFilterScriptInit
#endif
#define OnFilterScriptInit ctd_OnFilterScriptInit
#if defined ctd_OnFilterScriptInit
forward ctd_OnFilterScriptInit();
#endif

public OnFilterScriptExit()
{
	for (new i = GetPlayerPoolSize(); i > -1; i--)
	{
	    if(__ctd[i][ctd_][0] == PlayerText:0xFFFF) continue;
		for (new x = 0; x < 120; x++)
		{
			DestroyPlayerCircleProgress(i);
		}
	}
    #if defined ctd_OnFilterScriptExit
		ctd_OnFilterScriptExit();
	#endif
	return 1;
}

#if defined _ALS_OnFilterScriptExit
#undef OnFilterScriptExit
#else
#define _ALS_OnFilterScriptExit
#endif
#define OnFilterScriptExit ctd_OnFilterScriptExit
#if defined ctd_OnFilterScriptExit
forward ctd_OnFilterScriptExit();
#endif

public OnPlayerDisconnect(playerid, reason)
{
	DestroyPlayerCircleProgress(playerid);

	#if defined ctd_OnPlayerDisconnect
    	ctd_OnPlayerDisconnect(playerid, reason);
	#endif
    return 1;
}

#if defined _ALS_OnPlayerDisconnect
#undef OnPlayerDisconnect
#else
#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect ctd_OnPlayerDisconnect
#if defined ctd_OnPlayerDisconnect
forward ctd_OnPlayerDisconnect(playerid, reason);
#endif

stock DestroyPlayerCircleProgress(playerid)
{
	if (IsPlayerNPC(playerid)) return 0;
	if (__ctd[playerid][ctd_][0] == PlayerText:0xFFFF) return 0;
	__ctd[playerid][ctd_value] = 0;
	for (new x = 0; x < 120; x++)
	{
		PlayerTextDrawDestroy(playerid, __ctd[playerid][ctd_][x]);
		__ctd[playerid][ctd_][x] = PlayerText:0xFFFF;
	}
	return 1;
}

stock ShowPlayerCircleProgress(playerid, value, Float:pos_x, Float:pos_y, color = 0xFF0000FF, background_color = 0x000000FF, Float:size = 25.0, Float:thickness = 0.5)
{
	new count, Float:x, Float:y, percent;
	if (IsPlayerNPC(playerid)) return 0;
	value = value < 0 ? 0 : value;
	value = value > 100 ? 100 : value;
	percent = (120 * value) / 100;
	if(__ctd[playerid][ctd_][0] != PlayerText:0xFFFF)
	{
	    for(new i = 0; i < 120; i ++)
		{
			PlayerTextDrawDestroy(playerid, __ctd[playerid][ctd_][i]);
		}
	}
	for (new Float:i = 0.0; i < 360.0; i += 3.0)
	{
		ctd(i + 180.0, size, pos_x, pos_y, x, y);
		__ctd[playerid][ctd_][count] = CreatePlayerTextDraw(playerid, x, y, ".");
		PlayerTextDrawAlignment(playerid, __ctd[playerid][ctd_][count], 2);
		PlayerTextDrawLetterSize(playerid, __ctd[playerid][ctd_][count], thickness, thickness * 3.0);
		PlayerTextDrawSetShadow(playerid, __ctd[playerid][ctd_][count], 0);
		PlayerTextDrawColor(playerid, __ctd[playerid][ctd_][count], percent <= count ? (background_color) : (color));
		PlayerTextDrawShow(playerid, __ctd[playerid][ctd_][count]);
		count ++;
	}
	return 1;
}
