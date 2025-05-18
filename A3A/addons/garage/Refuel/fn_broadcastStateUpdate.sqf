/*
Author: Håkon
Description:
    Broadcast vehicle state update to garage users

Arguments:
0. <UID> The vehicles UID
1. <Struct> Fuel, Repair or Ammo state struct (see getState for more info)
2. <Int> The index of state preservation to update, in above order (optional: default - 0)

Return Value: <nil>

Scope: Server
Environment: unscheduled
Public: No
Dependencies:

Example:

License: APL-ND
*/
params ["_data","_player"];
_data params ["_vUID", "_state", ["_stateIndex",0,[0]]];
if (isNil "_vUID" || isNil "_state") exitWith {false};
private _reqUsers = (["HR_GRG_Users",_player] call A3A_fnc_copf);

if (_reqUsers isNotEqualTo []) then {
    private _recipiants = +_reqUsers;
    _recipiants pushBackUnique 2;
    [_vUID, _stateIndex, _state, _player] remoteExecCall ["HR_GRG_fnc_reciveStateUpdate", _recipiants];
    private _reqSources = (["HR_GRG_Sources",_player,false] call A3A_fnc_copf);
    {_x publicVariableClient _reqSources} forEach _recipiants;
};
