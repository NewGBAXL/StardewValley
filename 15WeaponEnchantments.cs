// Decompiled with JetBrains decompiler
// Type: StardewValley.CrusaderEnchantment
// Assembly: Stardew Valley, Version=1.5.6.22018, Culture=neutral, PublicKeyToken=null
// MVID: BEBB6D18-4941-4529-AC12-B54F0C61CC20
// Assembly location: C:\Program Files (x86)\Steam\steamapps\common\Stardew Valley\Stardew Valley.dll

using StardewValley.Monsters;

namespace StardewValley
{
  public class CrusaderEnchantment : BaseWeaponEnchantment
  {
    protected override void _OnDealDamage(
      Monster monster,
      GameLocation location,
      Farmer who,
      ref int amount)
    {
      switch (monster)
      {
        case Ghost:
        case Skeleton:
        case Mummy:
        case ShadowBrute:
        case ShadowShaman:
        case ShadowGirl:
        case ShadowGuy:
        case Shooter:
          amount = (int) ((double) amount * 1.5);
          break;
      }
    }

    public override string GetName() { return "Crusader"; }
  }
}

