//::///////////////////////////////////////////////
//:: Deadly Frost Trap
//:: X2_T1_ColdEpicC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Strikes the entering object with a blast of
    cold for 40d4 damage. Fortitude save to avoid
    being paralyzed for 4 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: June 09, 2003
//:://////////////////////////////////////////////
//::Modyfication by Moreus 2009
#include "NW_I0_SPELLS"
//TrapStart
void UseTrap(object oTarget);

void main()
{
object oTC= GetTrapCreator(OBJECT_SELF);
object oPC= GetEnteringObject();
if(GetIsObjectValid(oTC))
AssignCommand(oTC,UseTrap(oPC));
else
UseTrap(oPC);
}

void UseTrap(object oTarget)
{
    //Declare major variables
    effect eDam = EffectDamage(d4(40), DAMAGE_TYPE_COLD);
	int nSaveDC = 30;
    effect eParal = EffectParalyze(nSaveDC, SAVING_THROW_FORT);
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eFreeze = EffectVisualEffect(VFX_DUR_BLUR);
    effect eLink = EffectLinkEffects(eParal, eFreeze);
    if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_COLD))
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(4));
    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}