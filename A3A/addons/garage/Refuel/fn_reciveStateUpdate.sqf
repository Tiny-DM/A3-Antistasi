/*
Author: Håkon
Description:
    Sets the new state data on users and server

Arguments:
0. <UID> Vehicle UID
1. <Int> The index of the state data being updated
2. <Struct> The state data to update to (see getState for more deatails on struct)

Return Value: <nil>

Scope: Any
Environment: Scheduled
Public: No
Dependencies:

Example:

License: APL-ND
*/
params ["_vUID","_stateIndex", "_state", ["_player",""]];

private "_vehData";
{ _vehData = _x get _vUID; if (!isNil "_vehdata") exitWith {}; } forEach (["HR_GRG_Vehicles",_player] call A3A_fnc_copf);

//#4 == state preservation data
(_vehData#4) set [_stateIndex, _state];
