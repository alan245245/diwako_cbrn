if(!isServer) exitWith {};

//We get this now and pass it everytime
CBRN_ACEdetected = (isClass(configfile >> "CfgPatches" >> "ace_medical"));
CBRN_frameIndex = 0;

addMissionEventHandler ["EachFrame", {
	//Every 30 frames
	if(CBRN_frameIndex == 30) then {
		CBRN_frameIndex = 0;
		//Just schedule this to be executed, no hurry, we have 30 frames
		[] spawn {
			{
				private _hasHandler = (_x getVariable ["hasHandler",false]);
				systemChat format ["%1", _hasHandler];
				if(_hasHandler) then {

				} else {
					//Setup the unit
					//[_x] call CBRN_fnc_addGASEventHandlers;
					
					//If ACE is installed we also add the healed event handler
					if(CBRN_ACEdetected) then {
						["ace_treatmentSucceded", {
							params ["_medic", "_patient", "_bodyPart", "_classname"];

							//If we are using a medicine
							{
								if(_classname == (_x select 0)) then {
									_currentExposure = (_patient getVariable ["cbrn_damage", 0]);
									_val = (_x select 1);


									_newExposure = (((_currentExposure) - _val) max 0);
									_patient setVariable ["cbrn_damage", _newExposure];
									break;
								};
							}forEach cbrn_medicines;
						}] call CBA_fnc_addEventHandler;
						_x setVariable ["hasHandler", true];
					};
				};
			}forEach allUnits;
		};
	};
	//Next frame
	CBRN_frameIndex = CBRN_frameIndex + 1;
}];