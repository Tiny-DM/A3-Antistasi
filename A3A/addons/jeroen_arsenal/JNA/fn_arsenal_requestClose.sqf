/*
	Author: Jeroen Notenbomer

	Description:
	Removes to client from the servers list so it doesnt get called when the arsenal gets updated. This command needs to be excuted on the server!

	Parameter(s):
	ID clientOwner

	Returns:
	NOTHING, well it sends a command which contains the JNA_datalist
*/

if(!isServer)exitWith{};
params ["_clientOwner","_player"];

private _reqPlayers = ["jna_playersInArsenal",_player,false] call A3A_fnc_copf;
_temp = server getVariable [_reqPlayers,[]];
_temp = _temp - [_clientOwner];
server setVariable [_reqPlayers,_temp,true];