private _sideCheck = _this select 0;

private _sideWanted = switch (true) do {
    case (_sideCheck in ["OPF","IND"]): {
        [independent,east] select (_sideCheck isEqualTo "OPF");
    };
    case (typeName _sideCheck in ["OBJECT","GROUP","LOCATION"]): {
        side _sideCheck;
    };
    case (hasInterface): { // final check 
        side leader group player;
    };
    default {
        independent;
    };
};

_sideWanted;