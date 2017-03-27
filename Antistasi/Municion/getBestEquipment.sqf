/*
_soldiers = [
    "B_G_Soldier_LAT_F", // AT rifleman
    "B_G_Soldier_F", // rifleman
    "B_G_Soldier_GL_F", // granadier
    "B_G_Soldier_lite_F", // AA rifleman
    "B_G_Soldier_SL_F", // squad leader
    "B_G_Soldier_TL_F", // team leader
    "B_G_Soldier_AR_F", // autorifleman
    "B_G_medic_F",
    "B_G_engineer_F",
    "B_G_Soldier_exp_F", // exp. specialist
    "B_G_Soldier_A_F", // ammo bearer
    "B_G_Soldier_M_F", // sniper
    "B_G_Survivor_F",
];
*/
params ["_type"];

private _vest = ([caja, "vest"] call AS_fnc_getBestItem);
private _helmet = ([caja, "helmet"] call AS_fnc_getBestItem);

// survivors have no weapons.
if (_type == "B_G_Survivor_F") exitWith {};

// choose a list of weapons to choose from the unit type.
// see initVar.sqf where AS_weapons is populated.
private _primaryWeapons = (AS_weapons select 0) + (AS_weapons select 13) + (AS_weapons select 14); // Assault Rifles + Rifles + SubmachineGun
private _secondaryWeapons = [];
private _useBackpack = false;
private _backpackItems = [];
private _scopeType = "rifleScope";  // "rifleScope" or "sniperScope" to choose betwene "low min zoom and high max zoom" or "very high max zoom".
private _primaryMagCount = 6 + 1;  // +1 for the weapon.
if (_type == "B_G_Soldier_GL_F") then {
    _primaryWeapons = AS_weapons select 3; // G. Launchers
    // todo: check that secondary magazines exist.
};
if (_type == "B_G_Soldier_AR_F") then {
    _primaryWeapons = AS_weapons select 6; // Machine guns
    _useBackpack = true;
    _primaryMagCount = 2 + 1;  // because MG clips have more bullets.
};
if (_type == "B_G_Soldier_M_F") then {
    _primaryWeapons = AS_weapons select 15;  // Snipers
    _scopeType = "sniperScope";
    _primaryMagCount = 8 + 1;  // because snipers clips have less bullets.
};
if (_type == "B_G_Soldier_LAT_F") then {
    // todo: this list includes AT and AA. Fix it.
    _secondaryWeapons = (AS_weapons select 8); // missile launchers
    _useBackpack = true;
};
if (_type == "B_G_Soldier_lite_F") then {
    // todo: this list includes AT and AA. Fix it.
    _secondaryWeapons = (AS_weapons select 8); // missile launchers
    _useBackpack = true;
};
if (_type == "B_G_medic_F") then {
    _useBackpack = true;
    _backpackItems = [] call AS_fnc_FIAMedicBackpack;
};
if (_type == "B_G_engineer_F") then {
    _useBackpack = true;
    _backpackItems = [["ToolKit", 1]];
};

private _backpack = "";
if (_useBackpack) then {
    _backpack = ([caja, "backpack"] call AS_fnc_getBestItem);
};

private _primaryWeapon = ([caja, _primaryWeapons, _primaryMagCount] call AS_fnc_getBestWeapon);
private _primaryMags = [[], []];
if (_primaryWeapon != "") then {
    _primaryMags = ([caja, _primaryWeapon, _primaryMagCount] call AS_fnc_getBestMagazines);
};

private _secondaryWeapon = ([caja, _secondaryWeapons, 2 + 1] call AS_fnc_getBestWeapon);
private _secondaryMags = [[], []];
if (_secondaryWeapon != "") then {
    _secondaryMags = ([caja, _secondaryWeapon, 2 + 1] call AS_fnc_getBestMagazines);
};

_scope = ([caja, _scopeType] call AS_fnc_getBestItem);

[_vest, _helmet, _backpack, _primaryWeapon, _primaryMags, _secondaryWeapon, _secondaryMags, _scope, _backpackItems]
