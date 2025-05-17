/*
Check OPFOR
Input anything and an opfor alternative will be provided if OPFOR and remain untouched if rebel


*/

params ["_input",["_sideCheck",""],["_doCompile",true]];

diag_log _sideCheck;

private _sideWanted = [_sideCheck] call A3A_fnc_isopf;

if (_sideWanted isEqualTo Invaders) then {
    _input = [_input] call A3A_fnc_opf;
};

if !(_doCompile) exitWith {_input}; 
call compile _input; // convert string to var