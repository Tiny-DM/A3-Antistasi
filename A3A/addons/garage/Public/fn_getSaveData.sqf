/*
    Author: [Håkon]
    Description:
        gets garage save data

    Arguments: <Nil>

    Return Value:
    <Struct> [
        <Array> [
            Array [
                <Struct> [
                    <String> Vehicle display name
                    <String> Vehicle classname
                    <String> Vehicl lock UID
                    <String> Vehicle check out UID
                    <Int>    Vehicle UID
                ] Vehicle data
            ] Vehicle category
        ] Garage vehicle data

        <Int> Last vehicle UID

        <Array> [
            <Array> [Vehicle UID] Ammo sources
            <Array> [Vehicle UID] Fuel sources
            <Array> [Vehicle UID] Repair sources
        ] Sources
    ] Garage save data

    Scope: Server
    Environment: unscheduled
    Public: Yes
    Dependencies:

    Example: [] call HR_GRG_fnc_getSaveData;

    License: APL-ND
*/
if (!isServer) exitWith {};
#include "defines.inc"
FIX_LINE_NUMBERS()
params ["_side"];
if (isNil "HR_GRG_Vehicles") then { [] call HR_GRG_fnc_initServer };
private _reqGarage = (["HR_GRG_Vehicles",_side] call A3A_fnc_copf);
private _reqSources = (["HR_GRG_Sources",_side] call A3A_fnc_copf);

//get data to be saved
private _garage = +_reqGarage; //have had issus with refrences persisting trough save procces causing mangling of save data
private _UID = HR_GRG_UID;
private _sources = [+(_reqSources#0),+(_reqSources#1),+(_reqSources#2)];

//correct some data to savable state
{
    {
        _y set [3, ""]; //remove checkouts
    } forEach _x;
} forEach _garage;

Trace("Save data generated");
//return save data struct
[_garage, _UID, _sources];
