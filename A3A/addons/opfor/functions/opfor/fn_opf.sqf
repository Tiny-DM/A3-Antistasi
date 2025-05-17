/* 
Change a given object or array (definition basically) into its opfor equivalent
Typically these will be the same name with the suffix _OPF
Items are checked against a dictionary first and then the approximated suffix is returned
e.g. a commanderX input will be converted into a commanderX_OPF output

Function name kept short to encourage liberal usage
*/

params ["_input"]; // string of object var name

private _dictRef = A3A_opforDict getOrDefault [_input, "NO ENTRY"];
private _strOutput = if (_dictRef isEqualTo "NO ENTRY") then {
    format ["%1_OPF",_input];
} else {
    _dictRef;
};

_strOutput;