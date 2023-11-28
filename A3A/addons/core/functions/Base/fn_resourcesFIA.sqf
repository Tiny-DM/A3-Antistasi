#include "..\..\script_component.hpp"
FIX_LINE_NUMBERS()
private ["_hr","_resourcesFIA","_hrT","_resourcesFIAT"];
waitUntil {!resourcesIsChanging};
resourcesIsChanging = true;
_hr = _this select 0;
_resourcesFIA = _this select 1;
if (isNil "_resourcesFIA") then {Error("_resourceFIA is nil");};
if ((isNil "_hr") or (isNil "_resourcesFIA")) exitWith {resourcesIsChanging = false};
if ((floor _resourcesFIA == 0) and (floor _hr == 0)) exitWith {resourcesIsChanging = false};
_hrT = server getVariable "hr";
_resourcesFIAT = server getVariable "resourcesFIA";

_hrT = _hrT + _hr;
_resourcesFIAT = round (_resourcesFIAT + _resourcesFIA);

if (_hrT < 0) then {_hrT = 0};
if (_resourcesFIAT < 0) then {_resourcesFIAT = 0};

server setVariable ["hr",_hrT,true];
server setVariable ["resourcesFIA",_resourcesFIAT,true];
resourcesIsChanging = false;

_textX = "";
_hrSim = "";
if (_hr > 0) then {_hrSim = "+"};
_resourcesFIASim = "";
if (_resourcesFIA > 0) then {_resourcesFIASim = "+"};

_textX = 
format ["<t size='0.6' color='#C1C0BB'>" + 
[localize "A3A_fn_resourcesFIA_resources"] + 
".<br/> <t size='0.5' color='#C1C0BB'><br/>" + 
[localize "A3A_fn_resourcesFIA_hr"] + "<br/>" + 
[localize "A3A_fn_resourcesFIA_money"]
" €"
,FactionGet(reb,"name"),_hr toFixed 0,_resourcesFIA toFixed 0,_hrSim,_resourcesFIASim,] 

if (_textX != "") then
	{
	[petros,"income",_textX] remoteExec ["A3A_fnc_commsMP",theBoss];
	//[] remoteExec ["A3A_fnc_statistics",[teamPlayer,civilian]];
	};
