// Decompiled with JetBrains decompiler
// Type: StardewValley.Network.NetDancePartner
// Assembly: Stardew Valley, Version=1.5.6.22018, Culture=neutral, PublicKeyToken=null
// MVID: BEBB6D18-4941-4529-AC12-B54F0C61CC20
// Assembly location: C:\Program Files (x86)\Steam\steamapps\common\Stardew Valley\Stardew Valley.dll

using Netcode;
using System;

namespace StardewValley.Network
{
  public class NetDancePartner : INetObject<NetFields>
  {
    private readonly NetFarmerRef farmer = new NetFarmerRef();
    private readonly NetString villager = new NetString();

    public Character Value
    {
      get { return this.GetCharacter(); }
      set { this.SetCharacter(value); }
    }

    public NetFields NetFields { get; } = new NetFields();

    public NetDancePartner() { return this.NetFields.AddFields((INetSerializable) this.farmer.NetFields, (INetSerializable) this.villager); }

    public NetDancePartner(Farmer farmer) { return this.farmer.Value = farmer; }

    public NetDancePartner(string villagerName) { return this.villager.Value = villagerName; }

    public Character GetCharacter()
    {
      if (this.farmer.Value != null)
        return (Character) this.farmer.Value;
      return Game1.CurrentEvent != null && this.villager.Value != null ? (Character) Game1.CurrentEvent.getActorByName(this.villager.Value) : (Character) null;
    }

    public void SetCharacter(Character value)
    {
      switch (value)
      {
        case null:
          this.farmer.Value = (Farmer) null;
          this.villager.Value = (string) null;
          return;
        case Farmer:
          this.farmer.Value = value as Farmer;
          this.villager.Value = (string) null;
          return;
        case NPC:
          if ((value as NPC).isVillager())
          {
            this.farmer.Value = (Farmer) null;
            this.villager.Value = (value as NPC).Name;
            return;
          }
          break;
      }
      throw new ArgumentException(value.ToString());
    }

    public NPC TryGetVillager()
    {
      if (this.farmer.Value != null)
        return (NPC) null;
      return Game1.CurrentEvent != null && this.villager.Value != null ? Game1.CurrentEvent.getActorByName(this.villager.Value) : (NPC) null;
    }

    public Farmer TryGetFarmer() { return this.farmer.Value; }

    public bool IsFarmer() { return this.TryGetFarmer() != null; }

    public bool IsVillager() { return this.TryGetVillager() != null; }

    public int GetGender() { return this.IsFarmer() ? (!this.TryGetFarmer().IsMale ? 1 : 0) : (this.IsVillager() ? this.TryGetVillager().Gender : 2); }
  }
}




