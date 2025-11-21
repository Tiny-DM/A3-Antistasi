params [
    "_veh",
    ["_hardkillCharges",4]
];
// softkill -> hardkill distance
// # of charges
// hardkill distance

if !(isServer) exitWith {diag_log format ["ERROR IN APS FOR %1 (%2): Not run as server", _veh, typeOf _veh]};
if !(canSuspend) exitWith {diag_log format ["ERROR IN APS FOR %1 (%2): Must be spawned", _veh, typeOf _veh]};

_veh setVariable ["TNY_activeThreats", [], true]; // ["unit", "missile obj", "ammo"]. 
_veh setVariable ["TNY_remHardkillCharges", _hardkillCharges, true];

private _protectedVehicles = missionNamespace getVariable ["TNY_protectedVehicles", []];
_protectedVehicles pushBackUnique _veh;
missionNamespace setVariable ["TNY_protectedVehicles", _protectedVehicles, true];

_veh addEventHandler ["IncomingMissile", {
    _this spawn {
        params ["_target", "_ammo", "_vehicle", "_instigator", "_missile"];
        sleep 1;
        isNil {
            private _activeMissiles = _target getVariable ["TNY_activeThreats", []];
            _activeMissiles pushBackUnique [_target, _missile, _ammo];
            _target setVariable ["TNY_activeThreats", _activeMissiles];
        };
    };
}];

private _fnc_vectorToUsefulShit = {
    params ["_xRot", "_yRot", "_zRot"];
    [_xRot atan2 _yRot, asin _zRot];
};

while {alive _veh} do {
    sleep 0.1;
    // crew monitoring aps?
    private _gunner = gunner _veh;
    private _commander = commander _veh;
    if (isNull _gunner && isNull _commander) then { continue };

    if (isPlayer _gunner || isPlayer _commander) then {
        private _nearLasers = _veh nearObjects ["LaserTarget", 10];
        private _currentThreat = if (_nearLasers isNotEqualTo []) then {
            
            private _laser = _nearLasers#0;
            private _source = objNull;
            private _sourceIndex = allPlayers findIf {(laserTarget _x) isEqualTo _laser};
            if (_sourceIndex == -1) then {_sourceIndex = (allUnits) findIf {(laserTarget _x) isEqualTo _laser}} else {_source = allPlayers select _sourceIndex};
            if (_sourceIndex == -1) exitWith {};
            if (_sourceIndex isEqualType -1) then {_source = allUnits select _sourceIndex};
            _veh getDir _source;
        } else {
            -1
        };
        private _savedThreat = _veh getVariable ["TNY_activeLaserThreat", -1];
        if (_savedThreat isNotEqualTo _currentThreat) then {_veh setVariable ["TNY_activeLaserThreat", _currentThreat, true]};
    };

    // no threats
    // this is actually probably a faster exit than querying the crew BUTTTT we need laser warning
    private _threats = _veh getVariable ["TNY_activeThreats", []];
    if (_threats isEqualTo []) then { continue };
    private _nearestPair = [objNull, 3000];
    {
        _x params ["_target", "_missile"];
        private _dist = _missile distance _veh;
        if (_nearestPair#1 > _dist) then {_nearestPair = [_missile, _dist]};
    } forEach _threats;
    _nearestPair params ["_missile", "_dist"];
    if (isNull _missile) then { _veh setVariable ["TNY_currentThreat", [], true]; continue };
    _veh setVariable ["TNY_currentThreat", [_dist, _veh getDir _missile], true];
    private _timeOfFlight = _dist / (speed _missile);
    if (_timeOfFlight < 1.7) then {
        if (((_veh getVariable ["TNY_activateHardkillTimer", 0]) + 2) < serverTime) then {
            _veh setVariable ["TNY_activateHardkillTimer", serverTime, true];
        };
        if (_timeOfFlight < 0.5) then {
            [_missile, _veh] spawn {
                params ["_missile", "_veh"];
                waitUntil {sleep 0.03; _missile distance _veh < 30};
                private _threats = _veh getVariable ["TNY_activeThreats", []];
                _threats deleteAt (_threats findIf {_x#1 isEqualTo _missile});
                _veh setVariable ["TNY_activeThreats", _threats, true];
                _veh setVariable ["TNY_currentThreat", [], true];
                if !(_veh getVariable ["TNY_engageHardkill", false]) exitWith {};
                triggerAmmo _missile;
                _veh setVariable ["TNY_engageHardkill", false, true];
                private _charges = _veh getVariable ["TNY_remHardkillCharges", 0];
                _veh setVariable ["TNY_remHardkillCharges", _charges - 1, true];
            };
        };
    } else {
        private _lastActive = _veh getVariable ["TNY_softkillLastActive", 0];
        if (serverTime > (_lastActive + 10)) exitWith {};
        private _turretAngle = (_veh weaponDirection (currentWeapon gunner _veh)) call _fnc_vectorToUsefulShit;
        private _missileAngle = (vectorNormalized velocity _missile) call _fnc_vectorToUsefulShit;
        private _horizDiff = abs ((_turretAngle#0) - (_missileAngle#0));
        private _vertiDiff = abs ((_turretAngle#1) - (_missileAngle#1));
        private _angleOffset = sqrt ((_horizDiff^2) + (_vertiDiff^2)) // gonna kiss my boy(s) pythagoras
        if (_angleOffset < 10)

    };



};

private _protectedVehicles = missionNamespace getVariable ["TNY_protectedVehicles", []];
_protectedVehicles deleteAt (_protectedVehicles find _veh);
missionNamespace setVariable ["TNY_protectedVehicles", _protectedVehicles, true];