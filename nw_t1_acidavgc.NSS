//::///////////////////////////////////////////////
//:: Average Acid Blob
//:: NW_T1_AcidAvgC
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target is hit with a blob of acid that does
    5d6 Damage and holds the target for 3 rounds.
    Can make a Reflex save to avoid the hold effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 4th, 2001
//:://////////////////////////////////////////////
//::Modyfication by Moreus 2009
#include "NW_I0_SPELLS"
//TrapStart
void UseTrap(object oTarget);

void main()
{
object oTarget = GetEnteringObject();
object oTC= GetTrapCreator(OBJECT_SELF);
if(GetIsObjectValid(oTC))
AssignCommand(oTC,UseTrap(oTarget));
else
UseTrap(oTarget);
}

void UseTrap(object oTarget)
{
    //Declare major variables
	
    int nDuration = 3;
    effect eDam = EffectDamage(d6(5), DAMAGE_TYPE_ACID);
	int nSaveDC = 20;
    effect eHold = EffectParalyze(nSaveDC, SAVING_THROW_FORT);
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
    effect eDur = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eLink = EffectLinkEffects(eHold, eDur);
    int nDamage;

    //Make Reflex Save
    if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, nSaveDC, SAVING_THROW_TYPE_TRAP))
    {
        //Apply Hold and Damage
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
    }
    else
    {
        //Apply Damage
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}