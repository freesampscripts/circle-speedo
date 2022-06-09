#include <a_samp>
#include <cprogress>
#include <zcmd>

new use_speedo[MAX_PLAYERS];
new speedo_timer;
new Text:speedoball;
new PlayerText:speedo[MAX_PLAYERS] = { PlayerText:0xFFFF,... };

new Float:VEHICLE_TOP_SPEEDS[] =
{
	157.0, 147.0, 186.0, 110.0, 133.0, 164.0, 110.0, 148.0, 100.0, 158.0, 129.0, 221.0, 168.0, 110.0, 105.0, 192.0, 154.0, 270.0, 115.0, 149.0,
	145.0, 154.0, 140.0, 99.0,  135.0, 270.0, 173.0, 165.0, 157.0, 201.0, 190.0, 130.0, 94.0,  110.0, 167.0, 0.0,   149.0, 158.0, 142.0, 168.0,
	136.0, 145.0, 139.0, 126.0, 110.0, 164.0, 270.0, 270.0, 111.0, 0.0,   0.0,   193.0, 270.0, 60.0,  135.0, 157.0, 106.0, 95.0,  157.0, 136.0,
	270.0, 160.0, 111.0, 142.0, 145.0, 145.0, 147.0, 140.0, 144.0, 270.0, 157.0, 110.0, 190.0, 190.0, 149.0, 173.0, 270.0, 186.0, 117.0, 140.0,
	184.0, 73.0,  156.0, 122.0, 190.0, 99.0,  64.0,  270.0, 270.0, 139.0, 157.0, 149.0, 140.0, 270.0, 214.0, 176.0, 162.0, 270.0, 108.0, 123.0,
	140.0, 145.0, 216.0, 216.0, 173.0, 140.0, 179.0, 166.0, 108.0, 79.0,  101.0, 270.0,	270.0, 270.0, 120.0, 142.0, 157.0, 157.0, 164.0, 270.0,
	270.0, 160.0, 176.0, 151.0, 130.0, 160.0, 158.0, 149.0, 176.0, 149.0, 60.0,  70.0,  110.0, 167.0, 168.0, 158.0, 173.0, 0.0,   0.0,   270.0,
	149.0, 203.0, 164.0, 151.0, 150.0, 147.0, 149.0, 142.0, 270.0, 153.0, 145.0, 157.0, 121.0, 270.0, 144.0, 158.0, 113.0, 113.0, 156.0, 178.0,
	169.0, 154.0, 178.0, 270.0, 145.0, 165.0, 160.0, 173.0, 146.0, 0.0,   0.0,   93.0,  60.0,  110.0, 60.0,  158.0, 158.0, 270.0, 130.0, 158.0,
	153.0, 151.0, 136.0, 85.0,  0.0,   153.0, 142.0, 165.0, 108.0, 162.0, 0.0,   0.0,   270.0, 270.0, 130.0, 190.0, 175.0, 175.0, 175.0, 158.0,
	151.0, 110.0, 169.0, 171.0, 148.0, 152.0, 0.0,   0.0,   0.0,   108.0, 0.0,   0.0
};

public OnFilterScriptInit()
{
	speedoball = TextDrawCreate(572.000244, 358.259460, "LD_POOL:ball");
	TextDrawTextSize(speedoball, 48.000000, 54.000000);
	TextDrawAlignment(speedoball, 1);
	TextDrawColor(speedoball, 255);
	TextDrawSetShadow(speedoball, 0);
	TextDrawBackgroundColor(speedoball, 255);
	TextDrawFont(speedoball, 4);
	TextDrawSetProportional(speedoball, 0);
	speedo_timer = SetTimer("speedoupdate", 250, 1);
	for (new playerid = GetPlayerPoolSize(); playerid > -1; playerid--)
	{
		if (!IsPlayerConnected(playerid) || IsPlayerNPC(playerid)) continue;
		speedo[playerid] = CreatePlayerTextDraw(playerid, 596.133483, 379.266845, "0");
		PlayerTextDrawLetterSize(playerid, speedo[playerid], 0.319333, 1.147851);
		PlayerTextDrawAlignment(playerid, speedo[playerid], 2);
		PlayerTextDrawColor(playerid, speedo[playerid], -1);
		PlayerTextDrawSetShadow(playerid, speedo[playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, speedo[playerid], 255);
		PlayerTextDrawFont(playerid, speedo[playerid], 1);
		PlayerTextDrawSetProportional(playerid, speedo[playerid], 1);
	}
	return 1;
}

public OnFilterScriptExit()
{
	TextDrawDestroy(speedoball);
	KillTimer(speedo_timer);
	for (new playerid = GetPlayerPoolSize(); playerid > -1; playerid--)
	{
		if (!IsPlayerConnected(playerid) || IsPlayerNPC(playerid)) continue;
		PlayerTextDrawDestroy(playerid, speedo[playerid]);
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	if (!IsPlayerNPC(playerid))
	{
		speedo[playerid] = CreatePlayerTextDraw(playerid, 596.133483, 379.266845, "0");
		PlayerTextDrawLetterSize(playerid, speedo[playerid], 0.319333, 1.147851);
		PlayerTextDrawAlignment(playerid, speedo[playerid], 2);
		PlayerTextDrawColor(playerid, speedo[playerid], -1);
		PlayerTextDrawSetShadow(playerid, speedo[playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, speedo[playerid], 255);
		PlayerTextDrawFont(playerid, speedo[playerid], 1);
		PlayerTextDrawSetProportional(playerid, speedo[playerid], 1);
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	PlayerTextDrawDestroy(playerid, speedo[playerid]);
	speedo[playerid] = PlayerText:0xFFFF;
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(use_speedo[playerid])
	{
		if(newstate != 2 && oldstate == 2)
		{
	        TextDrawHideForPlayer(playerid, speedoball);
			PlayerTextDrawHide(playerid, speedo[playerid]);
			DestroyPlayerCircleProgress(playerid);
		}
		if(newstate == 2 && oldstate != 2)
		{
		    TextDrawShowForPlayer(playerid, speedoball);
			PlayerTextDrawShow(playerid, speedo[playerid]);
		}
	}
	return 1;
}

CMD:speedo(playerid, params[])
{
	if (!use_speedo[playerid])
	{
		SendClientMessage(playerid, -1, "Speedometer: {00FA00}ON");
		use_speedo[playerid] = 1;
		if (GetPlayerState(playerid) != 2) return 1;
		TextDrawShowForPlayer(playerid, speedoball);
		PlayerTextDrawShow(playerid, speedo[playerid]);
		return 1;
	}
	SendClientMessage(playerid, -1, "Speedometer: {FA0000}OFF");
	use_speedo[playerid] = 0;
	TextDrawHideForPlayer(playerid, speedoball);
	PlayerTextDrawHide(playerid, speedo[playerid]);
	DestroyPlayerCircleProgress(playerid);
	return 1;
}

forward speedoupdate();

public speedoupdate()
{
	new string[4], veh, Float:speed, Float:x, Float:y, Float:z, model;
	for (new playerid = GetPlayerPoolSize(); playerid > -1; playerid--)
	{
		if (!use_speedo[playerid] || GetPlayerState(playerid) != 2) continue;
		veh = GetPlayerVehicleID(playerid);
		model = GetVehicleModel(veh);
		GetVehicleVelocity(veh, x, y, z);
		speed = floatmul(floatsqroot(floatadd(floatmul(x, x), floatmul(y, y))), 180.0);
		format(string, 4, "%.0f", speed);
		PlayerTextDrawSetString(playerid, speedo[playerid], string);
		ShowPlayerCircleProgress(playerid, floatround(speed / VEHICLE_TOP_SPEEDS[model - 400] * 100.0), 596.500244, 374.259460, 0x0388FCFF);
	}
	return 1;
}
