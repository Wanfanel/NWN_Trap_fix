//::///////////////////////////////////////////////
//:: Fatal Frost Trap
//:: mor_t1_coldfatalc
//:: 
//:://////////////////////////////////////////////
/*
    Strikes the entering object with a blast of
    cold for 12d4 damage. Fortitude save to avoid
    being paralyzed for 4 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Janusz'Moreus'Gomułkiewicz
//:: Created On: 24.I.2009
//::///////////////////////////////////////////////
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
    effect eDam = EffectDamage(d4(12), DAMAGE_TYPE_COLD);
	int nSaveDC = 20;
    effect eParal = EffectParalyze(nSaveDC, SAVING_THROW_FORT);
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eFreeze = EffectVisualEffect(VFX_DUR_BLUR);
    effect eLink = EffectLinkEffects(eParal, eFreeze);
    if(!MySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_COLD))
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(5));
    }
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}