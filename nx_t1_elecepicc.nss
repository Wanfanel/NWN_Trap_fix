//::///////////////////////////////////////////////
//:: Electrical Epic Trap
//:: NW_T1_ElecEpicC.nss
//:: Copyright (c) 2007 Obsidian Ent.
//:://////////////////////////////////////////////
/*
    The creature setting off the trap is struck by
    a strong electrical current that arcs to 6 other
    targets doing 50d6 damage.  Can make a Reflex
    save for half damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Ryan Young
//:: Created On: 1.22.2007
//:://////////////////////////////////////////////
//::Modyfication by Moreus 2009
#include "mor_i0_traps"

void main()
{
object oTC= GetTrapCreator(OBJECT_SELF);
object oPC= GetEnteringObject();
if(GetIsObjectValid(oTC))
AssignCommand(oTC,TrapDoElectricalDamage(d6(50),35,6,oPC));
else
  TrapDoElectricalDamage(d6(50),35,6,oPC);
}
