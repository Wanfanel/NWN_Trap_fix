//::///////////////////////////////////////////////
//:: Strong Frost Trap
//:: NW_T1_ColdMinC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Strikes the entering object with a blast of
    cold for 3d4 damage. Fortitude save to avoid
    being paralyzed for 3 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 16th , 2001
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

    effect eDam = EffectDamage(d4(5), DAMAGE_TYPE_COLD);
	int nSaveDC = 14;
    effect eParal = EffectParalyze(nSaveDC, SAVING_THROW_FORT);
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eFreeze = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eLink = EffectLinkEffects(eParal, eFreeze);
    
    if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_TRAP))
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(3));
    }
    
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}