// Decompiled with JetBrains decompiler
// Type: StardewValley.EfficientToolEnchantment
// Assembly: Stardew Valley, Version=1.5.6.22018, Culture=neutral, PublicKeyToken=null
// MVID: BEBB6D18-4941-4529-AC12-B54F0C61CC20
// Assembly location: C:\Program Files (x86)\Steam\steamapps\common\Stardew Valley\Stardew Valley.dll

using StardewValley.Tools;

namespace StardewValley
{
  public class EfficientToolEnchantment : BaseEnchantment
  {
    public override string GetName() { return "Efficient"; }

    public override bool CanApplyTo(Item item) { return item is Tool && !(item is MilkPail) && !(item is MeleeWeapon) && !(item is Shears) && !(item is Pan) && !(item is Wand) && !(item is Slingshot); }

    protected override void _ApplyTo(Item item)
    {
      base._ApplyTo(item);
      Tool tool = item as Tool;
      if (tool == null)
        return;
      tool.IsEfficient = true;
    }

    protected override void _UnapplyTo(Item item)
    {
      base._UnapplyTo(item);
      Tool tool = item as Tool;
      if (tool == null)
        return;
      tool.IsEfficient = false;
    }
  }
}


