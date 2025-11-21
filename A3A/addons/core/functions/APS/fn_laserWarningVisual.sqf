localNamespace setVariable ["TNY_laserWarningVisualScript", _thisScript];

private _fnc_updateText = {
    params ["_color", "_text"];
    private _formattedText = format ["<t color='%1' size='.8' shadow='0'>LASER WARNING SYSTEM<br/><br/>%2</t>", _color, _text];
    [_formattedText, 0.41, -0.17, 1.1, 0, 0, 18411] spawn BIS_fnc_dynamicText;
};

while {!isNull objectParent player} do {
    sleep 0.1;
    //["<t color='#ff0000' size='.8'>LASER WARNING SYSTEM<br /><br />STATUS: PAINTED<br /><br />THREAT HEADING: 340</t>",0.41,-0.17,4,0,0,69] spawn BIS_fnc_dynamicText;
    if !(localnamespace getVariable ["TNY_laserWarningActive", false]) then {
        ["#808080", "STATUS: INACTIVE"] call _fnc_updateText;
        continue;
    };
    private _activeLaserThreat = (vehicle player) getVariable ["TNY_activeLaserThreat", -1];
    if (_activeLaserThreat > -1) then {
        ["#ff0000", format ["STATUS: PAINTED<br/><br/>THREAT HEADING: %1", round _activeLaserThreat]] call _fnc_updateText;
        private _currentSound = localNamespace getVariable ["TNY_currentAlarmLaser", -1];
        if ((soundParams _currentSound) isNotEqualTo []) exitWith {};
        _sound = playSoundUI ["vtolalarm", 0.7, 1, true];
        localNamespace setVariable ["TNY_currentAlarmLaser", _sound];
    } else {
        ["#ffffff", format ["STATUS: ACTIVE"]] call _fnc_updateText;
    };
};



// vtolAlarm, Orange_Car_Alarm