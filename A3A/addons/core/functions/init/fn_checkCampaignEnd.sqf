/*
Author: [Tiny]
    Checks current server variables to see if a win or loss is in order, and executes immediately.
    If future changes are made to the win/loss routine, they should be done here.
    This check is run in four places: 
        invaderPunish (to check for loss when a town is destroyed)
        markerChange (to check for win on airbase capture)
        SUP_orbitalStrikeRoutine (in the edge case a town gets destroyed by the funny laser)
        resourceCheck (if either previous check messes up, or in the edge case that 50% support is achieved after all airbases)

Arguments: 
    _checkReason <STR>: Reason for the campaign end check. One of ["tick","punish","orbital","flip","start"]
    _detail <STR>: Special event details. For "flip" it's an array of [marker,loser]

Enviromemnt: Scheduled

Return Value: None

Scope: Server

Example:
    [] spawn A3A_fnc_checkCampaignEnd;
*/
#include "..\..\script_component.hpp"
FIX_LINE_NUMBERS()

params [["_checkReason", "start"], ["_detail",""]];

private _popReb = 0;
private _popGov = 0;
private _popKilled = 0;
private _popTotal = 0;

{
    private _city = _x;
    private _cityData = server getVariable _city;
    _cityData params ["_numCiv", "_numVeh", "_supportGov", "_supportReb"];	
    _popTotal = _popTotal + _numCiv;
    if (_city in destroyedSites) then { _popKilled = _popKilled + _numCiv} else 
    {
        _popReb = _popReb + (_numCiv * (_supportReb / 100));
        _popGov = _popGov + (_numCiv * (_supportGov / 100)); // support only matters if the city isn't destroyed
    };
} forEach citiesX;

_popReport = format["Total Pop: %1, Dead Pop: %2, Rebel Support: %3, Gov Support: %4", _popTotal, _popKilled, _popReb, _popGov];
Info(_popReport);

sleep 5; //This lets players have a few seconds after an event before the win/loss screen shows

if (_popKilled > (_popTotal / 3)) exitWith {
    isNil { ["ended", true] call A3A_fnc_writebackSaveVar };
    ["destroyedSites",false,true] remoteExec ["BIS_fnc_endMission"];
    false;
};
if ((_popReb > _popGov) and ({sidesX getVariable [_x,sideUnknown] == teamPlayer} count airportsX == count airportsX)) exitWith {
    isNil { ["ended", true] call A3A_fnc_writebackSaveVar };
    if (_checkReason == "flip") then {
        _detail spawn A3A_fnc_finalStand;
        true;
    } else {
        ["end1",true,true,true,true] remoteExec ["BIS_fnc_endMission",0];
    };
    true;
};