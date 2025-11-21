#include "\a3\ui_f\hpp\definedikcodes.inc"

player addEventHandler ["FiredMan", {
    _this spawn {
        params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];
        private _simType = tolower getText(configFile >> "CfgAmmo" >> _ammo >> "simulation");
        if !(_simType in ["shotrocket", "shotmissile"]) exitWith {};
        private _protectedVehicles = missionNamespace getVariable ["TNY_protectedVehicles", []];
        if (_protectedVehicles isEqualTo []) exitWith {};
        private _unitAngles = [];
        {
            _unitAngles pushBack (_x getDir _unit);
        } forEach _protectedVehicles;

        while {alive _projectile} do {
            sleep 1;
            
            {
                if (_projectile distance _x < 2000) then { continue };
                _projAngle = _x getDir _projectile;
                private _diff = abs(_projAngle - (_unitAngles#_forEachIndex));
                if (_diff < 10) then {
                    // vehicle is threatened!!!
                    private _threats = _x getVariable ["TNY_activeThreats", []];
                    if ([_unit, _projectile, _ammo] in _threats) then { continue };
                    _threats pushBackUnique [_unit, _projectile, _ammo];
                    _x setVariable ["TNY_activeThreats", _threats, true];
                };
            } forEach _protectedVehicles;
        };
    };
}];

player addEventHandler ["GetInMan", {
    params ["_unit", "_role", "_veh", "_turret"];
    if !(_veh in (missionNamespace getVariable ["TNY_protectedVehicles", []])) exitWith {};
    0 spawn A3A_fnc_laserWarningVisual;
    0 spawn A3A_fnc_incomingVisual;

}];
player addEventHandler ["GetOutMan", {
    params ["_unit", "_role", "_veh", "_turret", "_isEject"];
    terminate (localNamespace getVariable ["TNY_laserWarningVisualScript", scriptNull]);
    terminate (localNamespace getVariable ["TNY_incomingVisualScript", scriptNull]);
}];


findDisplay 46 displayAddEventHandler ["KeyDown", {
	params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];

    if !((objectparent player) in (missionNamespace getVariable ["TNY_protectedVehicles", []])) exitWith {};

	if (_key isEqualTo DIK_Z) then
	{
		if (_shift) then {
            // toggle laser warning system
            private _active = (localnamespace getVariable ["TNY_laserWarningActive", false]);
            private _newState = !_active;
            localNamespace setVariable ["TNY_laserWarningActive", _newState];
            private _fnc_updateText = {
                params ["_color", "_text"];
                private _formattedText = format ["<t color='%1' size='.8'>LASER WARNING SYSTEM<br/><br/>%2</t>", _color, _text];
                [_formattedText, 0.41, -0.17, 1.1, 0, 0, 18411] spawn BIS_fnc_dynamicText;
            };
            if !(_newState) then {
                stopSound (localNamespace getVariable "TNY_currentAlarm");
                ["#808080", "STATUS: INACTIVE"] call _fnc_updateText;
            } else {
                ["#ffffff", "STATUS: ACTIVE"] call _fnc_updateText;
            }
        } else {
            private _veh = vehicle player;
            if (player isEqualTo commander _veh && (serverTime - ((vehicle player) getVariable ["TNY_activateHardkillTimer", 0])  < 1.7)) then {
                _veh setVariable ["TNY_engageHardkill", true, true];
            };
            if (player isEqualTo gunner _veh) then {
                private _lastActive = _veh getVariable ["TNY_softkillLastActive", -40];
                if (serverTime - _lastActive < 40) exitWith {};
                _veh setVariable ["TNY_softkillLastActive", serverTime];
            };
        };
	};

	false;
}];