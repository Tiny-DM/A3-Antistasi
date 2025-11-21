localNamespace setVariable ["TNY_incomingVisualScript", _thisScript];

private _fnc_updateText = {
    params ["_color", "_text", "_detail", "_colorDetail", "_text2"];
    private _formattedText = format ["<t color='%1' size='.8' shadow='0'>ACTIVE PROTECTION<br/><br/>%2<br/><br/></t><t color='%4' size='.8' shadow='0'>%3<br/><br/></t><t color='%1' size='.8' shadow='0'>%5</t>", _color, _text, _detail, _colorDetail, _text2];
    [_formattedText, -0.41, -0.17, 1.1, 0, 0, 18412] spawn BIS_fnc_dynamicText;
};
// ["<t color='#ff0000' size='2' shadow='0'>Z FOR HARDKILL</t>", 0, 0.78, 1.1, 0, 0, 18412] spawn BIS_fnc_dynamicText;
private _fnc_updateWarning = {
    private _formattedText = format ["<t color='#ff0000' size='2' shadow='0'>PRESS Z TO HARDKILL</t>"];
    [_formattedText, 0, 0.78, 1.6, 0, 0, 18413] spawn BIS_fnc_dynamicText;
};

while {!isNull objectParent player} do {
    sleep 0.1;
    private _threat = (vehicle player) getVariable ["TNY_currentThreat", []];
    private _details = switch (true) do {
        case (player isEqualTo commander vehicle player): {
            private _charges = (vehicle player) getVariable ["TNY_remHardkillCharges", 0];
            [format ["HARDKILL CHARGES: %1", _charges], ["#00ff00","#ff0000"] select (_charges isEqualTo 0)];
        };
        case (player isEqualTo gunner vehicle player): {
            private _lastActive = (vehicle player) getVariable ["TNY_softkillLastActive", 0];
            if (serverTime < (_lastActive + 10)) exitWith {
                [format ["DAZZLERS: BURNING"], "#ff0000"];
            };
            if (serverTime < (_lastActive + 40)) exitWith {
                [format ["DAZZLERS: RECHARGING"], "#FF7F27"];
            };
            [format ["DAZZLERS: READY"], "#00ff00"]
        };
        default {
            ["", "#ffffff"]
        };
    };
    _details params ["_detail", "_colorDetail"];
    if (_threat isEqualTo []) then { 
        ["#ffffff", "STATUS: READY", _detail, _colorDetail, ""] call _fnc_updateText;
        continue
    };
    _threat params ["_dist", "_dir"];
    ["#ff0000", "STATUS: ENGAGED", _detail, _colorDetail, format ["DISTANCE: %1m<br/><br/>HEADING: %2", round _dist, round _dir]] call _fnc_updateText;

    if ((player isEqualTo commander vehicle player) && (serverTime - ((vehicle player) getVariable ["TNY_activateHardkillTimer", 0])  < 1.7)) then {
        call _fnc_updateWarning;
    };

    private _currentSound = localNamespace getVariable ["TNY_currentAlarmMissile", -1];
    if ((soundParams _currentSound) isNotEqualTo []) then { continue };
    _sound = playSoundUI ["Orange_Car_Alarm", 0.7, 1, true];
    localNamespace setVariable ["TNY_currentAlarmMissile", _sound];
};


// ["#ffffff", format ["STATUS: ACTIVE"]] call _fnc_updateText;
// vtolAlarm, Orange_Car_Alarm