/*
Maintainer: Tiny
    Creates a final stand when the campaign is over. Defend the last assault and win.

Scope: Server
Environment: Scheduled, should be spawned

Arguments:
    <STRING> Marker to attack (airbase)
    <SIDE> Side to attack
*/

params ["_mrkDest","_side"];

private _carrier = ["CSAT_carrier", "NATO_carrier"] select (_side == Occupants);

[_mrkDest, _carrier, 3] spawn A3A_fnc_wavedAttack;